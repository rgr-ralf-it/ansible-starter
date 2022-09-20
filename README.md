# Ansible starter 

## Basic usage

Phase 1: manual slaves setup
Phase 2: play ansible with make

### Phase 1: Manual Slaves Setup 

We can provide IP addresses in `inventories/slaves/static` or provide MACs addresses in `data/macs/slaves` for dynamic IP lookup.

#### Hardcode data/macs/slaves

Hardcode data in  `data/macs/slaves` with MAC addresses taken from `ifconfig -> ether` for each slave. 

For example from

```
eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.8.156  netmask 255.255.255.0  broadcast 192.168.8.255
        inet6 fdec:8914:9e28:7a00:55:3465:63aa:a092  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::43e5:d5e:703f:5bb4  prefixlen 64  scopeid 0x20<link>
        inet6 fdec:8914:9e28:7a00:781b:5619:75cd:ee65  prefixlen 64  scopeid 0x0<global>
        ether 88:88:88:88:87:88  txqueuelen 1000  (Ethernet)
        RX packets 492603  bytes 412910119 (412.9 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 396109  bytes 108760332 (108.7 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 16  memory 0xb3200000-b3220000  
```

we take `ether` value `88:88:88:88:87:88` and put it as

```d
88:88:88:88:87:88
```

In case of multiple interfaces in one slave ie. `eno0, eno1, eno2` we put MACs in same line

```d
88:88:88:88:87:88 88:88:88:88:87:89 88:88:88:88:87:90
```

In case of multiple interfaces in 2 slaves we put MACs in same line for each slave

```d
88:88:88:88:87:88 88:88:88:88:87:89 88:88:88:88:87:90
02:42:79:be:40:4b 02:42:79:be:40:4b
```

### Phase 2: play

#### make all 

It will setup, check and play cluster.

#### make setup

It will install ansible, valut and encrypt vauly.ymls

#### make check

Play dryrun for cluster

#### make cluster

Play for all groups

#### make master

Play for master group

#### make slaves

Play for slaves group
