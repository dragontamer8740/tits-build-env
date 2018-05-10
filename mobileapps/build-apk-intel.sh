#! /bin/bash
export WINEDEBUG=-all
set -o xtrace
wineconsole --backend=curses build-apk-intel.bat
set +o xtrace

#now manually re-sign the APK, since we want timestamps.
# unzip
rm -rf signing/
mkdir -p signing/
cd signing
mv ../TiTS_AIR_x86.apk .
unzip TiTS_AIR_x86.apk
rm -rf META-INF
rm TiTS_AIR_x86.apk
#re-create zipfile without signing data
zip -r TiTS_AIR_x86.apk *
# sign again, this time with a timestamp server
#jarsigner -J-DsocksProxyHost=127.0.0.1 -J-DsocksProxyPort=8080 -verbose -keystore "../certificate.p12" -storetype PKCS12 -storepass 1234 -digestalg SHA1 \
jarsigner -verbose -keystore "../certificate.p12" -storetype PKCS12 \
  -storepass 1234 -digestalg SHA1  -sigalg MD5withRSA \
  -tsa http://timestamp.digicert.com TiTS_AIR_x86.apk 1
mv TiTS_AIR_x86.apk ../TiTS_AIR_unaligned_x86.apk
cd ..
zipalign -f -v 4 TiTS_AIR_unaligned_x86.apk TiTS_AIR_x86.apk
if [ -e TiTS_AIR_unaligned_x86.apk ]; then # if zipalign worked
    rm TiTS_AIR_unaligned_x86.apk
else
    echo "==========================="
    echo "WARNING!!! - 'zipalign' could not be run. Leaving an *unaligned* APK."
    echo "This is sub-optimal. Please install 'zipalign' (part of the android command line"
    echo "developer tools; see https://developer.android.com/studio/#command-tools )."
    echo "==========================="
fi
