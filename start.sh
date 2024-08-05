#!/bin/bash
echo "script was started"

sudo apt install curl
docker_v=$(docker -v)
if [[ $docker_v =~ "version" ]]
then
echo "docker already installed, proceed to the next step..."
else
echo "docker not found, start installing..."
sudo curl https://get.docker.com -o install.sh && sh install.sh
systemctl enable docker.service
systemctl enable docker
usermod -aG docker $USER
echo "docker was installed"
fi

cd ~ && curl -LO https://github.com/atv1103/wireguard/archive/master.tar.gz && tar -xvf master.tar.gz && rm master.tar.gz 
cd wireguard-master


mkdir -p /app/wireguard
cp ./docker-compose.yml /app/wireguard

echo "script was ended. Well done!"