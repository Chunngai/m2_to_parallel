#!/bin/bash

apt install -y g++ \
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

# clones moses if it's not in the current dir
if [ ! -d mosesdecoder/ ]
then
	git clone https://github.com/moses-smt/mosesdecoder.git
fi

cd mosesdecoder

cp "../install-dependencies(modified).gmake" "contrib/Makefiles/install-dependencies(modified).gmake"
make -f "contrib/Makefiles/install-dependencies(modified).gmake"

./bjam --with-boost=opt/ -j $(getconf _NPROCESSORS_ONLN) > install_moses.log


