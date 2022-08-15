#!/bin/bash

rsync -avP \
  --exclude .steam* \
  --exclude .cache \
  --exclude .rustup \
  --exclude .cargo \
  --exclude .opam \
  --exclude .local \
  --exclude .wine \
  --exclude .npm \
  --exclude .dbus \
  --exclude .haxe \
  --exclude .npm-global \
  --exclude .mozilla \
  --exclude .vscode \
  --exclude .config/unity3d \
  --exclude .config/Slack \
  --exclude src/qemu \
  --exclude src/go/pkg \
  --exclude src/go/bin \
  --exclude src/infra/oracle-docker-images \
  --delete \
  /home/ken/. \
  /media/backup/ken-desktop-current/.
