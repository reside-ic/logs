# logs

## Pre-requisites

- Docker and Docker Compose
- Vault

## Preparation

1. Log into Vault
2. Run the following:

```sh
git clone --recurse-submodules https://github.com/reside-ic/logs.git
cd logs/docker-elk
docker-compose up elasticsearch -d
docker-compose exec -T elasticsearch bin/elasticsearch-setup-passwords auto --batch
docker-compose down

 vault write secret/logs/users/apm_system password=…
 vault write secret/logs/users/kibana_system password=…
 vault write secret/logs/users/logstash_system password=…
 vault write secret/logs/users/beats_system password=…
 vault write secret/logs/users/remote_monitoring_user password=…
 vault write secret/logs/users/elastic password=…
```

## Run

1. Log into Vault
1. `./logs up`
1. Visit https://logs.dide.ic.ac.uk (VPN only) and log in as `elastic` with password above

This can safely be repeated in order to update information from Vault e.g. passwords or certificates

## Further information

See the KB article on Logging
