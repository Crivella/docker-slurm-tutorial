# Trial slurm installation in docker

This is a repo for creating a mock [slurm](https://slurm.schedmd.com/documentation.html) installation inside a group of docker containers.
The idea is to launch the containers as an uninitialized machine and than deploy slurm on them using ansible.
After that you can go inside the containers and play with all the configurations

## Usage

Run the following command to bring up the docker containers (`--remove-orphans` is used to remove services that are no longer recognized after modifying the compose file):

    docker compose up --build -d --remove-orphans

In order to start from the beginning (e.g. for a new example) you can remove the created containers by running:

    docker compose rm -fs

If not already available, [install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

Go inside the ansible directory and run the ansible script to setup slurm in the docker cluster:

    ansible-playbook slurm.yml -i test_hosts.yml

Now you should be able to either ssh into your control node as root with password `root`:

    ssh root@172.19.0.2

Or spawn a shell inside of it (change container name id needed):

    docker exec -it docker-slurm-tutorial-control /bin/bash

## Exampled

- [Run a simple job and modify a QoS](example1/README.md)
- [Add new nodes to an existing partition](example2/README.md)
