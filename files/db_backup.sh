#!/bin/bash

if [ ! -d "/tmp/db_backup" ] ; then
        mkdir /tmp/db_backup
        mkdir /tmp/db_backup/dump
        mkdir /tmp/db_backup/backup
fi

mysqldump -hlocalhost -P3306 -uroot --databases wordpress > /tmp/db_backup/dump/db_backup_wordpress_$(date +"%H:%M_%d:%m:%Y").sql

xtrabackup --host=localhost --port=3306 --user=root --password=12345678 --backup --target-dir=/tmp/db_backup/backup/base_$(date +"%H:%M_%d:%m:%Y")