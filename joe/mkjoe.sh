#!/usr/bin/env bash

APPLICATION='joe'
VERSION=4.4


set -e -x
pushd -n "$(pwd)"

DIR="$(dirname "$0")"

cd "${DIR}/${APPLICATION}-${VERSION}"


# === configure ===

./autojoe
./configure LDFLAGS='-static' --prefix="$HOME/app/${APPLICATION}" \
	--sysconfdir="$HOME/etc" \
	--disable-termcap --disable-curses

# === make ===

make
make install

# === package ===

TAR_OUT="${DIR}/tar/${APPLICATION}-${VERSION}-$(date +%Y%m%d).tar.gz"
mkdir -p "$(dirname "$TAR_OUT")"
(cd "$HOME" && \
	find "./app/${APPLICATION}" "./etc/${APPLICATION}" -prune -type d -print0 2>&- \
	| tar --null -cvzf "$TAR_OUT" --files-from -)

echo "Stored tarball in: ${TAR_OUT}"

popd # restore working directory
