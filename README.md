## Log server

Log in to machine with

```
ssh logs@logs.dide.ic.ac.uk
```

Bringing up the system, provided that the elastic search volume exists and contains appropriately initialised passwords, is:

```
./scripts/prepare
./scripts/start-elk
./scripts/proxy
```

### Initial prep work

This section needs to be done manually, and only needs doing after the elasticsearch volume has been removed.

First start up elastic search and wait for it to stabilise (this is a blocking command)

```
docker-compose -f docker-elk/docker-compose.yml up elasticsearch
```

Generate random passwords for all accounts:

```
docker exec docker-elk_elasticsearch_1 \
       bin/elasticsearch-setup-passwords auto --batch
```

Set these passwords in the vault using the values printed above

```
vault write secret/logs/users/api_system password=<password>
vault write secret/logs/users/kibana password=<password>
vault write secret/logs/users/logstash_system password=<password>
vault write secret/logs/users/beats_system password=<password>
vault write secret/logs/users/remote_monitoring_user password=<password>
vault write secret/logs/users/elastic password=<password>
```

Stop the elasticsearch container with Ctrl-C, then clean up with

```
docker system prune -f
```

The data volume will persist.

After bringing up the system fully, log in with the elastic user and go to the [user management control](https://logs.dide.ic.ac.uk/app/kibana#/management/security/users) and add users and roles.
