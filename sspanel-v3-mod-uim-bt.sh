#!/bin/bash
##检查操作系统
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}

##检查是否root用户
[ $(id -u) != "0" ] && { echo -e " “\033[31m Error: 必须使用root用户执行此脚本！\033[0m”"; exit 1; }
##定义常用属性
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#宝塔sspanel-v3-mod-uim快速部署工具
echo -e "感谢使用 “\033[32m 宝塔sspanel-v3-mod-uim快速部署工具 \033[0m”"
echo "----------------------------------------------------------------------------"
echo -e "请注意这些要求:“\033[31m 宝塔版本=5.9 \033[0m”，添加网址PHP版本必须选择为“\033[31m PHP7.1 \033[0m”,添加完成后地址不要改动！"
echo "----------------------------------------------------------------------------"
read -p "请输入宝塔面板添加的网站域名,请不要修改添加之后的默认地址（例如:www.baidu.com，不带http/https）：" website
echo $website
read -p "请输入宝塔面板添加的MySQL用户名(数据库名)：" mysqlusername
echo $mysqlusername
echo "请输入宝塔面板添加的MySQL密码：" mysqlpassword
echo $mysqlpassword
echo "请输入网站的mukey(用于webapi方式对接后端，可以自定义)：" sspanelmukey
echo $sspanelmukey
sleep 1
echo "请等待系统自动操作......"
cd /www/wwwroot/$website
rm -rf index.html 404.html
##安装git unzip
yum install git unzip -y
wget -N --no-check-certificate "https://github.com/lizhongnian/ss-panel-v3-mod_Uim/archive/master.zip"
unzip master.zip
cd ss-panel-v3-mod_Uim-master
mv * .[^.]* /www/wwwroot/$website/
cd ..
rm -rf master.zip ss-panel-v3-mod_Uim-master/
sed -i 's/system,//g' /www/server/php/71/etc/php.ini
sed -i 's/proc_open,//g' /www/server/php/71/etc/php.ini
sed -i 's/proc_get_status,//g' /www/server/php/71/etc/php.ini
sed -i 's/dynamic/static/g' /www/server/php/71/etc/php-fpm.conf
sed -i 's/display_errors = On/display_errors = Off/g' /www/server/php/71/etc/php.ini
cd sql/
mysql -u$mysqlusername -p$mysqlpassword $mysqlusername < glzjin_all.sql >/dev/null 2>&1
cd ..
chown -R root:root *
chmod -R 755 *
chown -R www:www storage
php composer.phar install
echo "location / {try_files \$uri \$uri/ /index.php\$is_args\$args;}"> /www/server/panel/vhost/rewrite/$website.conf
sed -i 's/root /www/wwwroot/$website;/root /www/wwwroot/$website/public;/g' /www/server/panel/vhost/nginx/$website.conf
cd /www/wwwroot/$website
cp config/.config.php.for7color config/.config.php
sed -i 's/websiteurl/$website/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-mukey/$sspanelmukey/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-db-databasename/$mysqlusername/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-db-username/$mysqlusername/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-db-password/$mysqlpassword/g' /www/wwwroot/$website/config/.config.php



