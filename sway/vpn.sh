#!/bin/bash

STATUS=$(tailscale status --json)
EXIT_NODE=$(jq -r '.Peer|to_entries|map(select(.value.ExitNodeOption))[0].value.HostName // empty' <<< "$STATUS")
CONNECTED=$(jq -r ".Peer|to_entries|map(select(.value.HostName==\"${EXIT_NODE}\"))[0].value.ExitNode // empty" <<< "$STATUS")

do_status() {
  local icon="󰦜"
  local name=$(jq -r '.CurrentTailnet.Name // empty' <<< "$STATUS")
  local exit="${EXIT_NODE:-"(none)"}"

  if [ "$CONNECTED" = "true" ]; then
    icon="󰒃"
  fi

  printf '{"text": "%s", "tooltip": "%s\\nExit: %s"}\n' "$icon" "$name" "$exit"
}

do_toggle() {
  case "$CONNECTED" in
    true) tailscale set --exit-node='' ;;
    *)    tailscale set --exit-node="${EXIT_NODE}" ;;
  esac
}

case "$1" in
  status) do_status ;;
  toggle) do_toggle ;;
esac
