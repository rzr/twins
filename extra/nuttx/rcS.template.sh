#!/bin/nsh
set +e
set -x
echo "# NuttX:"
# cat /proc/version
help
pwd

echo "# Network"
ifconfig
ifup eth0
renew eth0
ifconfig
sleep 1

echo "# Filesystem"
mount
ls /etc
ls /etc/init.d
mkdir /mnt
mount -t tmpfs /mnt/ ; cd /mnt
mkdir /mnt/sdcard
sleep 1

echo "# IoT.js: IOTJS_PATH: ${IOTJS_PATH} ? /mnt/sdcard"
cd /mnt/sdcard
echo "console.log(process)" > index.js
iotjs index


echo "# main"
cd /rom
cat /proc/uptime
cat /proc/meminfo
iotjs index.js
cat /proc/uptime
cat /proc/meminfo
echo "# exit, rebooting"
reboot
echo "# failure"
