#!/bin/bash

# gocode is a giant PITA. this helps, a little.

set -x

# kill the gocode daemon
killall -9 gocode

# remove built binaries/packages
rm -rf $HOME/src/go/pkg/*
rm -rf $HOME/src/go/bin/gocode

# cleanup crap in /tmp
rm -rf /tmp/go-*
rm -rf /tmp/gocode-daemon.*

# reinstall gocode
go get -u github.com/nsf/gocode
