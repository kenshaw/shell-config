#!/bin/bash

set -x

rsync -avP \
  --delete \
  --exclude /media \
  --exclude /swapfile \
  --exclude /proc \
  --exclude /sys \
  --exclude /run \
  --exclude /dev \
  --exclude /lost+found \
  / \
  /media/backup/complete/.
