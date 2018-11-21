# jobScripts
---
## python

- createMysqlUser.py
> 创建数据库用户并对不同的数据库分配不同的权限，只要为正式数据库和测试数据库

- dakaCount.py
> 统计钉钉昨日未打卡的人员

- gitlabCI.py
> 想通过gitlab的钩子来触发脚本，但是因为null中断

- mysqlBackup.py
> 备份mysql数据库

- rds_binlog.py
> 通过阿里云RDS的api来实现下载mysql的二进制日志

---

## shell

- change_server_tag.sh
> 通过传入项目名以及tag来实现灰度发布，中间通过python的实现负载切换

- itMaster.sh
> gitlab的钩子脚本，通过push触发来实现更新项目代码(后端项目php)

- queueCreate.sh
> 利用supervisord来管理队列的创建

- tag_update.sh
> 和change_server_tag.sh结合来实现灰度发布

- webMaster.sh
> gitlab的钩子脚本，通过push触发来实现更新项目代码(前端项目node.js)