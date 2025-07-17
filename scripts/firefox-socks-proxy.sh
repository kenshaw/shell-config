#!/bin/sh

PROFILENAME=$1 SOCKSPORT=$2

if [[ -z "$PROFILENAME" || -z "$SOCKSPORT" ]]; then
  echo -e "usage:\n  ssh -D <SOCKSPORT> -q -C -N user@host.com\n  $0 <PROFILENAME> <SOCKSPORT>"
  exit 1
fi

set -e -x

firefox -CreateProfile $PROFILENAME
cd $HOME/.mozilla/firefox/*$PROFILENAME

set_pref() {
  if grep -q "$1" prefs.js ; then
    sed -i "s@user_pref(\"$1\",\(.*\));@$2@g" prefs.js
  else
    echo "$2" >> prefs.js
  fi
}

set_pref_asis() {
  set_pref "$1" "user_pref(\"$1\",$2);"
}

set_pref_str() {
  set_pref "$1" "user_pref(\"$1\",\"$2\");"
}

set_pref_str "network.proxy.no_proxies_on" "localhost, 127.0.0.1"
set_pref_str "network.proxy.socks" "127.0.0.1"
set_pref_asis "network.proxy.socks_port" "$SOCKSPORT"
set_pref_asis "network.proxy.type" 1

exec firefox --profile `pwd` "$@"
