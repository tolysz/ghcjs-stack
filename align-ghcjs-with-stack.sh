#!/bin/bash

wget "http://ghcjs.luite.com/master-$(date +%Y%m%d).tar.gz" -c -O master.tar.gz
#lts-5.12

#R=nightly-2016-03-19
R=nightly-2016-04-16
E=820160416

export RESOLVER=${R:-lts-5.8}
stack config set resolver $RESOLVER
export EXTRA=${E:-9005008}
mkdir -p cache new-boot

tar -zxf master.tar.gz

echo "do the work"
echo "resolver: $RESOLVER" > ghcjs-0.2.0/stack.yaml
echo "allow-newer: true" >> ghcjs-0.2.0/stack.yaml
sed "s/^Version:.*/Version:        0.2.0.$EXTRA/" < ghcjs.cabal1 > ghcjs-0.2.0/ghcjs.cabal
cp ghcjs-0.2.0/lib/cache/boot.tar .
tar -xf boot.tar
cp patches/* ghcjs-boot/patches

./fetch-packages.sh

cp ghcjs-boot/boot/* new-boot/
rm -r ghcjs-boot/boot
mv new-boot ghcjs-boot/boot
cp -f ghcjs-base.cabal1 ghcjs-boot/ghcjs/ghcjs-base/ghcjs-base.cabal

echo tar
tar -cf boot.tar ghcjs-boot
cp -f boot.yaml ghcjs-0.2.0/lib/etc/
cp -f boot.tar ghcjs-0.2.0/lib/cache/
[ -d ghcjs-0.2.0.$EXTRA ] && rm -r ghcjs-0.2.0.$EXTRA
mv ghcjs-0.2.0 ghcjs-0.2.0.$EXTRA
tar -zcf archive.tar.gz ghcjs-0.2.0.$EXTRA


# upload somewhere
# ghcjs-0.2.0.820160416_ghc-7.10.3.tar.gz
cp -v archive.tar.gz ~/.stack/programs/x86_64-linux/ghcjs-0.2.0.${EXTRA}_ghc-7.10.3.tar.gz
scp archive.tar.gz ghcjs-host:/var/www/ghcjs/$RESOLVER-$EXTRA.tar.gz
