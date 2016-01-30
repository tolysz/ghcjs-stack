#!/bin/bash

. lib.sh


export DEST=new-boot

rm -r $DEST
mkdir $DEST

stack list-dependencies --resolver $RESOLVER | \
while read i j; do

getPackage $i $j
mv $i $DEST

done

cp -r special/cabal $DEST
cp -r special/Win32 $DEST
