#!/bin/bash

defaults write -app iTerm NSUserKeyEquivalents '{
  "Move Tab Left" = "@$d";
  "Move Tab Right" = "@$n";
  "Select Next Tab" = "@n";
  "Select Previous Tab" = "@d";
}'

defaults write -app 'Google Chrome' NSUserKeyEquivalents '{
  "Select Next Tab" = "@n";
  "Select Previous Tab" = "@d";
}'
