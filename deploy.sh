#!/bin/bash
# Simple deploy script to package and release a PyInstaller version

if [ "$#" != "1" ]; then
	echo "Usage: $0 <TAG>"
	echo
	exit 2
fi

PYINST=https://src.develer.com/svnoss/pyinstaller
WORKDIR="/tmp/release-pyinstaller.$$/"
DESTDIR=trinity.develer.com:/var/www/html/pyinstaller
TAG=$1

abort()
{
	echo "$0: Aborting..."
	rm -rf $WORKDIR
	exit 2
}


mkdir $WORKDIR
cd $WORKDIR
svn export $PYINST/tags/$TAG pyinstaller-$TAG 1>/dev/null || abort
cd pyinstaller-$TAG
if [ ! doc/Manual.pdf -nt doc/source/Manual.rst -o ! doc/Manual.html -nt doc/source/Manual.rst ]; then
	echo "Documentation was not rebuilt, aborting"
	abort
fi;
cd ..
mkdir $TAG
tar cjf $TAG/pyinstaller-$TAG.tar.bz2 pyinstaller-$TAG/ 1>/dev/null
zip -9r $TAG/pyinstaller-$TAG.zip pyinstaller-$TAG/ 1>/dev/null
md5sum $TAG/* > $TAG/MD5SUMS.txt
scp -r $TAG $DESTDIR/source || abort
rm -rf $WORKDIR
