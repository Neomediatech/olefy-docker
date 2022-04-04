FROM python:3-alpine

ENV OLEFY_PYTHON_PATH=/usr/local/bin/python3 \
    OLEFY_BINDADDRESS=0.0.0.0 \
    OLEFY_LOGLVL=30 \
    OLEFY_BINDPORT=10050 \
    OLEFY_TMPDIR=/tmp \
    OLEFY_OLEVBA_PATH=/usr/local/bin/olevba \
    OLEFY_MINLENGTH=500 \
    OLEFY_DEL_TMP=1 \
    OLEFY_DEL_TMP_FAILED=1 \
    SERVICE=olefy-docker \
    OS=alpine \
    TZ=Europe/Rome

WORKDIR /app

COPY requirements.txt .

RUN apk add --no-cache --virtual .build-deps \
        cargo \
        gcc \
        libffi-dev \
        musl-dev \
        openssl-dev \
        python3-dev && \
    apk add --no-cache \
        libffi \
        libmagic \
        netcat-openbsd \
	tzdata \
	openssl && \
    pip install -r requirements.txt && \
    apk del .build-deps 

ADD https://raw.githubusercontent.com/HeinleinSupport/olefy/master/olefy.py /usr/local/bin/olefy.py

RUN adduser -S olefy && chmod +x /usr/local/bin/olefy.py && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone && \
    chown -R olefy /app /tmp /usr/local/bin/olefy.py

USER olefy

ENTRYPOINT ["/usr/local/bin/olefy.py"]

# OLEFY_LOGLVL= 10:DEBUG,20:INFO,30:WARNING,40:ERROR,50:CRITICAL

#LABEL maintainer="docker-dario@neomediatech.it" \
#      org.label-schema.version=$VERSION \
#      org.label-schema.vcs-type=Git \
#      org.label-schema.vcs-url=https://github.com/Neomediatech/$SERVICE \
#      org.label-schema.maintainer=Neomediatech

HEALTHCHECK --interval=20s --timeout=3s --start-period=10s --retries=10 CMD res=$(echo -ne "PING\n\n" | nc 127.0.0.1 $OLEFY_BINDPORT) ; if [ "x$res" != "xPONG" ]; then echo "Bad things are happening here" ; exit 1 ; else echo "At your service, sir!" ; fi
