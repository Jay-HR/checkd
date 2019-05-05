#!/bin/sh
#### write by hrj
#### �ű�ÿ300�룬��/var/run/df.time״̬�ļ���������
#### ����Ϊ1970���񹲼ƶ�����
#### BOMC��ÿ5���Ӽ��״̬�ļ�ʱ���
#### ���ļ�ϵͳ�쳣���򲻻�����ļ�����

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
