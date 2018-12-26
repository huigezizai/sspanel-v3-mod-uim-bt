#!/bin/bash
#Check Root
[ $(id -u) != "0" ] && { echo -e " “\033[31m Error: 必须使用root用户执行此脚本！\033[0m”"; exit 1; }
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
sleep 1
echo "请等待系统自动操作......"
cd /www/wwwroot/$web
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
sed -i 's/root /www/wwwroot/www.baidu.com;/root /www/wwwroot/www.baidu.com/public;/g' /www/server/panel/vhost/nginx/$website.conf
