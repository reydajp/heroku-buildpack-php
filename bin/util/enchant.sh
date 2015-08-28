#!/bin/bash
# Build Path: /app/.heroku/php/

OUT_PREFIX=$1

# fail hard
set -o pipefail
# fail harder
set -eux

DEFAULT_VERSION="1.6.0"
dep_version=${VERSION:-$DEFAULT_VERSION}
dep_dirname=enchant-${dep_version}
dep_archive_name=${dep_dirname}.tar.gz
dep_url=http://www.abisource.com/downloads/enchant/1.6.0/${dep_archive_name}
echo "-----> Building enchant ${dep_version}..."

curl -L ${dep_url} | tar xz

pushd ${dep_dirname}
./autogen.sh
./configure \
    --prefix=/app/.heroku/vendor \
    --with-enchant
make -s -j 9
# php was a build dep, and it's in $OUT_PREFIX. nuke that, then make install so all we're left with is the extension
rm -rf ${OUT_PREFIX}/*
make install -s
popd

echo "-----> Done."