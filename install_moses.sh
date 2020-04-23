#!/bin/bash

apt install g++ \
git \
subversion \
automake \
libtool \
zlib1g-dev \
libicu-dev \
libboost-all-dev \
libbz2-dev \
liblzma-dev \
python-dev \
graphviz \
imagemagick \
make \
cmake \
libgoogle-perftools-dev \
autoconf \
doxygen \
build-essential \
git-core \
pkg-config \
wget

ROOT=$(cd . && pwd)

# clones moses if it's not in the current dir
if [ ! -d mosesdecoder/ ]
then
	git clone https://github.com/moses-smt/mosesdecoder.git
fi

cd mosesdecoder/mosesdecoder-master

CWD=$(cd . && pwd)

CMPH_TMP=$CWD/build/cmph
mkdir -p $CMPH_TMP && cd $CMPH_TMP && cp $ROOT/cmph*tar.gz `pwd` && tar xvzf cmph*tar.gz
BOOST_TMP=$CWD/build/boost
mkdir -p $BOOST_TMP && cd $BOOST_TEMP && cp $ROOT/boost*tar.gz `pwd` && tar xvzf boost*tar.gz

cp "$ROOT/install-dependencies (modified).gmake" "$CWD/contrib/Makefiles/install-dependencies (modified).gmake"
make -f "$CWD/contrib/Makefiles/install-dependencies (modified).gmake"

./bjam --with-boost=opt/ > build.log && echo SUCCESS || echo failed


