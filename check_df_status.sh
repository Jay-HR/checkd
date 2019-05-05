#!/bin/sh
#### write by hrj
#### 脚本每300秒，往/var/run/df.time状态文件更新内容
#### 内容为1970至今共计多少秒
#### BOMC可每5分钟检测状态文件时间差
#### 如文件系统异常，则不会更新文件内容

FILE=/var/run/check_df_status.pid
if [ -f $FILE ];then
	PID=$( cat $FILE )
	ps -p $PID 1>/dev/null 2>&1
	if [ $? -eq 0 ];then
		exit 0
	fi
fi

echo $$ > $FILE

TIME_FILE=/var/run/df.time

date +%s > $TIME_FILE

while true
do

	VAR=0
	
	cat /etc/mtab | grep -v \
		-e proc \
		-e devpts \
		-e tmpfs \
		-e sunrpc \
		-e sysfs \
		-e mqueue \
		-e debugfs \
		-e hugetlbfs \
		-e rootfs \
		-e /sys/ \
		> /var/run/mtab.tmp
	while read LINE
	do
		DIR=$( echo $LINE | awk '{ print $2 }' )
		df -h $DIR >/dev/null 2>&1
		VAR=$( expr $VAR \| $? )
	done < /var/run/mtab.tmp

	if [ $VAR -eq 0 ];then
		date +%s > $TIME_FILE
	fi

	sleep 300
done
