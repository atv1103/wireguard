#!/bin/bash

sudo apt install curl
sudo curl https://get.docker.com -o install.sh && sh install.sh
systemctl enable docker.service
systemctl enable docker
usermod -aG docker $USER

cd ~ && curl -LO https://github.com/atv1103/wireguard/archive/master.tar.gz && tar -xvf master.tar.gz && rm master.tar.gz 
cd wireguard-master

mkdir -p /app/wireguard
cp ./docker-compose.yml /app/wireguard