## Инструкция для запуска
1. Создаем bash файл командой `nano FILENAME.sh` и копируем в него содержимое файла **start.sh** 
2. Запускаем FILENAME.sh командой `bash FILENAME.sh`

*3. При необходимости вносим изменения в конфигурацию docker-compose файла `cd /app/wireguard && nano docker-compose.yml`*

4. Запускаем Docker контейнер командой `cd /app/wireguard && docker compose up -d`

Готово, конфиги наших клиентов хранятся в директории **/app/wireguard/config/**, можем скопировать файл конфигурации клиента **peerНОМЕР.conf** с сервера с помощью WinSCP или другим удобным для вас способом или вывести QR код прямо в терминале командой `docker exec -it wireguard /app/show-peer НОМЕР_ИЛИ ИМЯ`

Официальный сайт для скачивания клиента для Windows, macOS, Android, IOS, Linux  **https://www.wireguard.com/install/**

## Полезные команды
Показать QR код клиента в терминале:
```
docker exec -it wireguard /app/show-peer НОМЕР_ИЛИ ИМЯ
```

Просмотр логов контейнера для отладки проблем:
```
docker logs -f wireguard
```

Подключиться в сам контейнер:
```
docker exec -it wireguard /bin/bash
```

## Описание работы bash 
1. Для начала установим Docker с помощью официального скрипта:
```
sudo apt install curl
sudo curl https://get.docker.com -o install.sh && sh install.sh
```
*Добавляем автозапуск Docker*
```
systemctl enable docker.service
systemctl enable docker
```
*Добавляем текущего пользователя в группу Docker (выборочно):*

(или добавляем не root пользователя в группу docker командой `usermod -aG docker USERNAME`)
```
usermod -aG docker $USER
```

2. Скачиваем репозиторий
```
cd ~ && curl -LO https://github.com/atv1103/wireguard/archive/master.tar.gz && tar -xvf master.tar.gz && rm master.tar.gz 
cd wireguard-master
```

3. Далее создадим нужные нам директории и наш docker-compose.yml:
```
mkdir -p /app/wireguard
cp ./docker-compose.yml /app/wireguard
```

## Описание docker-compose.yml файла
**PUID=1000** — ID пользователя запускающего наш контейнер (смотрим командой `id -u` от нашего пользователя)

**PGID=1000** — ID группы от которой запускаем контейнер (смотрим командой `id -u` от нашего пользователя)

**TZ=Europe/London** — указываем часовой пояс (например Europe/London)

**SERVERURL=auto** — вписываем свой домен для удобства или оставляем auto

**SERVERPORT=51820** — порт wireguard

**PEERS=10** — количество конфигов которые будут созданы, можно вписать именами (например tel, homepc, denis и т.д.)

**PEERDNS=auto** — можем вписать известный вам DNS (8.8.8.8, 1.1.1.1 и т.д.) или оставить значение auto

**INTERNAL_SUBNET=10.13.13.0** — внутренняя виртуальная сеть

**ALLOWEDIPS=0.0.0.0/0** — диапазоны ip к которым узлы смогут подключаться с помощью VPN

**./config:/config** — место для хранения конфигов нашего контейнера

## Как обновить Wireguard в Docker
1. Переходим в нашу директорию с Wireguard:
```
cd /app/wireguard
```

2. Скачиваем новый образ, пересобираем контейнер и чистим от старых образов:
```
docker compose pull wireguard
docker compose up -d wireguard
docker image prune
```

## Как удалить Wireguard
1. Остановим наш контейнер с Wireguard:
```
docker stop wireguard
```

2. Удалим контейнер:
```
docker rm wireguard
```

3. Удалим образ Wireguard:
```
docker rmi ghcr.io/linuxserver/wireguard
```

4. Удалим директорию с конфигурационными файлами Wireguard:
```
rm -rf /app/wireguard
```