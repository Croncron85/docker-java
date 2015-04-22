FROM alpine:3.1
MAINTAINER Vladimir Krivosheev <develar@gmail.com>

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 45
ENV JAVA_VERSION_BUILD 14
ENV JAVA_PACKAGE server-jre

RUN apk add --update curl ca-certificates && \
 cd /tmp && \
 curl -o glibc-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
 apk add --allow-untrusted glibc-2.21-r2.apk && \
 curl -o glibc-bin-2.21-r2.apk "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" && \
 apk add --allow-untrusted glibc-bin-2.21-r2.apk && \
 /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib && \
 curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | gunzip -c - | tar -xf - && \
  apk del curl ca-certificates && \
  mv jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/jre /jre && \
  rm -rf /tmp/* /var/cache/apk/*

ENV JAVA_HOME /jre
ENV PATH ${PATH}:${JAVA_HOME}/bin

ENTRYPOINT ["java", "-server", "-Djava.security.egd=file:/dev/urandom"]