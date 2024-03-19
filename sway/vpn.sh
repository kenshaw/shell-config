#!/bin/bash

STATUS=$(tailscale status --json 2>/dev/null)
STATE=$(jq -r '.BackendState // empty' <<< "$STATUS" 2>/dev/null|tr 'A-Z' 'a-z')
EXIT_NODE=$(jq -r '.Peer|to_entries|map(select(.value.ExitNodeOption))[0].value.HostName // empty' <<< "$STATUS" 2>/dev/null)
CONNECTED=$(jq -r ".Peer|to_entries|map(select(.value.HostName==\"${EXIT_NODE}\"))[0].value.ExitNode // empty" <<< "$STATUS" 2>/dev/null)

if [ "$CONNECTED" = "true" ]; then
  STATE=connected
fi

do_status() {
  # 
  local icon="" tooltip="(down)"
  local name=$(jq -r '.CurrentTailnet.Name // empty' <<< "$STATUS" 2>/dev/null)
  local exit="${EXIT_NODE:-"(none)"}"

  case "$STATE" in
    running)   icon="󰌊" tooltip="$name" ;;
    connected) icon="󰌆" tooltip="$name\\nExit: $EXIT_NODE" ;;
  esac

  printf '{"text": "%s", "tooltip": "%s"}\n' "$icon" "$tooltip"
}

do_toggle() {
  case "$STATE" in
    running)   tailscale set --exit-node="${EXIT_NODE}" ;;
    connected) tailscale set --exit-node='' ;;
  esac
}

case "$1" in
  status) do_status ;;
  toggle) do_toggle ;;
esac
