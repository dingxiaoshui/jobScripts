import base64,urllib.request
import hashlib
import hmac
import uuid,time,json,wget



class RDS_BINLOG_RELATE(object):

    def __init__(self):
        self.access_id = '*************'
        self.access_key = '*************'

    #通过id和key来进行签名
    def signed(self):
        timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        header = {
            'Action': 'DescribeBinlogFiles',
            'DBInstanceId': 'rm-wz9azm783hlq621n9',
            'StartTime': '2018-07-11T15:00:00Z',
            'EndTime': timestamp,
            'Format': 'JSON',
            'Version': '2014-08-15',
            'AccessKeyId': 'LTAIRrEMWqcD9kYX',
            'SignatureVersion': '1.0',
            'SignatureMethod': 'HMAC-SHA1',
            'SignatureNonce': str(uuid.uuid1()),
            'TimeStamp': timestamp,

        }
        sortedD = sorted(header.items(), key=lambda x: x[0])
        url = 'https://rds.aliyuncs.com'
        canstring = ''


        for k, v in sortedD:
            canstring += '&' + self.percentEncode(k) + '=' + self.percentEncode(v)

        stiingToSign = 'GET&%2F&' + self.percentEncode(canstring[1:])

        bs = self.access_key + '&'
        bs = bytes(bs, encoding='utf8')
        stiingToSign = bytes(stiingToSign, encoding='utf8')
        h = hmac.new(bs, stiingToSign, hashlib.sha1)
        stiingToSign = base64.b64encode(h.digest()).strip()

        header['Signature'] = stiingToSign

        url = url + "/?" + urllib.parse.urlencode(header)
        return url

    #按照规则替换
    def percentEncode(self,store):
        encodeStr = store
        res = urllib.request.quote(encodeStr)
        res = res.replace('+', '%20')
        res = res.replace('*', '%2A')
        res = res.replace('%7E', '~')
        return str(res)

    #筛选出链接下载二进制日志文件
    def getBinLog(self):
        binlog_url = self.signed()
        req = urllib.request.urlopen(binlog_url)
        req = req.read().decode('utf8')

        res = json.loads(req)

        for i in res['Items']['BinLogFile']:
            wget.download(i['DownloadLink'])




s = RDS_BINLOG_RELATE()
s.getBinLog()