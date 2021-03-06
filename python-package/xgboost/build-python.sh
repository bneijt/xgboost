#!/bin/bash
# This is a simple script to make xgboost in MAC and Linux for python wrapper only
# Basically, it first try to make with OpenMP, if fails, disable OpenMP and make it again.
# This will automatically make xgboost for MAC users who don't have OpenMP support.
# In most cases, type make will give what you want.

# See additional instruction in doc/build.md

# note: this script is build for python package only, and it might have some filename
#       conflict with build.sh which is for everything.


#pushd xgboost
oldpath=`pwd`
cd ./xgboost/
#If cmake is installed, prefer that build
if which cmake >> /dev/null; then
    cmake .
    make || make USE_OPENMP=0
else
    #Use distributed makefile
    #remove the pre-compiled .so and trigger the system's on-the-fly compiling
    make clean
    if make lib/libxgboost.so -j4; then
        echo "Successfully build multi-thread xgboost"
    else
        echo "-----------------------------"
        echo "Building multi-thread xgboost failed"
        echo "Start to build single-thread xgboost"
        make clean
        make lib/libxgboost.so -j4 USE_OPENMP=0
        echo "Successfully build single-thread xgboost"
        echo "If you want multi-threaded version"
        echo "See additional instructions in doc/build.md"
    fi
fi
cd $oldpath
