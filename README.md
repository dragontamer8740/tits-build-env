Linux Build environment for Trials in Tainted Space.

Updated in 2018 for a little more portability and flexibility.

## Dependencies
Needs FlashDevelop-plus-fl-libs-flex-AIR.7z, which I have uploaded separately
due to space constraints. This contains the Flex and AIR SDK files needed to
build the game.

Also needs [swftools](http://www.swftools.org/about.html). This might be in
your package manager. Specifically, we need the 'swfcombine' tool from it.

[FlashDevelop-plus-fl-libs-flex-AIR.7z](https://mega.nz/#!bgY20bRD!6lEiUof-GS-Jkkhv3DGbSuHoc2OhvZjVqknpe7K2N0w) (351.5 MB)

Alternatively, one can use FlashDevelop to download the Flex and AIR SDK files
and merge them together. If you do this, you will get a later version of the
AIR SDK, so you will have to locate the instances of `flexairsdk/4.6.0+18.0.0`
in the `buildDesktopSWF.sh` and `buildAIRSWF.sh` scripts and edit them
accordingly. I don't know what else might break, so I don't really recommend
this approach.

Additionally, I'd advise against trying to use the Apache Flex SDK, and instead
recommend using the last version of Adobe's. I wish I could advise using
Apache's, since it's open source, but I've never had any luck getting the game
to build with it. It's been a while since I tried, though. Let me know if you
try and get it to work.

### Mobile building

Needs zipalign (or some minor editing of the scripts in `mobileapps/`) to
make the Android APK's 100% holy. There's a sort-of-working hack implementation
in a subdirectory, but I'd recommend installing the android SDK tools if you
want to do this. The game will work without zipalign, but it could be
marginally slower to start up.

Also needs a working wine installation, and an installation of a windows
implementation of the Java JDK in wine. (JDK, not JRE - we need jarsigner).

As currently implemented, you will have to provide the path to the Java
installation in the .bat files in the mobileapps/ directory.

You will also have to set the path to the Flex/AIR SDK windows programs in
these scripts. Examples are given in the scripts themselves.

## Building
To use (short, SHORT version):

###First run

The following commands are only needed before the first build of the game.
You may need to edit configure.sh with your path to your AIR/Flex combined SDK.

The other time you may have to run 'configure.sh' is if you move where your
environment is set up (i.e. this repository's in your home directory, and you
move it to `/home/user/sourcecode/`. This is because configure.sh dynamically
generates XML files which contain a handful complete paths to files.

    $ git submodule init
    $ git submodule update
    $ ./configure.sh

###First and all future runs

After running the above at least once, run the following to build the game:

    $ ./buildall.sh
