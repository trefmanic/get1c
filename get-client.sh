#!/bin/bash

# Прототип
USERNAME_1C="$1"
PASSWORD_1C="$2"
VERSION_1C="$3"
PLATFORM_PATH=$(echo $VERSION_1C | sed 's/\./_/g')

# Получение уникального идентификатора сеанса
PAYLOAD=$(wget -qO- --keep-session-cookies --save-cookies cookies1cwget 'https://releases.1c.ru'\
        |grep -oP '(?<=input type="hidden" name="execution" value=")[^"]+(?=")')
# Формирование URL для входа
LOGIN_URL='username='$USERNAME_1C'&password='$PASSWORD_1C'&execution='$PAYLOAD'&_eventId=submit'
# Получение куков
wget -qO- --keep-session-cookies --save-cookies cookies1cwget --post-data "$LOGIN_URL" 'https://login.1c.ru/login' > /dev/null

# Формирование ссылки на нужную версию платформы
# TODO: Реализовать выбор типа дистрибутива
# TODO: Формат URL до какой-то версии отличался, сделать проверку
PLATFORM_URL='https://releases.1c.ru/version_file?nick=Platform83&ver='$VERSION_1C'&path=Platform\'$PLATFORM_PATH'\client_'$PLATFORM_PATH'.deb64.tar.gz'

# Получение прямой ссылки
DOWNLOAD_URL=$(wget -qO- --load-cookies cookies1cwget "$PLATFORM_URL" | grep -oP '(?<=a href=")[^"]+(?=">Скачать дистрибутив<)')

# Загрузка дистрибутива
wget -O deb64_$PLATFORM_PATH.tar.gz --load-cookies cookies1cwget "$DOWNLOAD_URL"

# TODO: mktemp
rm cookies1cwget

exit 0
