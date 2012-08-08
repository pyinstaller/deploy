#!/bin/bash
# Simple deploy script to package and release a PyInstaller version

if [ "$#" != "1" ]; then
	echo "Usage: $0 <TAG>"
	echo
	exit 2
fi

TAG=$1

## clone from local git clone, not from github
#PYINST=git://github.com/pyinstaller/pyinstaller.git
PYINST=$PWD

WORKDIR="/tmp/release-pyinstaller.$$/"

abort()
{
	echo "$0: Aborting..."
	rm -rf $WORKDIR
	exit 2
}


mkdir $WORKDIR
cd $WORKDIR
git clone $PYINST pyinstaller-$TAG || abort
cd pyinstaller-$TAG
git checkout --quiet v$TAG

# checking for timestamps does not work
#cd doc
#if [ ! Manual.pdf -nt source/Manual.rst -o ! Manual.html -nt source/Manual.rst ]; then
#	echo "Documentation was not rebuilt, aborting"
#	abort
#fi
#cd ..

rm -rf .git .gitignore .gitattributes
cd ..

tar cjf pyinstaller-$TAG.tar.bz2 pyinstaller-$TAG/ 1>/dev/null
zip -9r pyinstaller-$TAG.zip pyinstaller-$TAG/ 1>/dev/null
md5sum pyinstaller-$TAG.* > MD5SUMS.txt
echo "Now upload files in $WORKDIR to github".
