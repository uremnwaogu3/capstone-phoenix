#!/usr/bin/env bash
# Usage: ./tunnel.sh start|stop|status
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY="${HOME}/.ssh/uremapp"
SOCK="${HOME}/.ssh/uremapp-tunnel.sock"
LOCAL_PORT=16443
SERVER_IP="$(terraform -chdir="$HERE/../terraform" output -raw server_public_ip)"

case "${1:-}" in
  start)
    if ssh -S "$SOCK" -O check "ubuntu@${SERVER_IP}" 2>/dev/null; then
      echo "Tunnel already running"
      exit 0
    fi
    ssh -f -N -M -S "$SOCK" \
      -L "${LOCAL_PORT}:127.0.0.1:6443" \
      -o ExitOnForwardFailure=yes \
      -o ServerAliveInterval=30 \
      -o StrictHostKeyChecking=accept-new \
      -o IdentitiesOnly=yes \
      -i "$KEY" "ubuntu@${SERVER_IP}"
    echo "Tunnel up: 127.0.0.1:${LOCAL_PORT} -> API on ${SERVER_IP}"
    ;;
  stop)
    if ssh -S "$SOCK" -O exit "ubuntu@${SERVER_IP}" 2>/dev/null; then
      echo "Tunnel stopped"
    else
      echo "No tunnel running"
    fi
    ;;
  status)
    ssh -S "$SOCK" -O check "ubuntu@${SERVER_IP}" || echo "Tunnel is not running"
    ;;
  *)
    echo "Usage: $0 start|stop|status"
    exit 1
    ;;
esac
