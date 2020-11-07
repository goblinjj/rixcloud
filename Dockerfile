# sslocal
FROM alpine:3.12

ENV SERVER_HOST="1.1.1.1" \
    SERVER_PORT="10571" \
    PASSWORD="123" \
    METHOD="rc4-md5" \
    LOCAL_PORT="1080"

RUN set -xue; \
        sed -i 's#^#\##g' /etc/apk/repositories; \
        sed -i '1ihttp://mirrors.ustc.edu.cn/alpine/v3.12/main/' /etc/apk/repositories; \
        sed -i '1ihttp://mirrors.ustc.edu.cn/alpine/v3.12/community/' /etc/apk/repositories; \
        sed -i '1ihttps://mirrors.tuna.tsinghua.edu.cn/alpine/v3.12/main/' /etc/apk/repositories; \
        sed -i '1ihttps://mirrors.tuna.tsinghua.edu.cn/alpine/v3.12/community/' /etc/apk/repositories; \
        apk update && apk add \
            curl \
            py-pip \
            && \
        pip install shadowsocks && \
        rm -rf /var/cache/apk/* ~/.cache

RUN     apk add openssl
RUN     sed -i 's/cleanup/reset/g' /usr/lib/python3.8/site-packages/shadowsocks/crypto/openssl.py

EXPOSE ${LOCAL_PORT}

CMD ["sh", "-c", "sslocal -v -s ${SERVER_HOST} -p ${SERVER_PORT} -k ${PASSWORD} -m ${METHOD} -l ${LOCAL_PORT} -b 0.0.0.0"]
