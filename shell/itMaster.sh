#!/bin/bash
Dir="/var/www/master"
echo 'start'

function ding() {
                        url="'https://oapi.dingtalk.com/robot/send?access_token=6c166e1acc7a16839e8763b949fb4ae914f458a1df1382458b2531c259f48d9d'"
                                                header="'Content-Type: application/json'"
                                                msg="'{\"msgtype\": \"text\",\"text\": {\"content\":\"$1\"}}'"
                                                                                                                        #curl $url -H $header -d $msg
                                                a='curl '$url' -H '$header' -d '$msg
                                                eval $a
}


function last_check() {
        if [ $? -eq 0 ];then
                echo "执行成功..."
        else
                echo "执行失败，请检查！"
                ding "$1"
                exit 2
        fi
}

function update() {
        cp .env.pre-produce .env
        /usr/bin/composer install
        last_check $1
        if ! `php artisan route:list | grep Closure`;then
                ding
        fi
        php artisan config:clear
        last_check

        php artisan config:cache
        last_check

        php artisan view:clear
        last_check

        php artisan view:cache
        last_check

        TE=`curl 127.0.0.1:47289/opcache.php`
        if [  $TE != "bool(true)" ];then
                echo "清理opcache失败"
                ding "clean opcache error"
                exit 1
        fi
        /usr/local/php7/bin/php artisan queue:restart
        last_check

        echo $1 " Success"
}

function master() {
        if [ -d $Dir/$1 ];then
                cd $Dir/$1
                git pull origin master
                                                                update $1' '$2' '$3
        else
                cd $Dir
                git clone git@gitlab.51ucar.cn:${2}/${1}.git
                                                                cd $1
                                                                git checkout master
                                                                update $1' '$2' '$3
        fi
}
master $1 $2 $3

echo "Complate.."

