FROM ubuntu:22.04

#https://stackoverflow.com/questions/66205286/enable-systemctl-in-docker-container

RUN echo 'root:root' | chpasswd
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

RUN apt update
# Enable systemd
RUN apt install -y \
    systemd \
    systemd-sysv \
    dbus dbus-user-session
# Install some basic utilities
RUN apt install -y wget gnupg2
RUN apt install -y --no-install-recommends \
    gettext-base \
    openssh-server \
    ca-certificates
    # && rm -rf /var/lib/apt/lists/*

# for ansible
# Install python3 and pip
RUN apt install -y curl python3-apt python3-dev
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3
# Utils for debugging inside container
RUN apt install -y vim less bash-completion iproute2 iputils-ping net-tools netcat

RUN printf "systemctl start systemd-logind" >> /etc/profile
RUN sed -i 's/#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

VOLUME [ "/sys/fs/cgroup" ]

RUN systemctl enable ssh

# Make every container able to SSH into another one
RUN mkdir -p /root/.ssh
RUN ssh-keygen -q -t rsa -f /root/.ssh/id_rsa -N ''
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

EXPOSE 22

RUN DEBIAN_FRONTEND=noninteractive apt install -y slurm-wlm slurm-wlm-basic-plugins slurm-wlm-basic-plugins-dev munge sendmail mailutils chrony libpmi2-0

CMD ["/sbin/init", "2>&1"]
