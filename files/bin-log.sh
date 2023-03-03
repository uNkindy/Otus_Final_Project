#!/bin/bash

echo "Start script time: " $(date) >> /root/bin-log.txt
mysql -e "SHOW MASTER STATUS\G" >> /root/bin-log.txt
echo "==============================================================" >> /root/bin-log.txt
echo " " >> /root/bin-log.txt