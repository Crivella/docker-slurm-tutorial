FROM ubuntu:22.04

#https://stackoverflow.com/questions/66205286/enable-systemctl-in-docker-container

RUN echo 'root:root' | chpasswd
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

RUN apt update
RUN apt install -y \
    systemd \
    systemd-sysv \
    dbus dbus-user-session
RUN apt install -y wget gnupg2
RUN apt install -y --no-install-recommends \
    gettext-base \
    openssh-server \
    ca-certificates
    # && rm -rf /var/lib/apt/lists/*

# for ansible
RUN apt install -y curl python3-apt
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3
# Utils for debugging inside container
RUN apt install -y vim less bash-completion iproute2 iputils-ping net-tools

RUN printf "systemctl start systemd-logind" >> /etc/profile
RUN sed -i 's/#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

VOLUME [ "/sys/fs/cgroup" ]

RUN systemctl enable ssh

# Make every container able to SSH into another one
RUN mkdir -p /root/.ssh
RUN ssh-keygen -q -t rsa -f /root/.ssh/id_rsa -N ''
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

RUN apt install -y attr

EXPOSE 22

CMD ["/sbin/init", "2>&1"]
