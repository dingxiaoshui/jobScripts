import os,time

SERVER_HOST = 'rm-wz9azm783hlq621sfsdn9.mysql.rds.aliyuncs.com'
SERVER_PORT = '3306'
SERVER_USER = '*******'
SERVER_PASSWORD= '********'


BACKDIR='/data/backup/mysql/'

dataBaseList=['contacts','contacts-test','enjoy-car','enjoy-car-test','gerritdb','mindoc_db','queue','queue-test','ucar','ucar-admin','ucar-admin-test','ucar-agent','ucar-agent-test','ucar-audit','ucar-audit-test','ucar-capital','ucar-capital-test','ucar-public','ucar-public-test','ucar-statistics','ucar-statistics-test','ucar-user','ucar-user-test']


for i in dataBaseList:
    backTime = time.asctime()[-13:-5].replace(':','_')
    fileName = BACKDIR+i+backTime+'.sql'
    mysqlBack = "mysqldump -u" + SERVER_USER +" " + "-h"+ SERVER_HOST + " -p" + SERVER_PASSWORD + " " + i + " >> " + fileName
    try:
        os.system('mysqlBack')
    except:
        print('mysql backup error')
    else:
        print('mysql backup success')
