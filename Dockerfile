FROM node:alpine3.11

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache git python make openssl tar gcc

COPY yapi.tar.gz /home

RUN cd /home && tar zxvf yapi.tar.gz && mkdir /api && mv /home/yapi-1.9.2 /api/vendors

RUN cd /api/vendors && \
    npm install --production --registry https://registry.npm.taobao.org

FROM node:alpine3.11

MAINTAINER 229381366@qq.com

ENV TZ="Asia/Shanghai" HOME="/"

COPY --from=0 /api/vendors /api/vendors

COPY config.json /api/

#RUN cd /api/vendors && \
#    npm run install-server

WORKDIR /api/vendors

EXPOSE 3000

ENTRYPOINT ["node"]
