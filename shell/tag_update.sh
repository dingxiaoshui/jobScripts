#!/bin/bash

tagDir="/var/www/html"
webConfigPro="src/config/environment.js.product"
webConfig="src/config/environment.js"

function last_check() {
    if [ $? -eq 0 ];then
        echo  "执行成功..."
    else
        echo "执行失败，请检查！"
        exit 2
    fi
}


function it_update_tag() {
  cd $tagDir/$1
  git fetch
  git checkout $2
  cp .env.produce .env
  composer install
# last_check
# php artisan config:clear
# last_check
# php artisan config:cache
# last_check
# php artisan view:clear
# last_check
# php artisan view:cache
  last_check
  TE=`curl 127.0.0.1:47289/opcache.php`
  if [  $TE != "bool(true)" ];then
      red_colour "清理opcache失败"
      exit 1
  fi
  php artisan queue:restart
  last_check
}

function web_update_tag() {
  cd $tagDir/$1
  git fetch
  git checkout $2
  cp $webConfigPro $webConfig
  /usr/bin/npm install
  /usr/bin/node build/build.js
  cd $tagDir
  rm -rf EnjoyCarWeb_Pro && cp -a EnjoyCarWeb EnjoyCarWeb_Pro
}

if [ $1 == "EnjoyCarWeb" ];then
  web_update_tag $1 $2
else
  it_update_tag $1 $2
fi