# Add new nodes to an existing partition

Starting from an already setup cluster with 2 nodes (see [Usage](../README.md#usage))

Replace the following files with the ones found in this directory (either store the old ones or use `git reset --hard` to undo all changes to the repo):

- compose.yml
- ansible/test_hosts.yml
- ansible/vars/test_slurm.yml

## What has changed

In `compose.yml` you can see that the new nodes, with dedicated IPs have been added, plus the `extra_hosts` passed to every node now includes also the new nodes and IPs.

In `test_hosts.yml` we are adding the new nodes with their respective IPs

In `test_slurm.yml` we have modified

    slurm_partitions:
    - name: jobs
        nodes: 
        - "node[1-4]"
        default: yes
        max_time: "INFINITE"
        state: present
        priority_tier: 5

to now include the new nodes to the partition.



## Create and add nodes

- Run `docker compose up -d` again to setup the new nodes
- Run the ansible script again to setup the new nodes and add them to the configuration `cd ansible`, `ansible-playbook slurm.yml -i test_hosts.yml`

After running the ansible script, you can also check what has changed in the `/etc/slurm/slurm.conf` file, which will now include the new nodes in the `NodeName=...` line specifying the node specs.
The `PartitionName=...` will also now use `node[1-4]` indicating that node1 through node4 belong to the partition

## Modify the QoS

Modify again the `normal` qos (see [example1](../example1/README.md)) in order to allow using 4 nodes at the same time and the `hello.sh` script to use 4 nodes (`--nodes=4`) and 1 task per node (`--ntasks-per-node=1`):

    Hello, world!
    uid=0(root) gid=0(root) groups=0(root)
    uid=0(root) gid=0(root) groups=0(root)
    uid=0(root) gid=0(root) groups=0(root)
    uid=0(root) gid=0(root) groups=0(root)
    node1
    node2
    node3
    node4

Where we can see we are now requesting 1 task per node per 4 nodes (again the ordering is not fixed and will depend on which nodes prints the line first).
