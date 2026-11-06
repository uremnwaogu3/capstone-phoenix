#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="$HERE/../../terraform"
OUT="$HERE/hosts.ini"

SERVER_PUB=$(terraform -chdir="$TF_DIR" output -raw server_public_ip)
SERVER_PRIV=$(terraform -chdir="$TF_DIR" output -raw server_private_ip)
mapfile -t WORKER_PUB < <(terraform -chdir="$TF_DIR" output -json worker_public_ips | jq -r '.[]')
mapfile -t WORKER_PRIV < <(terraform -chdir="$TF_DIR" output -json worker_private_ips | jq -r '.[]')

{
  echo "[k3s_server]"
  echo "server ansible_host=${SERVER_PUB} private_ip=${SERVER_PRIV}"
  echo
  echo "[k3s_agents]"
  for i in "${!WORKER_PUB[@]}"; do
    echo "worker-$((i + 1)) ansible_host=${WORKER_PUB[$i]} private_ip=${WORKER_PRIV[$i]}"
  done
  echo
  echo "[k3s_cluster:children]"
  echo "k3s_server"
  echo "k3s_agents"
} > "$OUT"

echo "Wrote $OUT"
cat "$OUT"