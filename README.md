# checkd
check_df_status.sh
脚本每5分钟往/var/run/df.time状态文件更新内容
容为1970至今共计多少秒
BOMC可每5分钟检测状态文件时间差
如文件系统异常，则不会更新文件内容


check_status_time.sh
脚本每5分钟查看/var/run/df.time文件内容
当前时间是否大于文件时间300秒
如是，则输出1至/var/run/df.status
如否，则输出0至/var/run/df.status
