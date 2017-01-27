#!/usr/bin/env bash

APPLICATION='goaccess'
VERSION=1.1.1


# download

OUT_FILENAME="${APPLICATION}-${VERSION}.tar.gz"
OUT_PATH="${PWD}/${OUT_FILENAME}"
HTTP_URL="http://tar.goaccess.io/${OUT_FILENAME}"

curl -L -o "${OUT_PATH}" "$HTTP_URL"

if [ ! -f "$OUT_PATH" ]; then
	echo 'goaccess: Download failed'
	exit 1
fi

# check archive

if ! tar tf "${OUT_PATH}" > /dev/null; then
	echo 'goaccess: Archive is invalid'
	exit 1
fi

# extract

tar xvf "${PWD}/${OUT_FILENAME}"



# get libGeoIP

GEOIP_VERSION=1.6.9
GEOIP_OUT_FILENAME="GeoIP-${GEOIP_VERSION}.tar.gz"
GEOIP_HTTP_URL="https://github.com/maxmind/geoip-api-c/releases/download/v${GEOIP_VERSION}/${GEOIP_OUT_FILENAME}"

GEOIP_OUT_PATH="${PWD}/${GEOIP_OUT_FILENAME}"
curl -L -o "$GEOIP_OUT_PATH" "$GEOIP_HTTP_URL"

if [ ! -f "$GEOIP_OUT_PATH" ]; then
	echo 'GeoIP: Download failed'
	exit 1
fi

# check archive

if ! tar tf "${GEOIP_OUT_PATH}" > /dev/null; then
	echo 'GeoIP: Archive is invalid'
	exit 1
fi

# extract

tar xvf "${PWD}/${GEOIP_OUT_FILENAME}"
