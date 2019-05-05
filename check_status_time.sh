#!/bin/sh
#### write by hrj
#### 脚本每5分钟查看/var/run/df.time文件内容
#### 当前时间是否大于文件时间300秒
#### 如是，则输出1至/var/run/df.status
#### 如否，则输出0至/var/run/df.status

FILE=/var/run/check_status_time.pid
if [ -f $FILE ];then
	PID=$( cat $FILE )
	ps -p $PID 1>/dev/null 2>&1
	if [ $? -eq 0 ];then
		exit 0
	fi
fi

echo $$ > $FILE

TIME_FILE=/var/run/df.time

STAT_FILE=/var/run/df.status
echo "0" > $STAT_FILE

while true
do
	second_current=$( date +%s )
	second_file=$( cat $TIME_FILE )
	let second_minus=${second_current}-${second_file}
	if [ $second_minus -gt 300 ];then
		echo "1" > $STAT_FILE
	else
		echo "0" > $STAT_FILE
	fi

	sleep 300
done
