
#!/bin/bash
updateLog="/data/scripts/shell/update.log"
tagDir="/var/www/html"
webConfigPro="src/config/environment.js.product"
webConfig="src/config/environment.js"

function green_colour() {
        echo -e "\033[32m ${1} \033[0m"
}


function red_colour() {
        echo -e "\033[31m ${1} \033[0m"
}

function it_update_tag() {
         cd ${tagDir}\/${1}
         git checkout $2
         cp .env.produce .env
         composer install
         last_check
#        php artisan config:clear
#        last_check
#        php artisan config:cache
#        last_check
#        php artisan view:clear
#        last_check
#        php artisan view:cache
#        last_check
         TE=`curl 127.0.0.1:47289/opcache.php`
         if [  $TE != "bool(true)" ];then
                red_colour "清理opcache失败"
                exit 1
         fi
         php artisan queue:restart
         last_check
}

function web_update_tag() {
        cd ${tagDir}\/${1}
        git checkout $2
        cp $webConfigPro $webConfig
        /usr/bin/npm install
        /usr/bin/node build/build.js
        cd $tagDir
        green_colour "拷贝最新的Web项目目录"
        rm -rf EnjoyCarWeb_Pro && cp -a EnjoyCarWeb EnjoyCarWeb_Pro
        last_check

}

function last_check() {
        if [ $? -eq 0 ];then
                green_colour "执行成功..."
        else
                red_colour "执行失败，请检查！"
                exit 2
        fi
}

function change_load() {
        python3 /data/scripts/python/changeWeight.py $1
}

function select_arg {
        cd $tagDir && ls
        green_colour "请选择要更新的项目："
        read obj[$i]
        #echo ${obj[$i]}


        if  [ ! -n "${obj[$i]}" ] ;then
                break
        fi
        #进入项目对应目录
        cd ${obj[$i]} &> /dev/null

        #判断obj变量

        git fetch
        green_colour "最近的5个标签如下"
        git tag|tail -n 5|sort -r
        green_colour "请选择要切换的标签"
        read tag[$i]
        green_colour "***********************"
        #判断tag变量

}

function A_change_tag() {
        if [ ${obj[$i]} == "EnjoyCarWeb" ];then
                 web_update_tag ${obj[$i]} ${tag[$i]}
        else
                 it_update_tag ${obj[$i]} ${tag[$i]}
        fi
}

#选择项目及标签
green_colour "选择项目及标签: "
for i in {1..10};do
        select_arg
done

#切换负载至B
green_colour "将负载全部切换至B服务器...."
change_load B
last_check
sleep 30

#在A上切换标签
green_colour "在A上切换标签"
for i in `seq ${#tag[@]}`;do
        A_change_tag
done

#切换负载至A
green_colour "将负载全部切换至A服务器...."
change_load A
last_check
sleep 30

#在B上切换标签
green_colour "在B上切换标签"
for i in `seq ${#tag[@]}`;do
        ssh -p 23548 ucar@172.18.109.228 "sudo -u nginx bash /data/scripts/shell/tag_updata.sh ${obj[$i]} ${tag[$i]} && exit"
done


green_colour "在C上切换标签"

for i in `seq ${#tag[@]}`;do
        ssh -p 23548 ucar@172.18.215.207 "sudo -u nginx bash /data/scripts/shell/tag_updata.sh ${obj[$i]} ${tag[$i]} && exit"
done

green_colour "切换负载至AB"
change_load C
last_check

green_colour "上线完成.."
