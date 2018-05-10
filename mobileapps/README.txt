Requirements:

You will need:
  1) A Java JDK's jarsigner tool. Oracle's JDK works, as should OpenJDK.
  2) The info-zip programs (zip and unzip). Try `apt-get install zip unzip` in
     Debian and similar linux distros (e.g. Ubuntu).
     The info-zip homepage has downloads, too - see here:
     http://www.info-zip.org/
	3) A unix-like bourne style shell (korn shell should work, too, but I have
     not tested it yet).
  4) The Android SDK's "zipalign" tool - not strictly necessary, but improves
     memory usage and needs to be commented out of the scripts if not installed.

Operating System-Specific Requirements:

Linux/Unix:
  Wine is required for running some Windows programs in the Adobe AIR SDK,
  unfortunately. This also means installing a windows version of the Java
  runtime (IIRC, a JDK is not strictly required) in Wine, in addition to the
  system's native Java runtime (AIR makes use of some java code as well).

Windows:
  I have not tested this on windows. It should work in MSYS or Cygwin, but you
  will need to remove all references to Wine and have it execute the batch
  scripts properly. I _think_ based on my memories of using cmd that you would
  want to replace 'wine' with 'cmd /c' in MSYS. In cygwin, 'cygstart' would
  do it, I think.

Other notes:
The P12 (PKCS#12) certificate password is 1234. It expires on 26 May 2102.
It is not the cert I sign my builds with.

I can't seem to make iOS builds from Wine, so I am just re-packing the IPA I
made from Windows ages ago. At some point I will try to fix this properly.

It doesn't matter much for now, because we can't install our IPA's without
apple signing off on them anyway unless we force the phone to ignore the code
signatures.

My build system has been cleaned up a good deal for this release, so it is
possible I forgot to include something important. If I did, I am sorry.
Please let me know if I did forget anything. I'm really trying to make
building not absolutely insane for people.
