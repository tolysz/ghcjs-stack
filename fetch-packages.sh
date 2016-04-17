#!/bin/bash

. lib.sh

export KEEP=ghcjs-boot/boot
export DEST=new-boot

rm -r $DEST
mkdir $DEST


stack list-dependencies --resolver $RESOLVER | \
while read i j; do

getPackage $i $j
mv $i $DEST

done

cp -r $KEEP/integer-gmp $DEST
cp -r $KEEP/cabal $DEST
cp -r $KEEP/Win32 $DEST
