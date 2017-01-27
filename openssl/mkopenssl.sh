#!/usr/bin/env bash

APPLICATION='openssl'
VERSION=1.0.2k

set -e -x
pushd -n "$(pwd)"

DIR="$(dirname "$0")"

cd "${DIR}/${APPLICATION}-${VERSION}"


# === configure ===

./config --prefix="${HOME}/app/${APPLICATION}" \
	no-shared zlib threads


# === make ===

make
make test
make install

# === package ===

TAR_OUT="${DIR}/tar/${APPLICATION}-${VERSION}-$(date +%Y%m%d).tar.gz"
mkdir -p "$(dirname "$TAR_OUT")"
(cd "$HOME" && \
	find "./app/${APPLICATION}" "./etc/${APPLICATION}" -prune -type d -print0 2>&- \
	| tar --null -cvzf "$TAR_OUT" --files-from -)

echo "Stored tarball in: ${TAR_OUT}"

popd # restore working directory
