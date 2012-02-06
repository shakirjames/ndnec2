#!/usr/bin/env bash 


#
# This script installs and configures CCNx applications on an EC2 host. 
# It runs when an EC2 instances starts up; it's useful for automating 
# the installation and onfiguration of your CCNx applications.
#
# Copyright 2011 Shakir James and Washington University in St. Louis.
# See LICENSE for details.
#

echo "Usage: $0 $@"
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
   #cd /root ; /root/NDN_GEC/ccnx-0.4.2/csrc/lib/ccn_initkeystore.sh 
   cd /root ; /root/NDN_GEC/ccnx/csrc/lib/ccn_initkeystore.sh 

   if [ $APP_NAME = "vlc" ]
   then
      echo "VLC:"
      apt-get update
      apt-get install gcc
   else
     yum -y install make

     yum -y install openssl
     yum -y install gcc
     rm /lib/libcrypto.so.6
     yum -y install openssl-devel
     yum -y install expat-devel
     yum -y install libpcap-devel
     yum -y install java-1.6.0-openjdk-devel
     #yum -y install ant
     yum -y install asciidoc
   fi

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

   #cd /root/NDN_GEC/ccnx-0.4.2
   cd /root/NDN_GEC/ccnx
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
   #echo "sudo -E /usr/local/bin/ccndstop" >> /root/restartCCNX.sh
   #echo "sudo -E /usr/local/bin/ccndstart" >> /root/restartCCNX.sh
   echo "/usr/local/bin/ccndstop" >> /root/restartCCNX.sh
   echo "/usr/local/bin/ccndstart" >> /root/restartCCNX.sh
   chmod 755 /root/restartCCNX.sh
   /root/restartCCNX.sh 
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
    export CCNX_USER_NAME=chat_parc
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.PARC
    ;;
"WASHU")
    echo "GATEWAY: WASHU"
    export CCNX_USER_NAME=chat_washu
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.WASHU
    ;;
"CAIDA")
    echo "GATEWAY: CAIDA"
    export CCNX_USER_NAME=chat_caida
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.CAIDA
    ;;
"CSU")
    echo "GATEWAY: CSU"
    export CCNX_USER_NAME=chat_csu
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.CSU
    ;;
"MEMPHIS")
    echo "GATEWAY: MEMPHIS"
    export CCNX_USER_NAME=chat_memphis
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.MEMPHIS
    ;;
"SPPATLA")
    echo "GATEWAY: SPPATLA"
    export CCNX_USER_NAME=chat_sppatla
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPATLA
    ;;
"SPPHOUS")
    echo "GATEWAY: SPPHOUS"
    export CCNX_USER_NAME=chat_spphous
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPHOUS
    ;;
"SPPKANS")
    echo "GATEWAY: SPPKANS"
    export CCNX_USER_NAME=chat_sppkans
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPKANS
    ;;
"SPPSALT")
    echo "GATEWAY: SPPSALT"
    export CCNX_USER_NAME=chat_sppsalt
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPSALT
    ;;
"SPPWASH")
    echo "GATEWAY: SPPWASH"
    export CCNX_USER_NAME=chat_sppwash
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.SPPWASH
    ;;
"ARIZONA")
    echo "GATEWAY: ARIZONA"
    export CCNX_USER_NAME=chat_arizona
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.ARIZONA
    ;;
"UCI")
    echo "GATEWAY: UCI"
    export CCNX_USER_NAME=chat_uci
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.UCI
    ;;
"UCLA")
    echo "GATEWAY: UCLA"
    export CCNX_USER_NAME=chat_ucla
    foundgw=1
    ./ccndhcpnode -f ccn_dhcp_client.conf.UCLA
    ;;
"UIUC")
    echo "GATEWAY: UIUC"
    export CCNX_USER_NAME=chat_uiuc
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
"null")
    echo "APP: null"
    foundapp=1
    ;;
"robochat")
    echo "APP: robochat"
    foundapp=1
    echo "ccnchat -text $APP_PARAMS"
    /usr/local/bin/ccnchat -text $APP_PARAMS
    ;;
"robochat_server1")
    echo "APP: robochat_server1"
    foundapp=1
    #echo "ccnchat -text $APP_PARAMS"
    #ccnchat -text $APP_PARAMS
    cd /root/NDN_GEC/robochat
    export CCNX_USER_NAME=Declaration
    ./chat_read.sh  Declaration_of_Independence.txt | /usr/local/bin/ccnchat -text $APP_PARAMS
    ;;
"robochat_server2")
    echo "APP: robochat_server2"
    foundapp=1
    #echo "ccnchat -text $APP_PARAMS"
    #ccnchat -text $APP_PARAMS
    cd /root/NDN_GEC/robochat
    export CCNX_USER_NAME=Gettysburg
    ./chat_read.sh  Gettysburg_Address.txt | /usr/local/bin/ccnchat -text $APP_PARAMS
    ;;
"robochat_server3")
    echo "APP: robochat_server3"
    foundapp=1
    #echo "ccnchat -text $APP_PARAMS"
    #ccnchat -text $APP_PARAMS
    cd /root/NDN_GEC/robochat
    export CCNX_USER_NAME=Preamble
    ./chat_read.sh  Preamble_to_the_Constitution.txt | /usr/local/bin/ccnchat -text $APP_PARAMS
    ;;
"vlc")
    echo "APP: vlc"
    foundapp=1
    ;;
"vlc_repository")
    echo "APP: vlc_repository"
    foundapp=1
    ;;
"ccnx_repository")
    echo "APP: ccnx_repository"
    foundapp=1
    ;;
esac

if [ $foundapp -eq 0 ]
then
    echo "NO APP Name found"
fi

