FROM alpine:3.16

ARG PG_VERSION=1.17.0

RUN \
  apk --update add autoconf autoconf-doc automake c-ares c-ares-dev curl gcc libc-dev libevent libevent-dev libtool make openssl-dev pkgconfig && \
  curl -o  /tmp/pgbouncer-${PG_VERSION}.tar.gz -L https://pgbouncer.github.io/downloads/files/$PG_VERSION/pgbouncer-${PG_VERSION}.tar.gz && \
  cd /tmp && \
  tar xvfz /tmp/pgbouncer-${PG_VERSION}.tar.gz && \
  cd pgbouncer-${PG_VERSION} && \
  ./configure --prefix=/usr && \
  make && \
  cp pgbouncer /usr/bin && \
  mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && \
  cp etc/pgbouncer.ini /etc/pgbouncer && \
  cp etc/userlist.txt /etc/pgbouncer && \
  adduser -D -S pgbouncer && \
  chown pgbouncer /var/run/pgbouncer && \
  cd /tmp && \
  rm -rf /tmp/pgbouncer*  && \
  sed -i 's/logfile = \/var\/log\/pgbouncer\/pgbouncer.log/; logfile = \/var\/log\/pgbouncer\/pgbouncer.log/' /etc/pgbouncer/pgbouncer.ini && \
  apk del --purge autoconf autoconf-doc automake c-ares-dev curl gcc libc-dev libevent-dev libtool make openssl-dev pkgconfig
  
USER pgbouncer
VOLUME /etc/pgbouncer
EXPOSE 6432
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]