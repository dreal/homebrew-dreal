#!/usr/bin/env bash
ID=$1
PASSWORD=$2
VERSION=$3
case `uname -r` in
  14.*)
    OSX_NAME="yosemite"
    ;;
  15.*)
    OSX_NAME="el_capitan"
    ;;
  16.*)
    OSX_NAME="sierra"
    ;;
  17.*)
    OSX_NAME="high_sierra"
    ;;
  *)
    OSX_NAME="unknown"
    ;;
esac

BOTTLE_FILENAME=dreal-${VERSION}.${OSX_NAME}.bottle.tar.gz
BINTRAY_URL=https://api.bintray.com/content/dreal/homebrew-dreal/dreal

if [ -e ${BOTTLE_FILENAME} ]
then
  # Upload Files
  curl -T ${BOTTLE_FILENAME} -u${ID}:${PASSWORD} ${BINTRAY_URL}/${VERSION}/${BOTTLE_FILENAME}
  # Publish version
  curl -X POST -u${ID}:${PASSWORD} ${BINTRAY_URL}/${VERSION}/publish
  # Remove the bottle
  # rm -v ${BOTTLE_FILENAME}
else 
  echo "File not found: ${BOTTLE_FILENAME}"
fi
