#!/usr/bin/env bash

APPLICATION='libjpeg-turbo'
VERSION=1.5.1


# download

OUT_FILENAME="${APPLICATION}-${VERSION}.tar.gz"
OUT_PATH="${PWD}/${OUT_FILENAME}"
HTTP_URL="https://downloads.sourceforge.net/project/libjpeg-turbo/${VERSION}/${OUT_FILENAME}"

curl -L -o "${OUT_PATH}" "$HTTP_URL"

if [ ! -f "$OUT_PATH" ]; then
	echo 'Download failed'
	exit 1
fi

# check archive

if ! tar tf "${OUT_PATH}" > /dev/null; then
	echo 'Archive is invalid'
	exit 1
fi

# extract

tar xvf "$OUT_PATH"


NASM_VERSION=2.12.02

# download

NASM_OUT_FILENAME="nasm-${NASM_VERSION}.tar.gz"
NASM_OUT_PATH="${PWD}/${NASM_OUT_FILENAME}"
NASM_HTTP_URL="http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/${NASM_OUT_FILENAME}"

curl -L -o "$NASM_OUT_PATH" "$NASM_HTTP_URL"

if [ ! -f "$NASM_OUT_PATH" ]; then
        echo 'Download failed'
        exit 1
fi

# check archive

if ! tar tf "$NASM_OUT_PATH" > /dev/null; then
        echo 'Archive is invalid'
        exit 1
fi

# extract

tar xvf "$NASM_OUT_PATH"
