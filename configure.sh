#! /bin/bash

# make configuration files for builds.
# note that you can use the windows releases of Adobe AIR for this, because
# we only use the java portions (which are portable).
#
# I'd recommend using the package "FlashDevelop-plus-fl-libs-flex-AIR.7z" that
# I put together a while ago, as the script assumes you are, but you can
# make your own or edit the script if you don't want to use it.

# find directory this script is located in. Works even through symlinks.
# stolen from stack exchange.

# STR2 contains the path name for the AIR runtime stuff. Change it if your dir
# names are different. It's lower down in the script.

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

# This really needs POSIX-ifying. Would be nice not to depend on bash.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
cd "$SCRIPTDIR"
unset SOURCE

# 2018 - don't put this in the source folder since it's a git repo submodule
# that we'd be contaminating unnecessarily.
# cd sourceTiTS

#make 'obj' dir, because the magical 'FlashDevelop' IDE uses it and I don't
#feel like re-inventing the wheel. Just removing a massive dependency in
#mono, and a massive headache in getting mono to interface with wine properly.

mkdir -p obj
cd obj
#concatenate the static parts of the XML file blindly into the config.
cat > TiTSFDConfig.xml << EOF
<?xml version="1.0" encoding="utf-8"?>
<!--This Adobe Flex compiler configuration file was generated by a tool.-->
<!--Any modifications you make may be lost.-->
<flex-config>
  <target-player>11.9</target-player>
  <benchmark>true</benchmark>
  <static-link-runtime-shared-libraries>true</static-link-runtime-shared-libraries>
  <use-network>false</use-network>
  <compiler>
    <define append="true">
      <name>CONFIG::debug</name>
      <value>true</value>
    </define>
    <define append="true">
      <name>CONFIG::release</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::timeStamp</name>
      <value>'9/8/2016'</value>
    </define>
    <define append="true">
      <name>CONFIG::air</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::mobile</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::desktop</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::IMAGEPACK</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::useFlexClasses</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::AIR</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::FLASH</name>
      <value>true</value>
    </define>
    <define append="true">
      <name>CONFIG::CHARGEN</name>
      <value>false</value>
    </define>
    <verbose-stacktraces>true</verbose-stacktraces>
    <source-path append="true">
EOF

# /path/to/source-code-root
export STR1="      <path-element>""$SCRIPTDIR""/sourceTiTS</path-element>"
# AIR path defined here
export STR2="      <path-element>""$SCRIPTDIR""/FlashDevelop-plus-fl-libs-flex-AIR/FlashDevelop/Library/AS3/classes</path-element>"

echo "$STR1" >> TiTSFDConfig.xml

echo "$STR2" >> TiTSFDConfig.xml
cat >> TiTSFDConfig.xml << EOF
    </source-path>
    <library-path append="true">
EOF

# scrolling library UI binary blob
export STR3="      <path-element>""$SCRIPTDIR""/sourceTiTS/style_uiscroll.swc</path-element>"

echo "$STR3" >> TiTSFDConfig.xml


cat >> TiTSFDConfig.xml << EOF
    </library-path>
  </compiler>
  <file-specs>
EOF

export STR4="    <path-element>""$SCRIPTDIR""/sourceTiTS/classes/TiTS.as</path-element>"
echo "$STR4" >> TiTSFDConfig.xml

cat >> TiTSFDConfig.xml << EOF
  </file-specs>
  <default-background-color>#3D5174</default-background-color>
  <default-frame-rate>24</default-frame-rate>
  <default-size>
    <width>1200</width>
    <height>800</height>
  </default-size>
</flex-config>
EOF

# The 'unix2dos' program from the 'dos2unix' package on most linux distros
# (and macports) can work here, too. I'm converting the file to a "DOS" format
# with inefficient 2-byte newlines (\r\n instead of \n).

#sed -i -e 's/\r*$/\r/' TiTSFDConfig.xml
#unix2dos TiTSFDConfig.xml

#sed -i 's/$/\r/' TiTSFDConfig.xml

#========================AIR CONFIGURATION FILE===============================

cat > TiTSAIRConfig.xml << EOF
<?xml version="1.0" encoding="utf-8"?>
<!--This Adobe Flex compiler configuration file was generated by a tool.-->
<!--Any modifications you make may be lost.-->
<flex-config>
  <target-player>13.0</target-player>
  <benchmark>false</benchmark>
  <static-link-runtime-shared-libraries>true</static-link-runtime-shared-libraries>
  <compiler>
    <define append="true">
      <name>CONFIG::debug</name>
      <value>true</value>
    </define>
    <define append="true">
      <name>CONFIG::release</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::timeStamp</name>
      <value>'9/9/2016'</value>
    </define>
    <define append="true">
      <name>CONFIG::air</name>
      <value>true</value>
    </define>
    <define append="true">
      <name>CONFIG::mobile</name>
      <value>true</value>
    </define>
    <define append="true">
      <name>CONFIG::desktop</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::IMAGEPACK</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::AIR</name>
      <value>true</value>
    </define>
    <define append="true">
      <name>CONFIG::FLASH</name>
      <value>false</value>
    </define>
    <define append="true">
      <name>CONFIG::CHARGEN</name>
      <value>false</value>
    </define>
    <verbose-stacktraces>true</verbose-stacktraces>
    <source-path append="true">
EOF

# /path/to/source-code-root
export STR1="      <path-element>""$SCRIPTDIR""/sourceTiTS</path-element>"
# AIR path defined here
export STR2="      <path-element>""$SCRIPTDIR""/FlashDevelop-plus-fl-libs-flex-AIR/FlashDevelop/Library/AS3/classes</path-element>"

echo "$STR1" >> TiTSAIRConfig.xml

echo "$STR2" >> TiTSAIRConfig.xml

cat >> TiTSAIRConfig.xml << EOF
    </source-path>
    <library-path append="true">
EOF

# scrolling library UI blob
export STR3="      <path-element>""$SCRIPTDIR""/sourceTiTS/style_uiscroll.swc</path-element>"

echo "$STR3" >> TiTSAIRConfig.xml


cat >> TiTSAIRConfig.xml << EOF
    </library-path>
  </compiler>
  <file-specs>
EOF

export STR4="    <path-element>""$SCRIPTDIR""/sourceTiTS/classes/TiTS.as</path-element>"
echo "$STR4" >> TiTSAIRConfig.xml

cat >> TiTSAIRConfig.xml << EOF
  </file-specs>
  <default-background-color>#3D5174</default-background-color>
  <default-frame-rate>24</default-frame-rate>
  <default-size>
    <width>1200</width>
    <height>800</height>
  </default-size>
</flex-config>
EOF

# done writing AIR config