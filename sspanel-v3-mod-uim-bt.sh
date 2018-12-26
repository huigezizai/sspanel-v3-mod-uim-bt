#!/bin/bash
#Check Root
[ $(id -u) != "0" ] && { echo -e " “\033[31mError: 必须使用root用户执行此脚本！\033[0m”"; exit 1; }
#宝塔sspanel-v3-mod-uim快速部署工具
echo -e "感谢使用 “\033[32m 宝塔sspanel-v3-mod-uim快速部署工具 \033[0m”"
echo "----------------------------------------------------------------------------"
echo -e "请注意这些要求:“\033[31m 宝塔版本=5.9 \033[0m”，添加网址PHP版本必须选择为“\033[31m PHP7.1 \033[0m”,添加完成后地址不要改动！"
echo "----------------------------------------------------------------------------"
echo "请输入宝塔面板添加的网站域名,请不要修改添加之后的默认地址（例如:www.baidu.com，不带http/https）："
read web
echo $web
