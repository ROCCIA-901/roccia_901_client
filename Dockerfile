FROM nginx

RUN mkdir /app
WORKDIR /app

RUN mkdir ./build
ADD ./build/web ./build

RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d

RUN mkdir /var/www
RUN mkdir /var/www/certbot

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]