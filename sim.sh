sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
yum install openssh iptables vim bash-completion epel-release vim -y
systemctl start sshd
systemctl enable sshd
systemctl restart sshd
iptables -X
iptables -Z
iptables -F
iptables  -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables  -A INPUT -p tcp --dport 443 -j ACCEPT
iptables  -A INPUT -p tcp --dport 80 -j ACCEPT
iptables  -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED  -j ACCEPT
echo "set nu\nset ts=2\ncolorscheme desert" >> /etc/vimrc
yum install alias -y
echo "alias vi=vim" >> /etc/profile
yum install wget -y
cd /etc/yum.repos.d 
mv CentOS-Base.repo CentOS-Base.repo.bak
wget -O CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache

