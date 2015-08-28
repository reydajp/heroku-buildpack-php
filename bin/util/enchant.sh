#!/bin/bash
# Build Path: /app/.heroku/php/
DEFAULT_VERSION="1.6.0"
dep_version=${VERSION:-$DEFAULT_VERSION}
dep_dirname=enchant-${dep_version}
dep_archive_name=${dep_dirname}.tar.gz
dep_url=http://www.abisource.com/downloads/enchant/1.6.0/${dep_archive_name}
echo "-----> Building enchant ${dep_version}..."

curl -L ${dep_url} | tar xz

if [ ! -d "${dep_dirname}" ]; then
  echo "[ERROR] Failed to find directory ${dep_dirname}"
  exit
fi

cd ${dep_dirname}

# /app/php/bin/phpize
# ./configure --enable-phalcon --with-php-config=$PHP_ROOT/bin/php-config
# make
# make install
BUILD_DIR=$1
ln -s $BUILD_DIR/.heroku /app/.heroku
export PATH=/app/.heroku/php/bin:$PATH
./autogen.sh
./configure \
    --prefix=/app/.heroku/vendor \
    --with-enchant
make
make install
cd
echo "important extension enchant into php.ini"
echo "extension=enchant.so" >> /app/.heroku/php/etc/php/php.ini

