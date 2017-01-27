#!/usr/bin/env bash

APPLICATION='poco'
VERSION=1.7.7


# download

OUT_FILENAME="${APPLICATION}-${VERSION}.tar.gz"
OUT_PATH="${PWD}/${OUT_FILENAME}"
HTTP_URL="https://pocoproject.org/releases/poco-${VERSION}/${OUT_FILENAME}"

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

tar xvf "${PWD}/${OUT_FILENAME}"
