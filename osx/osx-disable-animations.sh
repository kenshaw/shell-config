#!/bin/bash

defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

defaults write com.apple.dock expose-animation-duration -int 0

defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

defaults write com.apple.dock launchanim -bool false
