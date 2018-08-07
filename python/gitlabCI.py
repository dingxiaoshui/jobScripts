from flask import Flask,request,render_template,make_response
import json,os,re,requests

app = Flask(__name__)

@app.route('/test',methods=['POST'])
def hello():
    json_dict = json.loads(request.data)
    url = 'https://oapi.dingtalk.com/robot/send?access_token=bcf675a98994e4a8e9201eb86051b052a05222c48c24a1cff6cc1c9f75a8a480'
    headers = {"Content-Type": "application/json"}

    source_branch = json_dict['object_attributes']['source_branch']
    target_branch = json_dict['object_attributes']['target_branch']
    name = json_dict['user']['name']
    merge_url = json_dict['object_attributes']['url']
    match = re.match(r'hotfix/*',source_branch)
    data = {
        'name':name,
        'merge_url':merge_url,
    }
    if target_branch == 'master' and match:
        res = requests.get(url=url,headers=headers,data=data)
        return res
    else:
        return null




if __name__ == '__main__':
    app.run(host = '127.0.0.1',port=8888)

