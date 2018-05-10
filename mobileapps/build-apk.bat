@echo off
set "PATH=Z:\home\user\development\tits-build-env\FlashDevelop-plus-fl-libs-flex-AIR\Apps\flexairsdk\4.6.0+25.0.0\bin;C:\Program Files\Java\jre1.8.0_121\bin"

echo Building APK. Please wait.
echo %PATH%
adt -package -target apk-captive-runtime -storetype pkcs12 -keystore certificate.p12 -storepass 1234 TiTS_AIR.apk tits-app.xml TiTS_AIR.swf Default.png icons > log.txt 2>&1

