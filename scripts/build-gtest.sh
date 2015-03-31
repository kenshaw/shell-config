#!/bin/bash

mkdir -p ~/src/gtest/build
cd ~/src/gtest/build

cmake -DCMAKE_BUILD_TYPE=RELEASE /usr/src/gtest
make
