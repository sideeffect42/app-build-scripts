#!/usr/bin/env bash

APPLICATION='xz'
VERSION=5.2.3


set -e -x
pushd -n "$(pwd)"

DIR="$(cd "$(dirname "$0")" && pwd)"

cd "${DIR}/${APPLICATION}-${VERSION}"


# === configure ===

./configure LDFLAGS='-static' --prefix="$HOME/app/${APPLICATION}" \
	--sysconfdir="$HOME/etc/${APPLICATION}" \
	--enable-static=yes --enable-werror

# === make ===

make
make install

popd

# === package ===

TAR_OUT="${DIR}/tar/${APPLICATION}-${VERSION}-$(date +%Y%m%d).tar.gz"
mkdir -p "$(dirname "$TAR_OUT")"
(cd "$HOME" && \
	find "./app/${APPLICATION}" "./etc/${APPLICATION}" -prune -type d -print0 2>&- \
	| tar --null -cvzf "$TAR_OUT" --files-from -)

echo "Stored tarball in: ${TAR_OUT}"

popd # restore working directory
