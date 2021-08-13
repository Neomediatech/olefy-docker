FROM alpine

ENV OLEFY_BINDADDRESS= \
    OLEFY_BINDPORT=10050 \
    OLEFY_TMPDIR=/tmp \
    OLEFY_PYTHON_PATH=/usr/bin/python3 \
    OLEFY_OLEVBA_PATH=/usr/bin/olevba3 \
    OLEFY_LOGLVL=20 \
    OLEFY_MINLENGTH=500 \
    OLEFY_DEL_TMP=1 \
    OLEFY_DEL_TMP_FAILED=1 \
    SERVICE=olefy-docker \
    OS=alpine \
    TZ=Europe/Rome

# OLEFY_LOGLVL= 10:DEBUG,20:INFO,30:WARNING,40:ERROR,50:CRITICAL

LABEL maintainer="docker-dario@neomediatech.it" \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/$SERVICE \
      org.label-schema.maintainer=Neomediatech

WORKDIR /app

RUN addgroup -S olefy \
  && adduser -S olefy -G olefy -g "Olefy User" \
  && apk add --virtual .build-deps gcc musl-dev python3-dev libffi-dev openssl-dev cargo \
  && apk add --update --no-cache python3 py3-pip openssl tzdata libmagic \
  && pip3 install --upgrade pip \
  && pip3 install --upgrade asyncio python-magic \
  && pip3 install --upgrade https://github.com/HeinleinSupport/oletools/archive/master.zip \
  && apk del .build-deps

ADD https://raw.githubusercontent.com/HeinleinSupport/olefy/master/olefy.py /app/

RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone

RUN chown -R olefy:olefy /app /tmp

USER olefy

CMD ["python3", "-u", "/app/olefy.py"]

HEALTHCHECK --interval=20s --timeout=3s --start-period=10s --retries=10 CMD res=$(echo -ne "PING\n\n" | nc 127.0.0.1 $OLEFY_BINDPORT) ; if [ "x$res" != "xPONG" ]; then echo "Bad things are happening here" ; exit 1 ; else echo "At your service, sir!" ; fi
