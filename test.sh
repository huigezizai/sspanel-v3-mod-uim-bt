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
sleep 1
echo -e "${Info} 请确认您输入的网站域名：$website"
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
sed -i "s/websiteurl/$website\/g" /www/wwwroot/$website/config/.config.php
