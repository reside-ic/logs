## Log server

The server is hosted at https://logs.dide.ic.ac.uk which is available only on the VPN.

Access is restricted - email Rich if you can't get in and think you should be able to.  The super user is `elastic` and its password is in the vault as `secret/logs/users/elastic`

### Deploying the server

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

It all takes a while to start up and one can use

```
./scripts/tail-logs
```

to get the logs of containers as they start up (all fantastically meta).  Quit this with Ctrl-C when things have stabilised and ignore the scary red "ABORTING" that is printed - the containers are unaffected.

This will need serious work later I suspect.

### Feeding logs into the server

See [the beats setup repository](https://github.com/reside-ic/beats)

### Initial prep work

This section needed to be done manually, and would only need doing again after the elasticsearch volume has been removed or lost.

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
