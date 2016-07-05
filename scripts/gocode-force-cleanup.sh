#!/bin/bash

# gocode is a giant PITA. this helps, a little.

set -x

# kill the gocode daemon
killall -9 gocode

# remove built binaries/packages
rm -rf $HOME/src/go/pkg/*
rm -rf $HOME/src/go/bin/gocode
rm -rf $HOME/src/go/bin/gometalinter

# cleanup crap in /tmp
rm -rf /tmp/go-*
rm -rf /tmp/gocode-daemon.*

# reinstall
go get -u github.com/nsf/gocode
go get -u github.com/alecthomas/gometalinter
gometalinter --install --update
