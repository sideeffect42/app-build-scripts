#!/usr/bin/env bash

APPLICATION='libjpeg-turbo'
VERSION=1.5.1
NASM_VERSION=2.12.02

set -e -x
pushd -n "$(pwd)"

DIR="$(cd "$(dirname "$0")" && pwd)"

# ==== nasm ====

pushd "${DIR}/nasm-${NASM_VERSION}"

./configure --prefix="$HOME/app/libjpeg-turbo" --sysconfdir="$HOME/etc/libjpeg-turbo" \
	--enable-werror
make
make install

popd
cd "${DIR}/${APPLICATION}-${VERSION}"


# === configure ===

autoreconf -fiv
mkdir -p build
cd build
sh ../configure LDFLAGS="-static -L$HOME/app/libjpeg-turbo/lib -L$HOME/app/libjpeg-turbo/lib64" \
	NASM="$HOME/app/libjpeg-turbo/bin/nasm"

# === make ===

make
make install prefix="${HOME}/app/${APPLICATION}"

# === package ===

mkdir -p "${DIR}/tar"
cd "${DIR}"
tar czf "${DIR}/tar/${APPLICATION}-${VERSION}-$(date +%Y%m%d).tar.gz" \
	-C "$HOME" \
	"./app/${APPLICATION}"


popd # restore working directory
