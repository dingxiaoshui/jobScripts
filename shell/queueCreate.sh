#!/bin/bash
dir="/etc/supervisord.d/"
shelldir="/data/scripts/shell/"
file="${dir}${1}/${1}${2}.conf"
masterFile="${dir}$1/master-${1}${2}.conf"
cp ${shelldir}test.conf $file

function html() {
        sed -i "s@\/html\/[a-zA-Z]\+\/@\/html\/$1\/@" $file
        sed -i "s@program:[a-zA-Z]\+@program:$1$2@" $file
        sed -i "s@--queue=push@--queue=$2@" $file
        sed -i "s@\/[a-zA-Z]\+\.log@\/$1$2\.log@" $file
}

function master() {
        sed -i "s@program:[a-zA-Z]\+@program:master-$1$2@" $masterFile
        sed -i "s@\/html\/[a-zA-Z]\+\/@\/master\/$1\/@" $masterFile
        sed -i "s@\/[a-zA-Z]\+\.log@\/master-$1$2\.log@" $masterFile
}

function if_true() {
        if [ $? -ne 0 ];then
                echo "执行失败...请检查"
                exit 1
        else
                echo "执行成功.."
        fi
}
function scpFile() {
        scp -P 23548 $1 ucar@172.18.109.228:$dir$2/
        if_true
}

html $1 $2
cp $file $masterFile
master $1 $2
echo -e "\033[32m ******************************************************* \033[0m"
scpFile $file $1
scpFile $masterFile $1
