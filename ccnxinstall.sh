#!/usr/bin/env bash 


#
# This script installs and configures CCNx applications on an EC2 host. 
# It runs when an EC2 instances starts up; it's useful for automating 
# the installation and onfiguration of your CCNx applications.
#
# Copyright 2011 Shakir James and Washington University in St. Louis.
# See LICENSE for details.
#

echo $@

################################
APP_NAME=$1
NDN_GATEWAY_NAME=$2
APP_PARAMS="$3"

echo "APP_NAME = $APP_NAME"
echo "NDN_GATEWAY_NAME = $NDN_GATEWAY_NAME"
echo "APP_PARAMS = $APP_PARAMS"

cd /root

wget http://www.arl.wustl.edu/~jdd/NDN/NDN_GEC.tar.gz

   gunzip NDN_GEC.tar.gz
   tar -xf NDN_GEC.tar
   export HOME=/root
   cd /root ; /root/NDN_GEC/ccnx-0.4.2/csrc/lib/ccn_initkeystore.sh 

   yum -y install make

   yum -y install openssl
   yum -y install gcc
   rm /lib/libcrypto.so.6
   yum -y install openssl-devel
   yum -y install expat-devel
   yum -y install libpcap-devel
   yum -y install java-1.6.0-openjdk-devel
   #yum -y install ant

   # ANT
   cd /root/NDN_GEC
   gunzip apache-ant-1.8.2-bin.tar.gz
   tar -xf apache-ant-1.8.2-bin.tar
   mkdir /usr/local/ant /usr/local/ant/bin /usr/local/ant/lib
   cp -p -R apache-ant-1.8.2/bin/* /usr/local/ant/bin
   cp -p -R apache-ant-1.8.2/lib/* /usr/local/ant/lib
   export ANT_HOME=/usr/local/ant
   export PATH=$PATH:$ANT_HOME/bin
   echo "PATH=$PATH"

   cd /root/NDN_GEC/ccnx-0.4.2
   make clean
   make all
   make install

   cd /root/NDN_GEC/ccnx-dhcp
   make clean
   make 

   cd /root/NDN_GEC/ccnping
   make clean
   make 

   cd ~
   echo "#!/bin/sh" > /root/restartCCNX.sh
   echo "export CCND_LOG=/var/log/ccnd.log" >> /root/restartCCNX.sh
   echo "CCNX_DEBUG=7" >> /root/restartCCNX.sh
   echo "sudo -E /usr/local/bin/ccndstop" >> /root/restartCCNX.sh
   echo "sudo -E /usr/local/bin/ccndstart" >> /root/restartCCNX.sh
   chmod 755 /root/restartCCNX.sh
   #chown ec2-user ~ec2-user/restartCCNX.sh

   #echo "#!/bin/sh" > chat_thru_washu.sh
   #echo "export CCNX_USER_NAME=chat_wu" >> chat_thru_washu.sh
   #echo "/usr/local/bin/ccndc add ccnx:/ tcp 128.252.153.193 9695" >> chat_thru_washu.sh
   #echo "ccnchat -text ccnx:/ndn/wustl.edu/tstchat100" >> chat_thru_washu.sh
   #chmod 755 chat_thru_washu.sh

   #echo "#!/bin/sh" > chat_thru_csu.sh
   #echo "export CCNX_USER_NAME=chat_csu" >> chat_thru_csu.sh
   #echo "/usr/local/bin/ccndc add ccnx:/ tcp 129.82.138.48 9695" >> chat_thru_csu.sh
   #echo "ccnchat -text ccnx:/ndn/wustl.edu/tstchat100" >> chat_thru_csu.sh
   #chmod 755 chat_thru_csu.sh

   #echo "#!/bin/sh" > home_washu.sh
   #echo "~/NDN_GEC/ccnx-dhcp/ccndhcpnode -f ~/NDN_GEC/ccnx-dhcp/ccn_dhcp_client.conf.WASHU " >> home_washu.sh
foundgw=0
cd /root/NDN_GEC/ccnx-dhcp
ls
case "$NDN_GATEWAY_NAME" in
"PARC")
    echo "GATEWAY: PARC"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.PARC
    ;;
"WASHU")
    echo "GATEWAY: WASHU"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.WASHU
    ;;
"CAIDA")
    echo "GATEWAY: CAIDA"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.CAIDA
    ;;
"CSU")
    echo "GATEWAY: CSU"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.CSU
    ;;
"MEMPHIS")
    echo "GATEWAY: MEMPHIS"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.MEMPHIS
    ;;
"SPPATLA")
    echo "GATEWAY: SPPATLA"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPATLA
    ;;
"SPPHOUS")
    echo "GATEWAY: SPPHOUS"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPHOUS
    ;;
"SPPKANS")
    echo "GATEWAY: SPPKANS"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPKANS
    ;;
"SPPSALT")
    echo "GATEWAY: SPPSALT"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPSALT
    ;;
"SPPWASH")
    echo "GATEWAY: SPPWASH"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPWASH
    ;;
"ARIZONA")
    echo "GATEWAY: ARIZONA"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.ARIZONA
    ;;
"UCI")
    echo "GATEWAY: UCI"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.UIC
    ;;
"UCLA")
    echo "GATEWAY: UCLA"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.UCLA
    ;;
"UIUC")
    echo "GATEWAY: UIUC"
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.UIUC
    ;;
esac

if [ $foundgw -eq 0 ]
then
    echo "NO NDN GATEWAY found"
fi

foundapp=0
case "$APP_NAME" in
"robochat")
    echo "APP: robochat"
    foundapp=1
    echo "ccnchat -text $APP_PARAMS"
    ccnchat -text $APP_PARAMS
    ;;
"robochat_server")
    echo "APP: robochat_server"
    foundapp=1
    #echo "ccnchat -text $APP_PARAMS"
    #ccnchat -text $APP_PARAMS
    ;;
"vlc")
    echo "APP: vlc"
    foundapp=1
    ;;
esac

if [ $foundapp -eq 0 ]
then
    echo "NO APP Name found"
fi

