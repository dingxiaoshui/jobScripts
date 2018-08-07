# -*- coding:utf-8 -*-
from urllib import parse,request
import json,time


#打卡urlbody信息
user_lst=['0827280557676431', '064522575328046899', '026343311628104737', '184333206420360762', '014157692537915802', '044310175437891979', '066363441938082224', '133333195226373075', '043621216237868470', '13674142461181095', '121309476122796332', '085639291229609852', '013219483383355846', '031411151832880076', '073316693836363438', '071708004120933013', '061659076226270448', '04305845371213650', '2846591524350931', '086217405724240252', '020914592140147029']
textmod={
    "userIds":user_lst,
    "checkDateFrom": "2018-06-28 00:00:00",
    "checkDateTo": "2018-06-28 23:59:00"
}

textmod=json.dumps(textmod).encode(encoding='utf-8')

#打卡url头部信息
harder_dict={'Content-Type':'application/json'}

#打卡时间url
card_url = 'https://oapi.dingtalk.com/attendance/listRecord?access_token=4fd04ac22cce3afe910128f2d74d3cc6'

#打卡时间url数据
card_req=request.Request(url=card_url,data=textmod,headers=harder_dict)
card_res=request.urlopen(card_req)
card_res = card_res.read().decode('utf-8')


#用户列表url
user_url = 'https://oapi.dingtalk.com/user/list?access_token=4fd04ac22cce3afe910128f2d74d3cc6&department_id=38978319'

#用户json数据
user_req=request.Request(url=user_url,)
user_res=request.urlopen(user_req)
user_res = user_res.read().decode('utf-8')


#提取用户数据
lst_user={}
user_dict=json.loads(user_res)
for i in user_dict['userlist']:
     lst_user[i['name']]=i['userid']




#提取打卡数据
pm_user=[]
card_dict=json.loads(card_res)

for i in card_dict['recordresult']:
    real_time=str(i['userCheckTime'])[:-3]
    local_time = time.localtime(int(real_time))
    a_time=time.strftime("%H:%M:%S",local_time)
    #如果打卡时间在此范围内，则记录在列表内
    if a_time >= "18:00:00" and a_time <= "23:59:59":
        pm_user.append(i['userId'])

#如果用户的userid不在此列表中，则打印出这些用户
for i in lst_user:
    if lst_user[i] not in pm_user:
        print(i)
