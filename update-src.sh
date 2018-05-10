#! /bin/bash

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

cd "$SCRIPTDIR""/sourceTiTS"
git checkout master
git pull
