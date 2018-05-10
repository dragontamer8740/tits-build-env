#! /bin/bash
ARGSCOUNT="${#}"
if [ "$ARGSCOUNT" -ne 1 ]; then
	echo "ERROR."
	echo "This script requires exactly one argument - the version number of the game!"
else
	./build-apk.sh
	mv TiTS_AIR.apk "TiTS_""$1"".apk"
	./apk-intel.sh
	mv TiTS_AIR_x86.apk "TiTS_""$1""_x86.apk"
	./build-ipa.sh
	mv TiTS_AIR.ipa "TiTS_""$1"".ipa"
fi
