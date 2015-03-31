#!/bin/bash

SRC="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

curl -w "@${SRC}/misc/curl-diagnostics.txt" -o /dev/null -s $@
