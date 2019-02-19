FROM debian:buster

ARG S6_VERSION=1.21.8.0

RUN set -ex ;\
    apt-get update ;\
    apt-get -y dist-upgrade ;\
    apt-get install -y \
        samba \
        samba-vfs-modules \
        curl ;\
    adduser --disabled-password --gecos 'TimeMachine' timemachine ;\
    curl -ksSL \
      https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz | \
      tar -xzf - -C / ;\
    rm -rf /var/lib/apt/lists/*
            


COPY etc /etc
COPY smb.conf /

EXPOSE 137/UDP 138/UDP 139/TCP 445/TCP
VOLUME ["/time-capsule", "/etc/samba"]

ENV SMBPASSWD=tmpass

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="SMB TimeMachine" \
      org.label-schema.description="Builds Samba for use as a time capsule for time machine.  Supports the various vfs_fruit attributes to allow compatibility with newer versions of OS X." \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/mumblepins-docker/smb-timemachine" \
      org.label-schema.schema-version="1.0"
ENTRYPOINT ["/init"]

