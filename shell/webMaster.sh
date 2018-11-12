#!/bin/bash
Dir="/var/www/master"
EnvirmentJs="$Dir/ucarCarWeb/src/js/environment.js.develop"
DirEnvirJs="$Dir/ucarCarWeb/src/js/environment.js"
EnjoyJsDe="$Dir/EnjoyCarWeb/src/config/environment.js.uat"
EnjoyJs="$Dir/EnjoyCarWeb/src/config/environment.js"
function pull_say() {
        PullDir=$1
        if [ $? -ne 0 ];then
                echo "PullDir Git Pull Error"
                exit
        fi
}

function Compile() {

if [ $? -ne 0 ];then
        echo "Compile Error"
        exit
fi

}
echo 'start'
if [ $1 == "EnjoyCarWeb" ];then
        if [ -d $Dir/$1 ];then
                cd $Dir/EnjoyCarWeb
                startTime=$(ls -l package.json|awk '{print $6,$7,$8}')
                JstartTime=$(ls -l $EnjoyJsDe|awk '{print $6,$7,$8}')
                git pull origin master
                pull_say
                stopTime=$(ls -l package.json|awk '{print $6,$7,$8}')
                JstopTime=$(ls -l $EnjoyJsDe|awk '{print $6,$7,$8}')

                cp $EnjoyJsDe $EnjoyJs

                if [ "$startTime" != "$stopTime" ];then
                        rm -f package-lock.json
                        /usr/bin/npm install
                        /usr/bin/node build/build.js
                        Compile
                else
                        /usr/bin/node build/build.js
                        Compile

                fi
                echo $1 "Success"
        else
                cd $Dir
                git clone git@gitlab.51ucar.cn:web/EnjoyCarWeb.git
                git checkout master
                cp $EnjoyJsDe $EnjoyJs
                /usr/bin/npm install
                Compile
                /usr/bin/node build/build.js
                Compile
                echo $1 "Success"
        fi
elif [ $1 == "ucarCarWeb" ];then
        cd $Dir/ucarCarWeb
        startTime=$(ls -l package.json|awk '{print $6,$7,$8}')
        JstartTime=$(ls -l $EnvirmentJs|awk '{print $6,$7,$8}')
        git pull origin develop
        pull_say
        stopTime=$(ls -l package.json|awk '{print $6,$7,$8}')
        JstopTime=$(ls -l $EnvirmentJs|awk '{print $6,$7,$8}')
        if [ "$JstartTime" != "$JstopTime" ];then
                cp $EnvirmentJs $DirEnvirJs
        fi
        if [ "$startTime" != "$stopTime" ];then
                rm -f package-lock.json
                /usr/bin/npm install
                /usr/bin/node build/build.js
                Compile
        else
                /usr/bin/node build/build.js
                Compile
        fi
        echo $1 "Success"

fi
echo "Complate.."
****
