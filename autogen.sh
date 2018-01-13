#!/bin/sh -e

# Fetch external dependencies
if [ -d "ext" ]; then
    rm -rf ext
fi
mkdir ext

# Clone the Contiki-NG repository and its submodules
echo "Cloning the Contiki-NG repository..."
git clone --quiet --progress --recursive \
    https://github.com/contiki-ng/contiki-ng.git ext/contiki-ng
echo "Cloning the Contiki-NG repository...done"

# Clone the cryptoauthlib repository
echo "Cloning the CryptoAuthLib repository..."
git clone --quiet --progress --recursive \
    https://github.com/pull-iot/cryptoauthlib.git ext/cryptoauthlib
echo "Cloning the CryptoAuthLib repository...done"

# Patch the repositories
PATCHDIR=patches
for dir in $(cd $PATCHDIR && find * -type d -print); do
    for f in $(find $PATCHDIR/$dir -maxdepth 1 -name '*.patch' -print); do
        patch=$PWD/$f
        echo "Applying patch: $patch"
        (cd ext/$dir/
        git am $patch
        )
    done
done
