# sectronov_infra
sectronov Infra repository

## Homework 4
```
bastion_IP = 35.205.140.104
someinternalhost_IP = 10.132.0.3
```

**Подключение к `someinternalhost` в одну команду:**

`ssh -i ~/.ssh/appuser -o ProxyCommand="ssh -W %h:%p appuser@$bastion_IP" appuser@$someinternalhost_IP`

**Подключение к `someinternalhost` через команду `ssh someinternalhost`**

В файл `~/.ssh/config` добавить:
```
Host bastion
Hostname $bastion_IP
User appuser

Host someinternalhost
Hostname $someinternalhost_IP
User appuser
ProxyCommand ssh -W %h:%p bastion
```

## Homework 5
```
testapp_IP = 104.199.39.206
testapp_port = 9292
```

Команда `gcloud` для создания инстанса со `sturtup script`:

```
gcloud compute instances create reddit-app \
 --boot-disk-size=10GB \
 --image-family ubuntu-1604-lts \
 --image-project=ubuntu-os-cloud \
 --machine-type=g1-small \
 --tags puma-server \
 --restart-on-failure \
 --metadata-from-file startup-script=startup.sh
 ```

Команда `gcloud` для создания правила в фаерволе:

```
gcloud compute firewall-rules create default-puma-server \
 --direction=INGRESS \
 --priority=1000 \
 --network=default \
 --action=ALLOW \
 --rules=tcp:9292 \
 --source-ranges=0.0.0.0/0 \
 --target-tags=puma-server
```
