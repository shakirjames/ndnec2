#!/usr/bin/env bash 
#
# Copyright (c) 2011 John Dehart, Shakir James, and Washington University in St. Louis.
# All rights reserved
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#    1. Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#    3. The name of the author or Washington University may not be used 
#       to endorse or promote products derived from this source code 
#       without specific prior written permission.
#    4. Conditions of any other entities that contributed to this are also
#       met. If a copyright notice is present from another entity, it must
#       be maintained in redistributions of the source code.
#
# THIS INTELLECTUAL PROPERTY (WHICH MAY INCLUDE BUT IS NOT LIMITED TO SOFTWARE,
# FIRMWARE, VHDL, etc) IS PROVIDED BY THE AUTHOR AND WASHINGTON UNIVERSITY 
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR WASHINGTON UNIVERSITY 
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS INTELLECTUAL PROPERTY, EVEN IF 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

PWD=`pwd`
echo "PWD: $PWD"
echo "Usage: $0 $@"
echo $@

################################
APP_NAME=$1
shift 1
NDN_GATEWAY_NAME=$1
shift 1
APP_PARAMS="$*"

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
cd /root
wget http://www.arl.wustl.edu/~jdd/NDN/new_restartCCNX.sh
chmod 755 new_restartCCNX.sh
foundgw=0
case "$NDN_GATEWAY_NAME" in
"PARC")
    echo "GATEWAY: PARC"
    export CCNX_USER_NAME=chat_parc
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"WASHU")
    echo "GATEWAY: WASHU"
    export CCNX_USER_NAME=chat_washu
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"CAIDA")
    echo "GATEWAY: CAIDA"
    export CCNX_USER_NAME=chat_caida
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"CSU")
    echo "GATEWAY: CSU"
    export CCNX_USER_NAME=chat_csu
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"MEMPHIS")
    echo "GATEWAY: MEMPHIS"
    export CCNX_USER_NAME=chat_memphis
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPATLA")
    echo "GATEWAY: SPPATLA"
    export CCNX_USER_NAME=chat_sppatla
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPHOUS")
    echo "GATEWAY: SPPHOUS"
    export CCNX_USER_NAME=chat_spphous
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPKANS")
    echo "GATEWAY: SPPKANS"
    export CCNX_USER_NAME=chat_sppkans
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPSALT")
    echo "GATEWAY: SPPSALT"
    export CCNX_USER_NAME=chat_sppsalt
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"SPPWASH")
    echo "GATEWAY: SPPWASH"
    export CCNX_USER_NAME=chat_sppwash
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"ARIZONA")
    echo "GATEWAY: ARIZONA"
    export CCNX_USER_NAME=chat_arizona
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"UCI")
    echo "GATEWAY: UCI"
    export CCNX_USER_NAME=chat_uci
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"UCLA")
    echo "GATEWAY: UCLA"
    export CCNX_USER_NAME=chat_ucla
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"REMAP")
    echo "GATEWAY: REMAP"
    export CCNX_USER_NAME=chat_remap
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
"UIUC")
    echo "GATEWAY: UIUC"
    export CCNX_USER_NAME=chat_uiuc
    foundgw=1
    /root/new_restartCCNX.sh "$NDN_GATEWAY_NAME" 
    ;;
esac

if [ $foundgw -eq 0 ]
then
    echo "NO NDN GATEWAY >$NDN_GATEWAY_NAME< found"
    echo "Starting ccnx without one"
    /root/new_restartCCNX.sh "NONE" 
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
    #echo "ccnchat -text $APP_PARAMS"
    #/usr/local/bin/ccnchat -text $APP_PARAMS

    echo "#!/bin/sh" > /home/ubuntu/startApp.sh
    echo ""          >> /home/ubuntu/startApp.sh
    echo "export CCNX_USER_NAME=$CCNX_USER_NAME"    >> /home/ubuntu/startApp.sh
    echo "/usr/local/bin/ccnchat -text $APP_PARAMS" >> /home/ubuntu/startApp.sh
    echo ""

    chmod 755 /home/ubuntu/startApp.sh
    chown ubuntu.ubuntu /home/ubuntu/startApp.sh

    ;;
"robochat_server1")
    echo "APP: robochat_server1"
    foundapp=1
    #echo "ccnchat -text $APP_PARAMS"
    #ccnchat -text $APP_PARAMS
    cd /root/NDN_GEC/robochat
    export CCNX_USER_NAME=Declaration
    #./chat_read.sh  Declaration_of_Independence.txt | /usr/local/bin/ccnchat -text $APP_PARAMS

    CHAT_FILE="Declaration_of_Independence.txt"
    echo "#!/bin/sh" > /home/ubuntu/startApp.sh
    echo ""          >> /home/ubuntu/startApp.sh
    echo "export CCNX_USER_NAME=$CCNX_USER_NAME"    >> /home/ubuntu/startApp.sh
    echo "/home/ubuntu/chat_read.sh $CHAT_FILE | /usr/local/bin/ccnchat -text $APP_PARAMS" >> /home/ubuntu/startApp.sh
    echo ""

    cd /root/NDN_GEC/robochat
    cp $CHAT_FILE /home/ubuntu
    cp chat_read.sh /home/ubuntu
    chmod 755 /home/ubuntu/chat_read.sh
    chmod 644 /home/ubuntu/$CHAT_FILE
    chown ubuntu.ubuntu /home/ubuntu/chat_read.sh /home/ubuntu/$CHAT_FILE

    chmod 755 /home/ubuntu/startApp.sh
    chown ubuntu.ubuntu /home/ubuntu/startApp.sh

    ;;
"robochat_server2")
    echo "APP: robochat_server2"
    foundapp=1
    #echo "ccnchat -text $APP_PARAMS"
    #ccnchat -text $APP_PARAMS
    cd /root/NDN_GEC/robochat
    export CCNX_USER_NAME=Gettysburg
    #./chat_read.sh  Gettysburg_Address.txt | /usr/local/bin/ccnchat -text $APP_PARAMS

    CHAT_FILE="Gettysburg_Address.txt"
    echo "#!/bin/sh" > /home/ubuntu/startApp.sh
    echo ""          >> /home/ubuntu/startApp.sh
    echo "export CCNX_USER_NAME=$CCNX_USER_NAME"    >> /home/ubuntu/startApp.sh
    echo "/home/ubuntu/chat_read.sh $CHAT_FILE | /usr/local/bin/ccnchat -text $APP_PARAMS" >> /home/ubuntu/startApp.sh
    echo ""

    cd /root/NDN_GEC/robochat
    cp $CHAT_FILE /home/ubuntu
    cp chat_read.sh /home/ubuntu
    chmod 755 /home/ubuntu/chat_read.sh
    chmod 644 /home/ubuntu/$CHAT_FILE
    chown ubuntu.ubuntu /home/ubuntu/chat_read.sh /home/ubuntu/$CHAT_FILE
    
    chmod 755 /home/ubuntu/startApp.sh
    chown ubuntu.ubuntu /home/ubuntu/startApp.sh

    ;;
"robochat_server3")
    echo "APP: robochat_server3"
    foundapp=1
    #echo "ccnchat -text $APP_PARAMS"
    #ccnchat -text $APP_PARAMS
    cd /root/NDN_GEC/robochat
    export CCNX_USER_NAME=Preamble
    #./chat_read.sh  Preamble_to_the_Constitution.txt | /usr/local/bin/ccnchat -text $APP_PARAMS

    CHAT_FILE="Preamble_to_the_Constitution.txt"
    echo "#!/bin/sh" > /home/ubuntu/startApp.sh
    echo ""          >> /home/ubuntu/startApp.sh
    echo "export CCNX_USER_NAME=$CCNX_USER_NAME"    >> /home/ubuntu/startApp.sh
    echo "/home/ubuntu/chat_read.sh $CHAT_FILE | /usr/local/bin/ccnchat -text $APP_PARAMS" >> /home/ubuntu/startApp.sh
    echo "" >> /home/ubuntu/startApp.sh

    cd /root/NDN_GEC/robochat
    cp $CHAT_FILE /home/ubuntu
    cp chat_read.sh /home/ubuntu
    chmod 755 /home/ubuntu/chat_read.sh
    chmod 644 /home/ubuntu/$CHAT_FILE
    chown ubuntu.ubuntu /home/ubuntu/chat_read.sh /home/ubuntu/$CHAT_FILE
    
    chmod 755 /home/ubuntu/startApp.sh
    chown ubuntu.ubuntu /home/ubuntu/startApp.sh

    ;;
"fetch")
    echo "APP: fetch"
    foundapp=1

    cp -p /root/NDN_GEC/ccnx/csrc/cmd/ccn_fetch_test /usr/local/bin

    echo "#!/bin/bash" > /home/ubuntu/startApp.sh
    echo ""          >> /home/ubuntu/startApp.sh
    echo 'if [ $# -eq 1 ] ' >> /home/ubuntu/startApp.sh
    echo "then" >> /home/ubuntu/startApp.sh
    echo "  fetchfile=\$1" >> /home/ubuntu/startApp.sh
    echo "else" >> /home/ubuntu/startApp.sh
    echo "  fetchfile=$APP_PARAMS" >> /home/ubuntu/startApp.sh
    echo "fi" >> /home/ubuntu/startApp.sh
    echo '/usr/local/bin/ccn_fetch_test -mb 24 -out /tmp/fetchfile.out $fetchfile >& /home/ubuntu/fetch.log ' >> /home/ubuntu/startApp.sh
    echo "" >> /home/ubuntu/startApp.sh

    chmod 755 /home/ubuntu/startApp.sh
    chown ubuntu.ubuntu /home/ubuntu/startApp.sh
    ;;
"vlc")
    echo "APP: vlc"
    foundapp=1

    cd /root/NDN_GEC/ccnx/apps/vlc
    wget http://www.arl.wustl.edu/~jdd/NDN/ccn.c.with_fetch .
    mv ccn.c ccn.c.ORIG
    cp ccn.c.with_fetch ccn.c
    cp -p Makefile.Linux Makefile
    make
    make install

    #vlc -I dummy --play-and-exit --no-video $APP_PARAMS

    echo "#!/bin/bash" > /home/ubuntu/startApp.sh
    echo ""          >> /home/ubuntu/startApp.sh
    echo 'if [ $# -eq 1 ] ' >> /home/ubuntu/startApp.sh
    echo "then" >> /home/ubuntu/startApp.sh
    echo '  videofile=$1' >> /home/ubuntu/startApp.sh
    echo "else" >> /home/ubuntu/startApp.sh
    echo "  videofile=$APP_PARAMS" >> /home/ubuntu/startApp.sh
    echo "fi" >> /home/ubuntu/startApp.sh
    echo "while true" >> /home/ubuntu/startApp.sh
    echo "do" >> /home/ubuntu/startApp.sh
    echo 'vlc -I dummy --play-and-exit --no-video $videofile >& /home/ubuntu/vlc.log ' >> /home/ubuntu/startApp.sh
    echo "done" >> /home/ubuntu/startApp.sh
    echo "" >> /home/ubuntu/startApp.sh

    chmod 755 /home/ubuntu/startApp.sh
    chown ubuntu.ubuntu /home/ubuntu/startApp.sh
    ;;
"ccnx_repository")
    echo "APP: ccnx_repository"
    export CCNR_LOG=/var/log/ccnr.log
    export CCNR_DEBUG=7
    export CCNR_DIRECTORY=/usr/local/NDN/REPO

    mkdir -p /usr/local/NDN/REPO
    if [ "$CCNR_LOG" = "" ]
    then
      echo "Starting ccnr with no log file"
      /usr/local/bin/ccnr  &
    else
      echo "Starting ccnr with log file: $CCNR_LOG"
      : >"$CCNR_LOG" || exit 1
      /usr/local/bin/ccnr  2> $CCNR_LOG &
    fi

    cd /root
    #mkdir VIDEOS
    cd VIDEOS
    #wget http://www.arl.wustl.edu/~jdd/NDN/videos.tgz
    #tar -zxf videos.tgz

    FILES=`ls *.mpeg *.mpg`

    # APP_PARAMS should contain prefix or prefixes for the Repository
    #   for example: ccnx:/GEC/WASHU/REPO or ccnx:/ndn/memphis.edu/netlab/GECREPO ...
    for a in $APP_PARAMS
    do
      for f in $FILES
      do
        echo "FILE: $f"
        ccnputfile $a/$f $f
      done
    done

    echo "done putting files in repositories"

    echo "#!/bin/sh" > /home/ubuntu/startApp.sh
    echo ""          >> /home/ubuntu/startApp.sh
    echo "# This file intentionally left blank. No App to run for a repository instance"          >> /home/ubuntu/startApp.sh
    chmod 755 /home/ubuntu/startApp.sh
    chown ubuntu.ubuntu /home/ubuntu/startApp.sh

    foundapp=1
    ;;
esac

if [ $foundapp -eq 0 ]
then
    echo "NO APP Name found"
fi

echo ""
echo "DONE"
