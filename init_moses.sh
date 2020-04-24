#!/bin/bash

cp sources.list.ubuntu /etc/apt/sources.list
apt -y update
apt -y upgrade

echo "export CPLUS_INCLUDE_PATH=/root/miniconda3/include/python3.7m" >> ~/.bashrc
source ~/.bashrc

sh install_moses.sh
