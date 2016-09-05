#!/bin/bash

. lib.sh

export KEEP=ghcjs-boot/boot
export DEST=new-boot
export SPECIAL=special

rm -r $DEST
mkdir $DEST


stack list-dependencies --resolver $RESOLVER | \
while read i j; do

getPackage $i $j
mv $i $DEST

done

cp -r $KEEP/integer-gmp $DEST
#cp -r $SPECIAL/integer-gmp $DEST
cp -r $SPECIAL/cabal $DEST
cp -r $KEEP/Win32 $DEST
