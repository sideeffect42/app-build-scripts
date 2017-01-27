#!/usr/bin/env bash

APPLICATION='jq'
VERSION=1.5


# download

OUT_FILENAME="${APPLICATION}-${VERSION}.tar.gz"
OUT_PATH="${PWD}/${OUT_FILENAME}"
HTTP_URL="https://github.com/stedolan/jq/releases/download/jq-${VERSION}/${OUT_FILENAME}"

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