#!/usr/bin/env bash
set -eEuo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

cd "$HERE"

export VAULT_ADDR=https://vault.dide.ic.ac.uk:8200
vault read -field=key secret/logs/ssl >ssl/key.pem
vault read -field=cert secret/logs/ssl >ssl/certificate.pem

cd docker-elk
[ "$(ls -A)" ] || git submodule update --init
KIBANA_PASSWORD="$(vault read -field=password secret/logs/users/kibana_system)"
export KIBANA_PASSWORD
docker-compose -f docker-compose.yml -f ../docker-compose.override.yml up -d
