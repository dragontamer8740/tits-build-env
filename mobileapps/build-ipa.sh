#! /bin/bash
export STARTDIR="$PWD"
set -o xtrace
cp TiTS_AIR.swf ipa-repack/Payload/TiTS-droid.app/TiTS_AIR.swf
cd ipa-repack
zip -r "$STARTDIR/TiTS_AIR.ipa" Payload
