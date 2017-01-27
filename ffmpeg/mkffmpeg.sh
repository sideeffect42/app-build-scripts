#!/usr/bin/env bash

echo 'NOTE: This build script is not finished yet.'

APPLICATION='ffmpeg'
VERSION=3.2.2

ASS_VERSION=0.13.6
FRIBIDI_VERSION=0.19.7

set -e -x
pushd -n "$(pwd)"

DIR="$(cd "$(dirname "$0")" && pwd)"

FF_SRCDIR="${DIR}/${APPLICATION}-${VERSION}"
ASS_SRCDIR="${DIR}/libass-${ASS_VERSION}"
FRIBIDI_SRCDIR="${DIR}/fribidi-${FRIBIDI_VERSION}"

# ==== fribidi ====

pushd "$FRIBIDI_SRCDIR"

mkdir -p './build'

./configure --prefix="${FRIBIDI_SRCDIR}/build" \
	--bindir="${HOME}/app/${APPLICATION}/bin" \
	--enable-static --with-glib=no
make
make install

popd

# ==== libass ====

pushd "$ASS_SRCDIR"

mkdir -p './build'

PKG_CONFIG_PATH="${FRIBIDI_SRCDIR}/build/lib/pkgconfig" \
./configure --prefix="${ASS_SRCDIR}/build" \
	--bindir="${HOME}/app/${APPLICATION}/bin" \
	--enable-static --disable-require-system-font-provider
make
make install

popd

cd "$FF_SRCDIR"

mkdir -p './build'

# ==== yasm ====

git clone --depth 1 git://github.com/yasm/yasm.git
pushd 'yasm'

autoreconf -fiv
./configure --prefix="${FF_SRCDIR}/build" --bindir="${HOME}/app/${APPLICATION}/bin"
make
make install

popd

# ==== libx264 ====

git clone --depth 1 git://git.videolan.org/x264
pushd 'x264'

PKG_CONFIG_PATH="${FF_SRCDIR}/build/lib/pkgconfig" \
./configure --prefix="${FF_SRCDIR}/build" --bindir="${HOME}/app/${APPLICATION}/bin" \
	--enable-static --disable-asm
make
make install

popd

# ==== libopus ====

git clone http://git.opus-codec.org/opus.git
pushd 'opus'

autoreconf -fiv
PKG_CONFIG_PATH="${FF_SRCDIR}/build/lib/pkgconfig" \
./configure --prefix="${FF_SRCDIR}/build" --disable-shared 
make
make install

popd

# === configure ===

GCCBIN="$(which gcc44 gcc | head -n 1)"

PKG_CONFIG_PATH="${FF_SRCDIR}/build/lib/pkgconfig" \
./configure --cc="$GCCBIN" --prefix="${FF_SRCDIR}/build" \
	--extra-cflags="-I${FF_SRCDIR}/build/include -static" \
	--extra-ldflags="-L${FF_SRCDIR}/build/lib -ldl -static" \
	--bindir="${HOME}/app/${APPLICATION}/bin" \
	--pkg-config-flags='--static' \
	--extra-libs='-lxml2 -lexpat' \
	--enable-static --disable-shared --disable-ffserver --disable-doc \
	--enable-bzlib --enable-zlib --enable-postproc \
	--enable-runtime-cpudetect --enable-libx264 --enable-gpl \
	--enable-libtheora --enable-libvorbis --enable-libmp3lame \
	--enable-gray --enable-libass --enable-libfreetype \
	--enable-libopenjpeg --enable-libspeex --enable-libopus \
	--enable-libvo-amrwbenc --enable-version3 --enable-libvpx
	
# === make ===

make
make install

# === package ===

mkdir -p "${DIR}/tar"
tar czf "${DIR}/tar/${APPLICATION}-${VERSION}-$(date +%Y%m%d).tar.gz" \
	-C "$HOME" \
	"./app/${APPLICATION}" \
	"./etc/${APPLICATION}"


popd # restore working directory
