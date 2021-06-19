#!/usr/bin/env bash
set -euxo pipefail

display_usage() {
    echo "usage: $0 <macOS name> <DREAL Version>"
    echo "example: $0 big_sur 4.21.06.2"

}

if [ $# -ne 2 ]
then
    display_usage
    exit 1
fi

GITHUB_RELEASE="${HOME}/go/bin/github-release"

if [ ! -f "${GITHUB_RELEASE}" ]
then
    go get github.com/github-release/github-release
fi

if [ ! -f "${GITHUB_RELEASE}" ]
then
    echo "Failed to install github-release via go get".
    echo "Please visit https://github.com/github-release/github-release and follow the installation instructions."
    exit 1
fi

if [ ! -f "./dreal--${VERSION}.${OS}.bottle.tar.gz" ]
then
    echo "File not found: ./dreal--${VERSION}.${OS}.bottle.tar.gz"
    exit 1
fi

OS=$1
VERSION=$2

${GITHUB_RELEASE} upload \
		  -u dreal \
		  -r dreal4 \
		  --tag "${VERSION}" \
		  --file "./dreal--${VERSION}.${OS}.bottle.tar.gz" \
		  -n "dreal-${VERSION}.${OS}.bottle.tar.gz"
