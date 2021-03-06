#!/bin/bash

wget "http://ghcjs.luite.com/master-$(date +%Y%m%d).tar.gz" -c -O master.tar.gz
# wget "http://ghcjs.luite.com/ghc-8.0-$(date +%Y%m%d).tar.gz" -c -O master.tar.gz

#lts-5.12

#R=nightly-2016-06-30
#E=820160630
#R=nightly-2016-04-28
#E=820160428

export RESOLVER=${R:-lts-6.15}
stack config set resolver $RESOLVER
export EXTRA=${E:-9006015}
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

scp archive.tar.gz ghcjs-host:/var/www/ghcjs/untested/$RESOLVER-$EXTRA.tar.gz
sha1sum archive.tar.gz
