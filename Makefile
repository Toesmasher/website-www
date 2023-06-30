TARBALL := public.tar.bz2
TARGET := public

DOCS := $(shell find "./content" -name "*.md")

all: $(TARGET)

$(TARGET): $(DOCS)
	@hugo

$(TARBALL): $(TARGET)
	@tar cjf $(TARBALL) public

.PHONY: dev
dev:
	@hugo server

.PHONY: clean
clean:
	rm -fr $(TARBALL) $(TARGET) resources
