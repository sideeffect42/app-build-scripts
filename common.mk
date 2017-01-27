MKDIR_P ?= mkdir -p
RMDIR ?= rmdir
TAR ?= tar
TOUCH ?= touch

# directories
%/:
	$(MKDIR_P) $*

default: build

.PHONY: info build
info:
	@echo Build script for $(APPLICATION) version $(VERSION)

build: package

# template targets
.PHONY: get extract compile bootstrap configure make install package
get: distfiles/$(DOWNLOAD_NAME)
extract: get $(SRC_DIR)
compile: bootstrap configure make install
bootstrap: extract
configure: bootstrap $(SRC_DIR)/configure
make: $(SRC_DIR)/Makefile
install: $(SRC_DIR)/build
package: dist/$(DISTFILE_NAME)
	$(info Packaged app: dist/$(DISTFILE_NAME))
