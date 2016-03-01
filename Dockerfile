FROM alpine:3.2
MAINTAINER Calvin Leung Huang <https://github.com/cleung2010>

ENV NOMAD_VERSION 0.3.0
ENV NOMAD_SHA256 530e5177cecd65d36102953099db19ecdbfa62b3acf20a0c48e20753a597f28e

RUN apk --update add curl ca-certificates

# Need to install glibc on alpine to run Consul
RUN curl -Ls https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk > /tmp/glibc-2.21-r2.apk && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
    rm -rf /tmp/glibc-2.21-r2.apk /var/cache/apk/*

# Add Nomad binary
ADD https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip /tmp/nomad.zip

# Install Nomad and create optional config folder to be used
RUN echo "${NOMAD_SHA256}  /tmp/nomad.zip" > /tmp/nomad.sha256 \
    && sha256sum -c /tmp/nomad.sha256 \
    && unzip /tmp/nomad.zip -d /usr/bin \
    && chmod +x /usr/bin/nomad \
    && rm /tmp/nomad.zip \
    && mkdir /etc/nomad.d \
    && chmod a+w /etc/nomad.d

# Expose Nomad-related ports
EXPOSE 4646 4647 4648 4648/udp

ENTRYPOINT ["/usr/bin/nomad"]
