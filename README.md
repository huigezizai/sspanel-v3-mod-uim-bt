# 基于宝塔面板的sspanel-v3-mod-uim一键安装脚本：   

* 在线演示：暂无   
* 本人博客：https://www.7colorblog.com  
* 七彩杂铺货：https://faka.7colorblog.com  

#安装教程

## 宝塔5.9安装
需要是centos7系统
先安装宝塔
``` bash
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install.sh && sh install.sh
```
## 宝塔环境准备
安装宝塔后登录，选择一键安装lnmp环境，注意php版本选择7.1，其他默认，
然后创建网站，输入的域名，不要改,如下

![基于宝塔面板的sspanel-v3-mod-uim一键安装脚本](http://g.hiphotos.baidu.com/image/%70%69%63/item/b21c8701a18b87d6298b649d0a0828381e30fd63.jpg)


## 安装脚本
``` bash
wget -N --no-check-certificate https://raw.githubusercontent.com/lizhongnian/sspanel-v3-mod-uim-bt/master/sspanel-v3-mod-uim-bt.sh &&
chmod +x sspanel-v3-mod-uim-bt.sh &&
bash sspanel-v3-mod-uim-bt.sh
```
复制执行以上脚本，如下图：

![基于宝塔面板的sspanel-v3-mod-uim一键安装脚本](http://f.hiphotos.baidu.com/image/%70%69%63/item/dc54564e9258d1092e026730dc58ccbf6d814d4b.jpg)

第一步，输入网站域名+mysql用户名+mysql密码+mukey</br>
第二步，根据返回的信息核对你输入的是否正确</br>
第三步，如果正确按1继续，不正确按2退出</br>
第四步，然后就静静地等待自动安装，安装完成会输入成功的提示</br>

ps:本脚本并未在所有机器都测试过，处于新生脚本，</br>
希望大家可以多提提意见，大家有问题可以及时返回给我</br>
联系方式：<a target="_blank" href="//shang.qq.com/wpa/qunwpa?idkey=0e0ad00fa39b8d74f9aee8aba6d4fa87387d41ae60a8f617e437a9ae5c4cea32">七彩blog交流群</a>
