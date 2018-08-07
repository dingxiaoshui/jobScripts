import pymysql
import re

class MysqlAuto(object):
    def __init__(self,database,user,passwd):
        self.database = database
        self.user = user
        self.passwd = passwd

    #定义数据库连接
    def mysql_conn(self):
        conn = pymysql.connect(host='rm-wz9azm783shlq621n9sfs.mysql.rds.aliyuncs.com', user='****',password='******')
        cur = conn.cursor()
        return cur

    #通过传入的参数判断是否为测试库，然后分配不同的权限
    def add_database(self):

        create_base = 'create database ' + self.database
        cur = self.mysql_conn()
        cur.execute(create_base)

        devGrantPrivi = 'GRANT ALL PRIVILIGES ON ' + self.database + '.*' + ' to ' + self.user + '@\'%\' identified by ' + '\'' + self.passwd +'\''
        proGrantPrivi = 'GRANT SELECT,SHOW VIEW ON ' + self.database + '.*' + ' to ' + self.user + '@\'%\' identified by ' + '\''+ self.passwd +'\''
        dbDevGrantPrivi = 'GRANT ALL PRIVILIGES ON ' + self.database + '.*' + ' to db_select@\'%\''
        dbProGrantPrivi = 'GRANT SELECT,SHOW VIEW ON ' + self.database + '.*' + ' to db_select@\'%\''

        pattern = re.compile(r'.*-test$')
        match = re.search(pattern, self.database)
        if match:
            try:
                cur.execute(devGrantPrivi)
                cur.execute(dbDevGrantPrivi)
                return 0
            except:
                exit(1)
        else:
            try:
                cur.execute(proGrantPrivi)
                cur.execute(dbProGrantPrivi)
                return 0
            except:
                exit(2)

    def print(self):
        print(cur)
#
    def del_user(self):
        delete_user = 'drop user ' + self.user + '@\'%\''
        cur = self.mysql_conn()
        try:
            cur.execute(delete_user)
            return 0
        except:
            exit(1)

example = MysqlAuto('xiaoshui','data','shuipass')

example.del_user()
