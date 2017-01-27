#!/usr/bin/env bash

APPLICATION='jq'
VERSION=1.5


set -e -x
pushd -n "$(pwd)"

DIR="$(cd "$(dirname "$0")" && pwd)"

cd "${DIR}/${APPLICATION}-${VERSION}"


# === configure ===

autoreconf -fiv
./configure --prefix="$HOME/app/${APPLICATION}" \
	--sysconfdir="$HOME/etc/${APPLICATION}" \
	 --disable-valgrind --enable-all-static --enable-static

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
