#!/bin/bash

PATCHDIR=ghcjs-boot/patches
#         ghcjs-boot/patches


boot=( base ghc-prim integer-gmp )
function patchPackage {

SIMP=$PATCHDIR/$1

echo $SIMP

if [ ! -f $SIMP.patch ] && [ ! -f $SIMP-$2.patch ] ; then
  echo NO PATCH FOUND: $1
else
  echo WE HAVE A PATCH FOR $1
  if [ ! -f $SIMP-$2.patch ]; then
    echo "GENERAL ONE"
    PATCH=$SIMP.patch
  else
    echo "speciffic"
    PATCH=$SIMP-$2.patch
  fi

if [[ " ${boot[@]} " =~ " ${1} " ]]; then
    # whatever you want to do when arr contains value
  echo "PATCHING $PATCH"
  cd $1
  patch -p3 < ../$PATCH
  cd ..
else
    # whatever you want to do when arr doesn't contain value
    cd $1
    patch -p1 < ../$PATCH
    cd ..
fi

fi

}

function generatePatch {
  echo diff -Naur b/boot/ghc-prim-0.4.0.0 a/boot/ghc-prim  > ghc-prim-0.4.0.0.patch
  
}

function getPackage {

if [ -d special/$1 ]; then
  echo ==============================================
  echo $1
  cp -r special/$1 .
  return
fi

if [ "$1" == "integer-gmp" ];then
  NVER="0.5.1.0"
else
  NVER=$2
fi

VER=$1-$NVER

  VERZ=$VER.tar.gz
  if [ ! -f cache/$VERZ ]; then
    echo "we need to get the package"
    wget https://hackage.haskell.org/package/$VER/$VERZ -O cache/$VERZ
  else
    echo "wh have the package"
  fi
  tar -zxf cache/$VERZ
  if [ -d "$1" ]; then
  rm -r ./$1
  fi
  mv   ./$VER ./$1
  echo Need to patch $VER
  patchPackage $1 $NVER
}

allBase=( aeson base case-insensitive  deepseq filepath integer-gmp parallel random template-haskell unix array binary directory ghc-prim mtl pretty scientific text unordered-containers async bytestring  dlist hashable old-locale primitive  stm time vector attoparsec cabal containers extensible-exceptions  old-time process syb transformers Win32 )

# getPackage base 4.8.2.0
