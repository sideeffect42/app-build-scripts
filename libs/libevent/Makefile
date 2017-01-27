LIBRARY := libevent
VERSION := 2.1.8-stable

DOWNLOAD_URL = https://github.com/libevent/libevent/archive/release-$(VERSION).tar.gz
DOWNLOAD_NAME = $(APPLICATION)-$(VERSION).tar.gz

SRC_DIR = $(realpath ./src)/$(LIBRARY)-release-$(VERSION)

DISTFILE_NAME = $(LIBRARY)-$(VERSION)-$(shell date +%Y%m%d).app.tar.gz

-include ../../common.mk

# build targets
distfiles/$(DOWNLOAD_NAME):
	$(MKDIR_P) "$(@D)"
	curl -o "$@" -L --progress "$(DOWNLOAD_URL)"
	$(TOUCH) "$@"

$(SRC_DIR): distfiles/$(DOWNLOAD_NAME)
	$(MKDIR_P) "$(@D)"
	$(TAR) -C "$(dir $(SRC_DIR))" -xvf "$<"
	$(TOUCH) "$@"

bootstrap: $(SRC_DIR)
	(cd "$(SRC_DIR)" ; ./autogen.sh)
	
$(SRC_DIR)/configure: 
	(cd "$(SRC_DIR)" ; ./configure \
		--prefix="$(SRC_DIR)/build/app" \
		--sysconfdir="$(SRC_DIR)/build/etc" \
		--enable-static)