#!/usr/bin/env bash

APPLICATION='poco'
VERSION=1.7.7


set -e -x
pushd -n "$(pwd)"

DIR="$(cd "$(dirname "$0")" && pwd)"

cd "${DIR}/${APPLICATION}-${VERSION}"


# === configure ===

./configure --prefix="$HOME/app/${APPLICATION}" \
	--static --no-sharedlibs --unbundled

# === make ===

gmake
gmake install

# === package ===

TAR_OUT="${DIR}/tar/${APPLICATION}-${VERSION}-$(date +%Y%m%d).tar.gz"
mkdir -p "$(dirname "$TAR_OUT")"
(cd "$HOME" && \
	find "./app/${APPLICATION}" "./etc/${APPLICATION}" -prune -type d -print0 2>&- \
	| tar --null -cvzf "$TAR_OUT" --files-from -)

echo "Stored tarball in: ${TAR_OUT}"

popd # restore working directory
