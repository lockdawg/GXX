#!/bin/bash

TMP_FOLDER=$(mktemp -d)
COIN_DAEMON='/usr/local/bin/GravityCoind'
COIN_CLI='/usr/local/bin/GravityCoin-cli'
COIN_REPO='https://github.com/GravityCoinOfficial/GravityCoin/releases/download/4.0.7.1/linux-x64.tar.gz'
COIN_NAME='GXX'
COIN_BS='hhttps://github.com/GravityCoinOfficial/GravityCoin/releases/download/Chainfiles/chainfiles.zip'

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function update_node() {
  echo -e "Preparing to download ${YELLOW}$COIN_NAME${NC}"
  mkdir gxx
  cd gxx
  wget -q $COIN_REPO
  compile_error
  COIN_ZIP=$(echo $COIN_REPO | awk -F'/' '{print $NF}')
  tar xvf linux-x64.tar.gz
  compile_error
  cp GravityCoin-cli /usr/local/bin
  cp GravityCoind /usr/local/bin
  compile_error
  strip $COIN_DAEMON $COIN_CLI
  cd - >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
  chmod +x /usr/local/bin/GravityCoind
  chmod +x /usr/local/bin/GravityCoin-cli
  clear
}

function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}

function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi
}

function prepare_system() {
echo -e "Updating the system and the ${GREEN}$COIN_NAME${NC} masternode."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev unzip libgmp3-dev libzmq3-dev ufw pkg-config libevent-dev libdb5.3++>/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev libzmq3-dev ufw fail2ban pkg-config libevent-dev"
 exit 1
fi
systemctl stop $COIN_NAME.service
sleep 3
pkill -9 wagerrd
clear
}

function import_bootstrap() {
  cd $CONFIGFOLDER
  wget -q $COIN_BS
  compile_error
  COIN_ZIP=$(echo $COIN_BS | awk -F'/' '{print $NF}')
  unzip chainfiles.zip
  compile_error
  cp -r ~/.GravityCoin/blocks
  cp -r ~/.GravityCoin/chainstate
  cp -r ~/.GravityCoin/peers.dat
  rm $COIN_ZIP
  rm -r chainfiles.zip
}

function important_information() {
 systemctl start $COIN_NAME.service
 echo
 echo -e "================================================================================================================================"
 echo -e "$COIN_NAME Masternode is updated and running again!"
 echo -e "Start: ${RED}systemctl start $COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $COIN_NAME.service${NC}"
 echo -e "Please check ${RED}$COIN_NAME${NC} is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
}

##### Main #####
clear

checks
prepare_system
update_node
import_bootstrap
important_information
