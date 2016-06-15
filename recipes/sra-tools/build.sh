#!/bin/bash

NGS_SDK_VERSION=1.2.4
NCBI_VDB_VERSION=2.6.3

# download extra sources using conda's mechanism
# see: https://github.com/stuarteberg/conda-multisrc-example
CONDA_PYTHON=$(conda info --root)/bin/python
${CONDA_PYTHON} ${RECIPE_DIR}/download-extra-sources.py

WORK_DIR=`dirname $SRC_DIR`
SRC_SDK=$WORK_DIR/ngs-sdk/ngs-${NGS_SDK_VERSION}
SRC_VDB=$WORK_DIR/ncbi-vdb/ncbi-vdb-${NCBI_VDB_VERSION}

####
# build ngs-sdk
####

cd $SRC_SDK
# First configure fails
# See: https://github.com/ncbi/ngs/issues/1
./configure --prefix=$PREFIX/ --build-prefix=$PREFIX/share/ncbi
make -C ngs-sdk

./configure --prefix=$PREFIX/ --build-prefix=$PREFIX/share/ncbi
make -C ngs-sdk install

####
# build ncbi-vdb
####

cd $SRC_VDB
./configure --prefix=$PREFIX/ \
	    --build-prefix=$PREFIX/share/ncbi \
            --with-ngs-sdk-prefix=$PREFIX
make install

####
# build sra-tools
####

cd $SRC_DIR
./configure --prefix=$PREFIX \
	--build-prefix=$PREFIX/share/ncbi/ \
	--with-ncbi-vdb-sources=$SRC_VDB \
	--with-ncbi-vdb-build=$PREFIX/share/ncbi/ncbi-vdb \
	--with-ngs-sdk-prefix=$PREFIX

make install
