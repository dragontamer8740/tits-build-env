#! /bin/bash
# buildall - bourne shell version. Derived from a .bat script for windows and
# vastly improved - no hardcoded paths here!

trimTrailingSlash()
{
    case "$1" in
        */)
            # has a trailing slash, remove it                                                                                                                   
            echo "$(echo "$1" | sed 's!/*$!!g' )"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

# recreate GNU dirname in a shell function for portability.
# OS X, for example, does not have dirname (I think), since it uses mostly BSD
# utils and is only POSIX compliant at best. If anyone can implement this in a
# rigorously POSIX way, let me know.
# this takes precedence over the system's built-in dirname tool, if present.
dirname()
{
    INVAR="$(trimTrailingSlash "$1")"
    VAR="$(echo "$INVAR" |sed 's!/*$!!g'| sed 's!'"$(echo "$INVAR"|sed 's!^.*/!!g')"'!!g')"
    trimTrailingSlash "$VAR"
    # trimTrailingSlash will echo our output in the format expected for dirname
}

# find directory this script is located in. Works even through symlinks.
# stolen from stack exchange:
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd "$SCRIPTDIR"
#unset $SOURCE; not needed anymore
unset SOURCE

#get version number
#VERSIONNUM=$(grep version "$SCRIPTDIR/sourceTiTS/classes/TiTS.as"|grep =|sed 's/\t//g'| cut -d \" -f2 )
VERSIONNUM=$(grep version "./sourceTiTS/classes/TiTS.as"|grep -v '+='|grep =|sed 's/\t//g'|cut -d \" -f2|head -n 1)
# the 'head' at the end of that pipe guarantees that we don't have any newlines
# in the filename if this filter chain stops working properly in the future due
# to source code changes.


#uncomment to make this check out the latest version of the source before building.
#if [ ! -d "sourceTiTS" ]; then
#  # git clone https://github.com/fenoxo/sourceTiTS.git
#  # URL changed when fen stopped sharing up-to-date source code.
#  git clone https://github.com/OXOIndustries/TiTS-Public.git sourceTiTS
#  cd sourceTiTS
#else
#  cd sourceTiTS
#  git pull
#fi
#end of git checkout stuff.

cd "$SCRIPTDIR"
./buildDesktopSWF.sh
./buildAIRSWF.sh

#cd sourceTiTS/bin
cd "$SCRIPTDIR""/bin"
cp TITS.swf "$SCRIPTDIR/TiTS_${VERSIONNUM}.swf"
cp TITS_AIR.swf "$SCRIPTDIR/tits-air/TITS_AIR.swf"
cd "$SCRIPTDIR""/tits-air"

# ============ANDROID BUILD============
cd apk-repack
rm assets/TiTS_AIR.swf
cp ../TITS_AIR.swf assets/TiTS_AIR.swf

# *REMOVE ALL SIGNING FILES OR JARSIGNER WILL MESS UP!*
cd META-INF
rm CERT.RSA
rm 1.RSA
rm 1.SF
rm CERT.SF
cd ../

zip -r TiTS_AIR_unsigned.apk AndroidManifest.xml assets/ classes.dex lib/ META-INF/ res resources.arsc
# '1' here is the alias for signing:
jarsigner -verbose -keystore "$SCRIPTDIR/tits-air/cert.p12" -storetype PKCS12 -storepass 1234 -digestalg SHA1 -sigalg MD5withRSA TiTS_AIR_unsigned.apk 1
# pause
mv TiTS_AIR_unsigned.apk TiTS_AIR_signed_unaligned.apk



if [ -f "$SCRIPTDIR/zipalign" ]; then
  mv TiTS_AIR_unsigned.apk TiTS_AIR_signed_unaligned.apk
  # use home-made wrapper for libzipalign, if it exists.
  # '1' means clobber, '0' means don't clobber existing:
  "$SCRIPTDIR/zipalign" TiTS_AIR_signed_unaligned.apk TiTS_AIR.apk 1
  rm TiTS_AIR_signed_unaligned.apk
  mv TiTS_AIR.apk "$SCRIPTDIR/TiTS_${VERSIONNUM}.apk"
else
  mv TiTS_AIR_unsigned.apk "$SCRIPTDIR/TiTS_${VERSIONNUM}.apk"
  echo "WARNING! This APK is not aligned, expect increased memory usage when running."
  #mv TiTS_AIR_unsigned.apk "$SCRIPTDIR/TiTS_AIR_unaligned.apk"
fi
# done with android build
echo "========= Finished Android build! ========="

cd "$SCRIPTDIR/tits-air"
# =============iOS BUILD===============
cd ipa-repack
cp ../TITS_AIR.swf Payload/TiTS-droid.app/TiTS_0.6.34.swf
zip -r TiTS_AIR.ipa Payload/
mv TiTS_AIR.ipa "$SCRIPTDIR/TiTS_${VERSIONNUM}.ipa"
# done with iOS build since it requires signature defeating anyway to install so I don't have to deal with it
echo "=========   Finished iOS build!   ========="


echo DONE!
