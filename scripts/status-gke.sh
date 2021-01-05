#!/bin/bash

PROJECT=$1

if [ -z "$PROJECT" ]; then
  echo "usage: $0 <PROJECT>"
  exit 1
fi

set -e
function agecalc {
  local i=$(sed -e 's/\.[0-9]\+//' <<< "$1")
  ((sec=i%60, i/=60, min=i%60, hrs=i/60))
  printf "%dh%02dm" $days $hrs|sed -e 's/^0h//' -e 's/h00m$/h/'
}

function stat {
  local node=$1
  local age=$2
  local pods=$(kubectl get pods --all-namespaces --no-headers -o wide|awk "\$8 == \"$node\"")
  local count=$(wc -l <<< "$pods")
  local pgcount=$(echo "$pods"|grep postgresql|wc -l)
  local uptime=$(gcloud compute ssh $node --command='(awk "{print \$1\" \"}" < /proc/uptime; uptime|awk -F: "{print \$NF}"|xargs)|tr -d "\\n,"' -- -q)
  local nodeage=$(agecalc $uptime)
  local load=$(cut -d' ' -f2- <<< "$uptime")
  echo -e "$node\t$age\t$nodeage\t$count\t$pgcount\t$load"
}

kubectl config use-context $PROJECT &> /dev/null
gcloud config set --quiet core/project $PROJECT &> /dev/null
(
  echo -e "NODE\tAGE\tUP\tPODS\tPG\tLOAD"
  pids=
  while read line; do
    node=$(awk '{print $1}' <<< "$line")
    age=$(awk '{print $4}' <<< "$line")
    stat $node $age &
    pids+=" $!"
  done <<< $(kubectl get nodes --no-headers)
  wait $pids || { echo "error!" >&2; exit 1; }
) | column -ts $'\t'
