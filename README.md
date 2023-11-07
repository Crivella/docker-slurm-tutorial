# Trial slurm installation in docker

This is a repo for creating a mock [slurm](https://slurm.schedmd.com/documentation.html) installation inside a group of docker containers.
The idea is to launch the containers as an uninitialized machine and than deploy slurm on them using ansible.
After that you can go inside the containers and play with all the configurations

# Usage

Run the following command to bring up the docker containers:

    docker compose up --build -d

If not already available, [install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

Go inside the ansible directory and run the ansible script to setup slurm in the docker cluster:

    ansible-playbook slurm.yml -i test_hosts.yml

Now you should be able to either ssh into your control node as root with password `root`:

    ssh root@172.19.0.2

Or spawn a shell inside of it (change container name id needed):

    docker exec -it docker-slurm-tutorial-control /bin/bash

## Example 1

### hello.sh
Run a simple job:

    cd /scratch
    sbatch hello.sh

This will run the hello world script which will print the line `Hello, world!` once and the results of the `id` and `hostname` command for every task required for every node.
For now we are only requesting `1 node` as it is the maximum allowed by the QoS created via ansible and `1 task`.
We should hence see the following inside the `hello.out` file:

    Hello, world!
    uid=0(root) gid=0(root) groups=0(root)
    node1

### Increase number of tasks

We can try to increase the number of tasks required by setting `--ntasks-per-node=2` in the `hello.sh` file and submit it again with `sbatch`
We should now obtain the following in `hello.out`:

    Hello, world!
    uid=0(root) gid=0(root) groups=0(root)
    uid=0(root) gid=0(root) groups=0(root)
    node1
    node1

**NOTE**: The result for this simple script will be the same as every process is printing the same thing. In a more complex job the ordering might vary depending on which process finishes/prints first.

### Modify the QoS to allow using more nodes together

In order to visualize the currently created QoS, you can run the command (use `-p` or `-P` for parsable format)

    sacctmgr show qos -P

Note that now `MaxTRESPU` is set to `node=1` which limits the maximum number of nodes per user to 1.
We can modify this limit and set it to 2 by running the command (press `y` for confirmation or pass `-i` after `sacctmgr`):

    sacctmgr modify qos normal set MaxTRESPerUser=node=2

You can now run `sacctmgr show qos -P` again to see that the QoS has been modified.
Let's now edit the `hello.sh` script by modifying the number of nodes requested to 2 (`--nodes=2`) and run it (`sbatch hello.sh`)

    Hello, world!
    uid=0(root) gid=0(root) groups=0(root)
    uid=0(root) gid=0(root) groups=0(root)
    uid=0(root) gid=0(root) groups=0(root)
    uid=0(root) gid=0(root) groups=0(root)
    node1
    node2
    node1
    node2

Now we get output printed both by `node1` and `node2` (order of the lines might vary).
