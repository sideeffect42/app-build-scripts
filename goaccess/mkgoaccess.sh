#!/usr/bin/env bash

APPLICATION='goaccess'
VERSION=1.1.1

GEOIP_VERSION=1.6.9

set -e -x
pushd -n "$(pwd)"

DIR="$(dirname "$0")"



# ==== GeoIP ====

pushd "${DIR}/GeoIP-${GEOIP_VERSION}"

./configure --prefix="$HOME/app/goaccess" --enable-static
make
make check
make install

popd # go back to 

cd "${DIR}/${APPLICATION}-${VERSION}"


# === configure ===

./configure CPPFLAGS="-I${HOME}/app/goaccess/include -I/usr/include" \
	 LDFLAGS="-L${HOME}/app/goaccess/lib -L/usr/lib" \
	--prefix="${HOME}/app/${APPLICATION}" \
	--sysconfdir="$HOME/etc/${APPLICATION}" \
	--enable-utf8 --enable-geoip --with-getline --with-openssl

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
