# sectronov_infra
sectronov Infra repository

## Homework 4: Командная работа с Git. Работа в GitHub. Продвинутые команды Git
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

## Homework 5: Локальное окружение инженера. ChatOps и визуализация рабочих процессов
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

## Homework 7: Основные сервисы Google Cloud Platform (GCP)

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

## Homework 10: Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags.

В директории `ansible/` добавлены:
- `packer_app.yml` — плейбук с установкой окружения приложения для пакера
- `packer_db.yml` — плейбук с установкой MongoDB для пакера
- `reddit_app_one_play.yml` — плейбук в котором задачи вперемешку
- `reddit_app_multiple_plays.yml` — плейбук в котором задачи сгруппированны по соотвествующим сценариям
- `app.yml` — один плейбук на один сценарий настройки окружения для приложения
- `db.yml` — один плейбук на один сценарий настройки MongoDB
- `deploy.yml` — один плейбук на один сценарий деплоя приложения
- `site.yml` — плейбу, который объеденяет в себе три предыдущих
- `templates/db_config.j2` — конфиг для подключения к БД из приложения
- `templates/mongod.conf.j2` — конфиг для настройки MongoDB
- `files/puma.service` — конфиг `puma` для `systemd`

Для проверки работспособности плейбуков используется команда:

`ansible-playbook reddit_app_one_play.yml --check --limit
app --tags app-tag`

- опция `--check` — аргумент для указания того, что будет проверка, а не применение
- опция `--limit` — аргумент для указания хостов проверки
- опция `--tags` — аргумент для указания тегов проверки

### Динамический `inventory`

Был улучшен `inventory.sh` для того, чтобы хосты подтягивались автоматически из GCP, теперь `JSON` с хостами генерируется на лету.

## Homework 11: Принципы организации кода для управления конфигурацией

- В директории `ansible` были созданы две роли `app` и `db`, а так же два окружения `prod` и `stage`.
- Из `ansible-galaxy` была использована роль `jdauphant.nginx` для конфигурации `nginx`
- Был использован `ansible-vault` для шифрования `credentials.yml` в `environments`
- Доработан динамический `inventory`, для того, чтобы понимать для какого окружения получать инстансы
