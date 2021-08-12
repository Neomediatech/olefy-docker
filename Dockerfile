FROM alpine

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

COPY --chown=olefy:olefy profile /home/olefy/.profile
COPY olefy.conf /etc

RUN chown -R olefy:olefy /app /tmp

USER olefy

CMD ["python3", "-u", "/app/olefy.py"]
