#!/usr/bin/env bash 


#
# This script installs and configures CCNx applications on an EC2 host. 
# It runs when an EC2 instances starts up; it's useful for automating 
# the installation and onfiguration of your CCNx applications.
#
# Copyright 2011 Shakir James and Washington University in St. Louis.
# See LICENSE for details.
#

PWD=`pwd`
echo "PWD: $PWD"
echo "Usage: $0 $@"
echo $@

################################
APP_NAME=$1
NDN_GATEWAY_NAME=$2
APP_PARAMS="$3"

echo "APP_NAME = $APP_NAME"
echo "NDN_GATEWAY_NAME = $NDN_GATEWAY_NAME"
echo "APP_PARAMS = $APP_PARAMS"

#cd /root
#
## install EC2 AMI tools and required utilities
#wget http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip
#apt-get -y install unzip
#apt-get -y install ruby
#apt-get -y install libopenssl-ruby
#
#wget http://www.arl.wustl.edu/~jdd/NDN/NDN_GEC.tar.gz
#
#   gunzip NDN_GEC.tar.gz
#   tar -xf NDN_GEC.tar
#   export HOME=/root
   #cd /root ; /root/NDN_GEC/ccnx-0.4.2/csrc/lib/ccn_initkeystore.sh 
echo "STARTing generation of /root/.ccnx/keystore"
export HOME=/root
cd /root ; /root/NDN_GEC/ccnx/csrc/lib/ccn_initkeystore.sh 
echo "DONE with generation of /root/.ccnx/keystore"

#
##   if [ $APP_NAME = "vlc" ]
##   then
##      echo "VLC:"
#      apt-get -y update
#      apt-get -y install gcc
#      apt-get -y install openjdk-6-jre
#      apt-get -y install openjdk-6-jdk
#      apt-get -y install libssl-dev
#      apt-get -y install libexpat-dev
#      apt-get -y install libpcap-dev
#      apt-get -y install asciidoc
#      apt-get -y install vlc
#      apt-get -y install libvlc-dev
##   else
##     yum -y install make
##
##     yum -y install openssl
##     yum -y install gcc
##     rm /lib/libcrypto.so.6
##     yum -y install openssl-devel
##     yum -y install expat-devel
##     yum -y install libpcap-devel
##     yum -y install java-1.6.0-openjdk-devel
##     #yum -y install ant
##     yum -y install asciidoc
##   fi
#
#   # ANT
#   cd /root/NDN_GEC
#   gunzip apache-ant-1.8.2-bin.tar.gz
#   tar -xf apache-ant-1.8.2-bin.tar
#   mkdir /usr/local/ant /usr/local/ant/bin /usr/local/ant/lib
#   cp -p -R apache-ant-1.8.2/bin/* /usr/local/ant/bin
#   cp -p -R apache-ant-1.8.2/lib/* /usr/local/ant/lib
#   export ANT_HOME=/usr/local/ant
#   export PATH=$PATH:$ANT_HOME/bin
#   echo "PATH=$PATH"
#
#   #cd /root/NDN_GEC/ccnx-0.4.2
#   cd /root/NDN_GEC/ccnx
#   make clean
#   make all
#   make install
#   if [ $APP_NAME = "vlc" ]
#   then
#     cd /root/NDN_GEC/ccnx/apps/vlc
#     cp -p Makefile.Linux Makefile
#     make
#     make install
#   fi
#
#   cd /root/NDN_GEC/ccnx-dhcp
#   make clean
#   make 
#
#   cd /root/NDN_GEC/ccnping
#   make clean
#   make 
#
#   cd ~
#   echo "#!/bin/sh" > /root/restartCCNX.sh
#   echo "export CCND_LOG=/var/log/ccnd.log" >> /root/restartCCNX.sh
#   echo "CCNX_DEBUG=7" >> /root/restartCCNX.sh
#   #echo "sudo -E /usr/local/bin/ccndstop" >> /root/restartCCNX.sh
#   #echo "sudo -E /usr/local/bin/ccndstart" >> /root/restartCCNX.sh
#   echo "/usr/local/bin/ccndstop" >> /root/restartCCNX.sh
#   echo "/usr/local/bin/ccndstart" >> /root/restartCCNX.sh
#   if [ $APP_NAME = "ccnx_repository" ]
#   then
#     echo "export CCNR_DIRECTORY=/usr/local/CCNX_REPO" >> /root/restartCCNX.sh
#     echo "export CCNR_LOG=/var/log/ccnr.log" >> /root/restartCCNX.sh
#     echo "/usr/local/bin/ccnr 2> $CCNR_LOG" >> /root/restartCCNX.sh
#   fi
#   chmod 755 /root/restartCCNX.sh
#   /root/restartCCNX.sh 
#   #chown ec2-user ~ec2-user/restartCCNX.sh
#
#   #echo "#!/bin/sh" > chat_thru_washu.sh
#   #echo "export CCNX_USER_NAME=chat_wu" >> chat_thru_washu.sh
#   #echo "/usr/local/bin/ccndc add ccnx:/ tcp 128.252.153.193 9695" >> chat_thru_washu.sh
#   #echo "ccnchat -text ccnx:/ndn/wustl.edu/tstchat100" >> chat_thru_washu.sh
#   #chmod 755 chat_thru_washu.sh
#
#   #echo "#!/bin/sh" > chat_thru_csu.sh
#   #echo "export CCNX_USER_NAME=chat_csu" >> chat_thru_csu.sh
#   #echo "/usr/local/bin/ccndc add ccnx:/ tcp 129.82.138.48 9695" >> chat_thru_csu.sh
#   #echo "ccnchat -text ccnx:/ndn/wustl.edu/tstchat100" >> chat_thru_csu.sh
#   #chmod 755 chat_thru_csu.sh
#
#   #echo "#!/bin/sh" > home_washu.sh
#   #echo "~/NDN_GEC/ccnx-dhcp/ccndhcpnode -f ~/NDN_GEC/ccnx-dhcp/ccn_dhcp_client.conf.WASHU " >> home_washu.sh
#
foundgw=0
case "$NDN_GATEWAY_NAME" in
"PARC")
    echo "GATEWAY: PARC"
    export CCNX_USER_NAME=chat_parc
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"WASHU")
    echo "GATEWAY: WASHU"
    export CCNX_USER_NAME=chat_washu
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"CAIDA")
    echo "GATEWAY: CAIDA"
    export CCNX_USER_NAME=chat_caida
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"CSU")
    echo "GATEWAY: CSU"
    export CCNX_USER_NAME=chat_csu
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"MEMPHIS")
    echo "GATEWAY: MEMPHIS"
    export CCNX_USER_NAME=chat_memphis
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPATLA")
    echo "GATEWAY: SPPATLA"
    export CCNX_USER_NAME=chat_sppatla
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPHOUS")
    echo "GATEWAY: SPPHOUS"
    export CCNX_USER_NAME=chat_spphous
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPKANS")
    echo "GATEWAY: SPPKANS"
    export CCNX_USER_NAME=chat_sppkans
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPSALT")
    echo "GATEWAY: SPPSALT"
    export CCNX_USER_NAME=chat_sppsalt
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPWASH")
    echo "GATEWAY: SPPWASH"
    export CCNX_USER_NAME=chat_sppwash
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"ARIZONA")
    echo "GATEWAY: ARIZONA"
    export CCNX_USER_NAME=chat_arizona
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"UCI")
    echo "GATEWAY: UCI"
    export CCNX_USER_NAME=chat_uci
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"UCLA")
    echo "GATEWAY: UCLA"
    export CCNX_USER_NAME=chat_ucla
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"UIUC")
    echo "GATEWAY: UIUC"
    export CCNX_USER_NAME=chat_uiuc
    foundgw=1
    /root/restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
esac

if [ $foundgw -eq 0 ]
then
    echo "NO NDN GATEWAY >$NDN_GATEWAY_NAME< found"
    echo "Starting ccnx without one"
    /root/restartCCNX.sh "NONE" 
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
    vlc -I dummy --play-and-exit --no-video $APP_PARAMS
    ;;
"ccnx_repository")
    echo "APP: ccnx_repository"
    export CCNR_LOG=/var/log/ccnr.log
    export CCNR_DEBUG=7
    export CCNR_DIRECTORY=/usr/local/NDN/REPO

    mkdir -p /usr/local/NDN/REPO
    if [ "$CCNR_LOG" = "" ]
    then
      /usr/local/bin/ccnr  &
    else
      : >"$CCNR_LOG" || exit 1
      /usr/local/bin/ccnr  2> $CCNR_LOG &
    fi

    wget http://www.arl.wustl.edu/~jdd/NDN/videos.tgz
    tar -zxf videos.tgz

    #FILES=`ls *.mpeg`

    #for f in $FILES
    #do
    #  echo "FILE: $f"
    #  #ccnputfile ccnx:/REPO_CSU_UDP_01/$f $f
    #  #ccnputfile ccnx:/REPO_CSU_TCP_01/$f $f
    #done

    foundapp=1
    ;;
esac

if [ $foundapp -eq 0 ]
then
    echo "NO APP Name found"
fi

