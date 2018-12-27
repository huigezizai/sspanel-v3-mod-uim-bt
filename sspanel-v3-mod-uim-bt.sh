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
stty erase '^H' && read -p "请输入宝塔面板添加的网站域名,请不要修改添加之后的默认地址（例如:www.baidu.com，不带http/https）：" website
stty erase '^H' && read -p "请输入宝塔面板添加的MySQL用户名(数据库名)：" mysqlusername
stty erase '^H' && read -p "请输入宝塔面板添加的MySQL密码：" mysqlpassword
stty erase '^H' && read -p "请输入网站的mukey(用于webapi方式对接后端，可以自定义)：" sspanelmukey
sleep 1
echo -e "${Info} 请确认您输入的网站域名：$website"
echo -e "${Info} 请确认您输入的MySQL用户名：$mysqlusername"
echo -e "${Info} 请确认您输入的MySQL密码：$mysqlpassword"
echo -e "${Info} 请确认您输入的mukey：$sspanelmukey"
stty erase '^H' && read -p " 请输入数字(1：继续；2：退出) [1/2]:" status
case "$status" in
	1)
	echo -e "${Info} 您选择了继续，开始安装程序！"
	;;
	2)
	echo -e "${Tip} 您选择了退出，请重新执行安装程序！" && exit 1
	;;
	*)
	echo -e  "${Error} 请输入正确值 [1/2]，请重新执行安装程序" && exit 1
	;;
esac
echo -e "${Info} 请等待系统自动操作......"
cd /www/wwwroot/$website
rm -rf index.html 404.html
##安装git unzip crontab
echo -e "${Info} 正在检测安装git、unzip、crontab工具"
yum install git unzip crontab -y
echo -e "${Info} 检测安装git、unzip、crontab工具已完成"
sleep 1
echo -e "${Info} 正在下载解压处理程序源码"
wget -N --no-check-certificate "https://github.com/lizhongnian/ss-panel-v3-mod_Uim/archive/dev.zip"
unzip dev.zip
cd ss-panel-v3-mod_Uim-dev
mv * .[^.]* /www/wwwroot/$website/
cd ..
rm -rf dev.zip ss-panel-v3-mod_Uim-dev/
echo -e "${Info} 下载解压处理程序源码已完成"
sleep 1
echo -e "${Info} 正在处理宝塔php内容"
sed -i 's/system,//g' /www/server/php/71/etc/php.ini
sed -i 's/proc_open,//g' /www/server/php/71/etc/php.ini
sed -i 's/proc_get_status,//g' /www/server/php/71/etc/php.ini
sed -i 's/dynamic/static/g' /www/server/php/71/etc/php-fpm.conf
sed -i 's/display_errors = On/display_errors = Off/g' /www/server/php/71/etc/php.ini
echo -e "${Info} 处理宝塔php内容已完成"
sleep 1
echo -e "${Info} 正在导入数据库"
cd sql/
mysql -u$mysqlusername -p$mysqlpassword $mysqlusername < glzjin_all.sql >/dev/null 2>&1
echo -e "${Info} 导入数据库已完成"
sleep 1
echo -e "${Info} 正在安装依赖"
cd ..
chown -R root:root *
chmod -R 755 *
chown -R www:www storage
php composer.phar install
echo -e "${Info} 安装依赖已完成"
sleep 1
echo -e "${Info} 正在处理nginx内容"
echo "location / {try_files \$uri \$uri/ /index.php\$is_args\$args;}"> /www/server/panel/vhost/rewrite/$website.conf
sed -i 's/root /www/wwwroot/${website};/root /www/wwwroot/$website/public;/g' /www/server/panel/vhost/nginx/$website.conf
echo -e "${Info} 处理nginx内容已完成"
sleep 1
echo -e "${Info} 正在配置站点基本信息"
cd /www/wwwroot/$website
cp config/.config.php.for7color config/.config.php
sed -i 's/websiteurl/${website}/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-mukey/${sspanelmukey}/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-db-databasename/${mysqlusername}/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-db-username/${mysqlusername}/g' /www/wwwroot/$website/config/.config.php
sed -i 's/sspanel-db-password/${mysqlpassword}/g' /www/wwwroot/$website/config/.config.php
echo -e "${Info} 配置站点基本信息已完成"
sleep 1
echo -e "${Info} 正在添加定时任务"
echo "30 22 * * * php /www/wwwroot/$website/xcat sendDiaryMail" >> /var/spool/cron/root
echo "0 0 * * * php -n /www/wwwroot/$website/xcat dailyjob" >> /var/spool/cron/root
echo "*/1 * * * * php /www/wwwroot/$website/xcat checkjob" >> /var/spool/cron/root
echo "*/1 * * * * php /www/wwwroot/$website/xcat syncnode" >> /var/spool/cron/root
echo -e "${Info} 添加定时任务已完成"
sleep 1
echo -e "${Info} 正在重启PHP"
/etc/init.d/php-fpm-71 restart
echo -e "${Info} 重启PHP已完成"
sleep 1
echo -e "${Info} 正在重启NGINX"
/etc/init.d/nginx restart
echo -e "${Info} 重启NGINX已完成"
sleep 3
echo $Tip "安装即将完成，倒数五个数！"
sleep 1
echo "-----------------------------"
echo "#############################"
echo "########           ##########"
echo "########   ##################"
echo "########   ##################"
echo "########           ##########"
echo "###############    ##########"
echo "###############    ##########"
echo "########           ##########"
echo "#############################"
sleep 1
echo "-----------------------------"
echo "#############################"
echo "#######   ####   ############"
echo "#######   ####   ############"
echo "#######   ####   ############"
echo "#######               #######"
echo "##############   ############"
echo "##############   ############"
echo "##############   ############"
echo "#############################"
sleep 1
echo "-----------------------------"
echo "#############################"
echo "########            #########"
echo "#################   #########"
echo "#################   #########"
echo "########            #########"
echo "#################   #########"
echo "#################   #########"
echo "########            #########"
echo "#############################"
sleep 1
echo "-----------------------------"
echo "#############################"
echo "########           ##########"
echo "################   ##########"
echo "################   ##########"
echo "########           ##########"
echo "########   ##################"
echo "########   ##################"
echo "########           ##########"
echo "#############################"
sleep 1
echo "-----------------------------"
echo "#############################"
echo "############   ##############"
echo "############   ##############"
echo "############   ##############"
echo "############   ##############"
echo "############   ##############"
echo "############   ##############"
echo "############   ##############"
echo "#############################"
echo "-----------------------------"
sleep 1
echo "----------------------------------------------------------------------------"
echo -e "${Info} 部署完成，请打开http://$website即可浏览"
echo -e "${Info} 默认生成的管理员用户名密码都为7colorblog"
echo -e "${Info} 如果打不开站点，请到宝塔面板中软件管理重启nginx和php7.1"
echo -e "${Info} github地址:https://github.com/lizhongnian/sspanel-v3-mod-uim-bt"
echo -e "${Info} 博客地址:https://www.7colorblog.com/"
echo "----------------------------------------------------------------------------"


