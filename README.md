# sectronov_infra
sectronov Infra repository

## Homework 4
```
bastion_IP = 35.205.140.104
someinternalhost_IP = 10.132.0.3
```

**Подключение к `someinternalhost` в одну команду:**

`ssh -i ~/.ssh/appuser -o ProxyCommand="ssh -W %h:%p appuser@$bastion_IP" appuser@$someinternalhost_IP`

**Подключение к someinternalhost через команду `ssh someinternalhost`**

В файл ~/.ssh/config добавить:
```
Host bastion
Hostname $bastion_IP
User appuser

Host someinternalhost
Hostname $someinternalhost_IP
User appuser
ProxyCommand ssh -W %h:%p bastion
```
