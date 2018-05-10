#! /bin/bash
export WINEDEBUG=-all
set -o xtrace
wineconsole --backend=curses build-apk.bat
set +o xtrace

#now manually re-sign the APK, since we want timestamps.
# unzip
rm -rf signing/
mkdir -p signing/
cd signing
mv ../TiTS_AIR.apk .
unzip TiTS_AIR.apk
rm -rf META-INF
rm TiTS_AIR.apk
#re-create zipfile without signing data
zip -r TiTS_AIR.apk *
# sign again, this time with a timestamp server
#jarsigner -J-DsocksProxyHost=127.0.0.1 -J-DsocksProxyPort=8080 -verbose -keystore "../certificate.p12" -storetype PKCS12 -storepass 1234 -digestalg SHA1 \
jarsigner -verbose -keystore "../certificate.p12" -storetype PKCS12 -storepass 1234 -digestalg SHA1 -sigalg MD5withRSA -tsa http://timestamp.digicert.com TiTS_AIR.apk 1
mv TiTS_AIR.apk ../TiTS_AIR_unaligned.apk
cd ..
zipalign -f -v 4 TiTS_AIR_unaligned.apk TiTS_AIR.apk
if [ -e TiTS_AIR.apk ]; then # if zipalign worked
    rm TiTS_AIR_unaligned.apk
fi
