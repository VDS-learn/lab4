# Базовый образ: используем Debian как основу
FROM debian:latest

# Автор Dockerfile
LABEL maintainer="VDS"

# Обновляем систему и устанавливаем необходимые пакеты
RUN apt update && apt upgrade -y && \
    apt install -y nginx && \
    apt clean

# Удаляем содержимое директории /var/www/
RUN rm -rf /var/www/*

# Копируем файлы сайта и изображения в контейнер
COPY index.html /var/www/VDSInc/index.html
COPY img.jpg /var/www/VDSInc/img/img.jpg

# Создаем необходимые директории
RUN mkdir -p /var/www/VDSInc/img

# Устанавливаем права доступа к директории /var/www/VDSInc
RUN chmod -R 751 /var/www/VDSInc

# Создаем пользователя и группу
RUN useradd dmitry && \
    groupadd volkov && \
    usermod -aG volkov dmitry

# Присваиваем владельца и группу для /var/www/VDSInc
RUN chown -R dmitry:volkov /var/www/VDSInc

# Настраиваем Nginx: заменяем путь на /var/www/VDSInc
RUN sed -i 's#/var/www/html#/var/www/VDSInc#g' /etc/nginx/sites-enabled/default

# Меняем пользователя Nginx на нашего пользователя
RUN sed -i 's/user www-data;/user dmitry;/g' /etc/nginx/nginx.conf

# Открываем порт 80 для веб-сервера
EXPOSE 80

# Запускаем Nginx в фоновом режиме
CMD ["nginx", "-g", "daemon off;"]