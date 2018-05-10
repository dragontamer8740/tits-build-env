#! /bin/bash
#@echo off

#set OLDDIR=%CD%

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
# stolen from stack exchange.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a syml$
  SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR""/""$SOURCE" # if $SOURCE was a relative syml$
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
cd "$SCRIPTDIR"
mkdir "$SCRIPTDIR""/bin" 2>/dev/null
set SOURCE=
cd sourceTiTS

rm -f "$SCRIPTDIR""/bin/TiTS_AIR_uncompressed.swf"
rm -f "$SCRIPTDIR""/bin/TiTS_AIR.swf"
set -o xtrace
java \
-Xmx1024M \
-Dsun.io.useCanonCaches=false \
-Duser.language=en \
-Duser.region=US \
-Djava.util.Arrays.useLegacyMergeSort=true \
-jar "$SCRIPTDIR""/FlashDevelop-plus-fl-libs-flex-AIR/Apps/flexairsdk/4.6.0+18.0.0/lib/mxmlc.jar" \
+flexlib="$SCRIPTDIR""/FlashDevelop-plus-fl-libs-flex-AIR/Apps/flexairsdk/4.6.0+18.0.0/frameworks" \
-load-config+="$SCRIPTDIR""/obj/TiTSAIRConfig.xml" \
-debug=true \
+configname=airmobile \
-swf-version=24 \
-managers flash.fonts.AFEFontManager \
-o "$SCRIPTDIR""/bin/TiTS_AIR_uncompressed.swf"

swfcombine -dz "$SCRIPTDIR""/bin/TiTS_AIR_uncompressed.swf" -o "$SCRIPTDIR""/bin/TiTS_AIR.swf"
if [ -e "$SCRIPTDIR""/bin/TiTS_AIR.swf" ]; then
    rm "$SCRIPTDIR""/bin/TiTS_AIR_uncompressed.swf"
    chmod 644 "$SCRIPTDIR""/bin/TiTS_AIR.swf"
else
    echo "==========================="
    echo "WARNING!!! - 'swfcombine' could not be run. Leaving an *uncompressed* SWF file"
    echo "in 'bin/' instead. This is sub-optimal. Please install 'swftools.'"
    echo "==========================="
fi
set +o xtrace
#rem o obj/TiTSAIR636027137002854360
#@echo off
#cd %OLDDIR%
#@echo on
