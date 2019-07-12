#!/usr/bin/env bash

set -e
echo "使用之前，请先确保您拥有/etc/apt/source.list或者/etc/yum.repos.d/CentOS-Base.repo的写入权限！"

declare distributor_version
declare release_version
declare centos_release
declare os_code
function get_info(){
    if [ -f /usr/bin/lsb_release ];then
        lsb_get_info
    elif [ -f /etc/os-release ]; then

        get_os_release_version
    else
        echo "没有什么太好的办法获取到版本信息!告辞！"
        exit 1
    fi
}
function lsb_get_info(){
    distributor_version=`lsb_release -i| awk '{print $3}'`
    release_version=`lsb_release -r|awk '{print $2}'`
    if [ $distributor_version = "Ubuntu" ]; then
        os_code=`lsb_release -c |awk '{print $2}'`
        ubuntu_change
    elif [ $distributor_version = "CentOS" ];then
        centos_release=${release_version:0:1}
        centos_change
    else
        echo "当前系统暂不支持！"
        exit 1
    fi
}


function get_os_release_version(){
    distributor_version=`grep "NAME" /etc/os-release |head -n 1 |tr '\"' ' ' |awk '{print $2}'`
    if [ $distributor_version = "Ubuntu" ]; then
        os_code= `grep "CODENAME" /etc/os-release |head -n 1 |tr '=' ' '|awk '{print $2}'`
        ubuntu_change
    elif [ $distributor_version = "CentOS" ];then
        centos_release=`grep "VERSION_ID" /etc/os-release |head -n 1 |tr '"' ' '|awk '{print $2}'`
        centos_change
    else
        echo "当前系统暂不支持！"
        exit 1
    fi

}
function centos_change(){


if [ $centos_release = "7" ];then
    if [ -f /etc/yum.repos.d/CentOS-Base.repo ];then
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    fi
cat <<EOF > /etc/yum.repos.d/CentOS-Base.repo
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-\$releasever - Base
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/os/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=os
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-\$releasever - Updates
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/updates/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=updates
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-\$releasever - Extras
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/extras/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=extras
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-\$releasever - Plus
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/centosplus/\\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7


EOF
elif [ $centos_release = "6" ];then
    if [ -f /etc/yum.repos.d/CentOS-Base.repo ];then
        mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    fi
cat <<EOF > /etc/yum.repos.d/CentOS-Base.repo
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-\$releasever - Base
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/os/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=os
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#released updates
[updates]
name=CentOS-\$releasever - Updates
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/updates/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=updates
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that may be useful
[extras]
name=CentOS-\$releasever - Extras
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/extras/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=extras
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-\$releasever - Plus
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/centosplus/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=centosplus
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#contrib - packages by Centos Users
[contrib]
name=CentOS-\$releasever - Contrib
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/contrib/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=\$releasever&arch=\$basearch&repo=contrib
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
EOF
else
    echo "版本当前暂不支持，请自行替换！"

    exit 1
fi

}

function ubuntu_change(){
if [ -f /etc/apt/source.list ];then
    mv /etc/apt/source.list /etc/apt/source.sh_bak
fi

cat <<EOF > /etc/apt/source.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $os_code main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $os_code main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${os_code}-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${os_code}-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${os_code}-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${os_code}-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $os_code-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${os_code}-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${os_code}-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $os_code-proposed main restricted universe multiverse
EOF
}
get_info
