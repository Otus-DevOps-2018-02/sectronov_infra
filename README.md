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

## Homework 7

В этом ДЗ была проведена работа с [terraform](https://www.terraform.io).

На основе конфигурации `main.tf` в GCP был развёрнут инстанс из ранее созданого образа `reddit-base`. Необходимые переменные были вынесены в `variables.tf`, а так же добавлен `outputs.tf` — для доступа к вычисляемым значениям конфигцрации.

Для сборки инстанса необходимо запустить команду:
`terraform apply`

Эта команда добавит ssh-ключи для проекта. Если после этого вручную добавить ssh-ключ через веб-интерфейс GCP и снова вызвать `terraform apply`, то добавленный ключ удалится. Поэтому, вносить ssh-ключи следует через конфигурацию `terraform`.

## Homework 9: Знакомство с Ansible

Добавлена директория `ansible/`, в ней:
- `inventory` — файл с хостами
- `inventory.yml` — файл с хостами в формате `YAML`
- `ansible.cfg` — конфигурация `anisble` по-умолчанию
- `clone.yml` — плейбук для установки приложения на хост `appserver`
- `inventory.sh` — скрипт, который позволяет динамически конфигурировать хосты 
- `inventory.json` - файл для примера динамической конфигурации хостов

### Команды `ansible`
**Пинг хоста `appserver`:**

`ansible appserver -i ./inventory -m ping`
- опция `-i` задаёт `inventory`-файл, либо скрипт для динамического `inventory`
- опция `-m` задаёт модуль

**Пинг всех хостов `all` (при настроеном `anisble.cfg` опцию `-i` можно не указывать):**

`ansible all -m ping`

**Проверить статуса сервиса:**

`ansible db -m service -a name=mongod`

- опция `-a` — аргументы для передачи модулю

**Запуск плейбука:**

`ansible-playbook clone.yml`

### Динамический `inventory`

Для динамического добавления хостов нужно создать скрипт, который будет обрабатывать опции `--list` и `--host <hostname>`. При предаче скрипту опции `--list` он должен вернуть все динамические хосты. При передаче опции `--host <hostname>` — переменные для одного хоста. Если при передаче `--list` в результирующем `JSON` вернулся ключ `_meta` с параметрами хостов, то скрипт не будет вызываться с опицией  `--host`.
