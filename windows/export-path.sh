#!/usr/bin/env bash

# Machine + user PATH from the registry, as MSYS2 paths.

MACHINE='/proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session Manager/Environment/Path'
USER='/proc/registry/HKEY_CURRENT_USER/Environment/Path'

# REG_EXPAND_SZ values read as plain strings; just drop the trailing NUL
raw() { [ -e "$1" ] && tr -d '\0' < "$1"; }

# hand the string back to cmd so Windows expands %VAR% itself
expand() {
  RAW="$1" cmd //d //v:off //c 'call echo %RAW%' | tr -d '\r'
}

# registry values -> newline-separated POSIX paths (no dedup yet)
win_path_raw() {
  { raw "$MACHINE"; echo; raw "$USER"; } |
    while IFS= read -r p || [ -n "$p" ]; do
      [ -n "$p" ] && cygpath -up "$(expand "$p")"
    done |
      tr ':' '\n'
}

# split a colon-list without cutting "C:\..." in half
split_path() {
  printf '%s\n' "$1" |
    sed -E 's#(^|:)([A-Za-z]):([\\/])#\1\2\x01\3#g' |
    tr ':' '\n' |
    tr '\001' ':'
}

# newline-separated mixed Windows/POSIX -> POSIX
to_posix() {
  while IFS= read -r p || [ -n "$p" ]; do
    [ -n "$p" ] || continue
    case $p in
      [A-Za-z]:*|*\\*) cygpath -u "$p" ;;
      *)               printf '%s\n' "$p" ;;
    esac
  done
}

norm() {
  sed -E 's#(.)/+$#\1#' | awk 'NF && !seen[$0]++'
}

merge_path() {
  { split_path "$PATH"
    win_path_raw
  } | to_posix | norm | paste -sd ':' -
}

export PATH="$(merge_path)"
