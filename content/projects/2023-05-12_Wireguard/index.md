---
title: Setting up Wireguard
subtitle: Speedy encrypted links, let's go!
date: 2023-05-12
tags: [ Networking, OpenBSD, Security ]

type: posts
toc: true
share:
  enable: true
---

# What is?

Finishing up the basics for the new OpenBSD-based router, I needed to do a few more things. The most
important one was setting up Wireguard for VPN access. [Wireguard](https://www.wireguard.com) is a
layer 3 VPN, notable for being highly performant, secure and easy to set up. I've had it set up on
my old FreeBSD box before, so how hard can it be to set up on the new machine?

# Installation

Wireguard in OpenBSD turns out to be almost obscenely simple to set up. In OpenBSD everything is
installed with pkg_add, so just install it with ```$ pkg_add wireguard```.

In FreeBSD there was/is additional work to do as the original Wireguard implementation was revoked
from the kernel and you had to install either net/wireguard-go or net/wirguard-kmod for a userspace
solution, or as a kernel module. The OpenBSD implementation appears to be more mature, though as I
understand it the new Wireguard implementation is near ready to be merged into FreeBSD by now, if
it hasn't already.

# Configuration

The config for Wireguard is simple, with the current one looking as follows in
```/etc/wireguard/wg0.conf```:
```
[Interface]
ListenPort = 51820
PrivateKey = XXX

# Laptop
[Peer]
AllowedIPs = 10.98.0.2/32
PublicKey = YYY

# Phone
[Peer]
AllowedIPs = 10.98.0.3/32
PublicKey = ZZZ
```

We'll also need to actually bring up the interface and set everything up at boot. Wireguard isn't
started as an RC service, instead we create ```/etc/hostname.wg0```:
```
inet 10.98.0.1 255.255.255.0
up

!/usr/local/bin wg setconf wg0 /etc/wireguard/wg0.conf
```

# Handling keys

With the configuration in place, all that's left is to generate the keys for the devices. For this I
made a simple shellscript:
```
#!/usr/bin/env zsh

umask 077

SCRIPTDIR=${0:a:h}
WG="/usr/local/bin/wg"

if [ ! -e ${WG} ]; then
  echo "WireGuard not installed"
  exit 1
fi

MACHINES=(gateway laptop phone)

for M in ${MACHINES}; do
  KEYDIR="${SCRIPTDIR}/key/${M}"

  if [ ! -e "${KEYDIR}/key.private" ]; then
    echo "Creating keys for ${M}"
    mkdir -p ${KEYDIR}
    ${WG} genkey > ${KEYDIR}/key.private
    ${WG} pubkey < ${KEYDIR}/key.private > ${KEYDIR}/key.public
  else
    echo "Keys for ${M} exist, keeping them"
  fi
done
```

With this machines can be added to the MACHINES list and generated on demand. Should a key have to
be revoked we just remove the key files and run the script to get new ones.

Private keys are set up in each client, public keys are put in the PublicKey field in ```wg0.conf```
and that's it, done. 

# Finishing up

The whole thing was tested with my work laptop running Linux, connecting and accessing the network
worked like a charm! While I see a few advantages with setting up a layer 2 VPN instead, most
notably by avoiding static addressing and just running DHCP instead, the gains with Wireguard are
hard to pass up.
