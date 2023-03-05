### Финальный проект курса "Otus Linux Professional"
### Тема проекта: "Развертывание веб-сервера WordPress с отказоустйчивой базой данных MySQL и сбором логов и мониторингом на базе решений стека Promethtus/Grafana/Loki"
___
#### 1. Требования к окружению для его развертывания:
- для корректного запуска стенда необходимо следующее окружение:
    - __Hashicorp Vagrant__ (для работы необходим VPN для скачивания образов с Vagrant Cloud) version >= 2.2.19;
    - __Ansible version__ >= 2.10.17 (python => 3.8.10);
    - __Git version__ >= 2.30.2; 
- перед запуском виртуальных машин командой __"vagrant up"__ необходимо проверить соответствие портов и путей к ssh-ключам в файле inventory/[hosts.yml](https://github.com/uNkindy/Otus_Final_Project/blob/main/inventory/hosts.yml); 
___
#### 2. Описание стенда:
- стенд представляет собой 3 виртуальные машины со следующими характеристиками, завдаваемыми в [Vagrantfile](https://github.com/uNkindy/Otus_Final_Project/blob/main/Vagrantfile):

 |Name|Parameter|
 | --- | --- |
| __ВМ1__ | |
| Hostname | wordpress |
| OS | Centos 7 (kernel 3.10) |
| RAM | 2 Gb |
| IP | 192.168.56.241/24 |
| Forward Ports | 80 (guest) > 8081 (host) - wordpress, 9100 (guest) > 9101 (host) - Prometheus node exporter, 9080 (host) > 9081 (host) - Loki Promtail |
| __ВМ 2__ | | 
| Hostname | replica |
| OS | Centos 7 (kernel 3.10) |
|RAM | 2 Gb |
|IP | 192.168.56.242/24 |
|Forward Ports | - |
| __ВМ 3__ | |
| Hostname | moitoring |
| OS | Centos 7 (kernel 3.10) |
| RAM | 2 Gb |
| IP | 192.168.56.243/24 |
| Forward Ports | 9090 (guest) > 9090 (host) - Prometheus Server, 9100 (guest) > 9101 (host) - Prometheus node exporter, 9080 (host) > 9081 (host) - Loki Promtail |

__Схема стенда:__
<a href="https://ibb.co/8BJY85S"><img src="https://i.ibb.co/0XksJMd/final-project-shema.jpg" alt="final-project-shema" border="0" /></a>
___
#### 3. Этапы развертывания стенда:
- __Этап 1__: клонировать с git репозиторий с проектом;
```console
git clone https://github.com/uNkindy/Otus_Final_Project.git
```
- __Этап 2__: перейти в папку с проектом и запустить Vagrant для создания 3 виртуальных машин;
```console
cd /path_to_project && vagrant up
```
- __Этап 3__: после создания ВМ приступить к разворачиванию конфигурации на виртуальных машинах при помощи [Ansible Playbook](https://github.com/uNkindy/Otus_Final_Project/blob/main/final_project.yml). С целью удобства и контролирования процесса разворачивания конфигурации запуск плейбука производится в несколько этапов:
    - разворачиваем конфигурацию на ВМ wordpress:
    ```console
    ansible-playbook final_project.yml -t wordpress
    ```
    При этом на ВМ wordpress будут развернуты: Apache httpd (version 2.4.6), php 7.4, MySQL (version 8.0.32), Prometheus Node exporter (version 1.5.0), Loki Promtail (2.7.4), xtrabackup (version 2.3.6). Для корректной установки пакетов плейбук копирует на ВМ файлы репозиториев MySQL, Grafana, Prometheus. На ВМ копируются два скрипта [__bin-log.sh__](https://github.com/uNkindy/Otus_Final_Project/blob/main/files/bin-log.sh) и [__db_backup.sh__](https://github.com/uNkindy/Otus_Final_Project/blob/main/files/db_backup.sh). Первый скрипт отправляет на хост информацию номера файла bin.log и номер строки в файле для последующей настройки репликации. Второй скрипт совместно с [Init](https://github.com/uNkindy/Otus_Final_Project/blob/main/files/backup.service) и [timer](https://github.com/uNkindy/Otus_Final_Project/blob/main/files/backup.timer) файлами каждые 5 минут (ИПС) делают дамп и полную копию базы данных wordpress. В MySQL создается 2 пользователя: wordpress и replication. Пароли для данных пользователей вынесены в отдельный [файл](https://github.com/uNkindy/Otus_Final_Project/blob/main/defaults/main.yml).
    IP адрес wordpress: __localhost:8081 (192.168.56.241:80)__.
    - разворачиваем конфигурацию на ВМ replica:
    ```console
    ansible-playbook final_project.yml -t replica
    ```
    При этом на ВМ wordpress будут развернуты: MySQL (version 8.0.32), Prometheus Node exporter (version 1.5.0), Loki Promtail (2.7.4). 
    - подготавливаем ВМ wordpress и replica к репликации:
    ```console
    ansible-playbook final_project.yml -t replication
    ```
    При этом на ВМ wordpress делается дамп базы данных wordpress, копируется на ВМ replica и применятеся к БД wordpress на реплике. Далее в корневой папке проекта создается файл bin-log.txt с акутальными настройками для настройки репликации. Эти значения нужно внести в файл настроек [main.yml](https://github.com/uNkindy/Otus_Final_Project/blob/main/defaults/main.yml).
    - запуск процесса репликации:
    ```console
    ansible-playbook final_project.yml -t starting
    ```
    При этом на ВМ replica производится настройка реплики и запуск режима slave.
    - разворачиваем конфигурацию на ВМ monitoring:
    ```console
    ansible-playbook final_project.yml -t monitoring
    ```
    При этом на ВМ monitoring будут развернуты: Prometheus (version 1.8.2), Loki (version 2.7.4), Grafana (version 9.4.3), Prometheus Node exporter (version 1.5.0).

| Name | IP |
| --- | --- |
|  IP адрес Prometheus | localhost:9090 (192.168.56.243:9090) |
|  IP адрес Grafana | localhost:3000 (192.168.56.243:3000) |
|  IP адрес Loki | localhost:3100 (192.168.56.243:3100) |
___
#### 4. Настройка мониторинга.
Для настройки мониторинга в Grafana устанавливается dashboard __11074__;
Promtail настоен отправлять следующие логи:
```console
/var/log/*log
/var/log/httpd/*
```
___
#### 5. Состав проекта:
- Vagrantfile;
- Ansible Playbook - final_project;
- README.md;
- ansible.cfg - файл настроек окружения ansible;
- /files/ - файлы конфигураций для автоматизированной настройки стенда;
- /defaults/ - файл переменных стенда;
- inventory/hosts.yml - файл настройки управляемых хостов;
___
