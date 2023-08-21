#!/bin/bash

#VERSION=0.21.0

set -ex

cargo install \
  --git https://github.com/sharkdp/bat.git \
  --branch master \
  --force \
  bat

bat cache --clear
bat cache --build
