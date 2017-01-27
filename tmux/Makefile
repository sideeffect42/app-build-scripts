APPLICATION = tmux
VERSION = 2.3

DOWNLOAD_URL = https://github.com/tmux/tmux/releases/download/$(VERSION)/$(DOWNLOAD_NAME)
DOWNLOAD_NAME = $(APPLICATION)-$(VERSION).tar.gz

SRC_DIR = $(realpath ./src)/$(APPLICATION)-$(VERSION)
$(info $(SRC_DIR))

DISTFILE_NAME = $(APPLICATION)-$(VERSION)-$(shell date +%Y%m%d).app.tar.gz

-include ../common.mk

# build targets
distfiles/$(DOWNLOAD_NAME):
	$(MKDIR_P) "$(@D)"
	curl -o "$@" -L --progress "$(DOWNLOAD_URL)"
	$(TOUCH) "$@"

$(SRC_DIR):
	$(MKDIR_P) "$@"
	$(TAR) -C "$(dir $(SRC_DIR))" -xvf "distfiles/$(DOWNLOAD_NAME)"
	$(TOUCH) "$@"
	
$(SRC_DIR)/configure: $(SRC_DIR)
	(cd "$(SRC_DIR)" ; ./configure \
		--prefix="$(SRC_DIR)/build/app" \
		--sysconfdir="$(SRC_DIR)/build/etc" \
		--enable-static)