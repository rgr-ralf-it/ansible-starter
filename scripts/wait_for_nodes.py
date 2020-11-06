#!/usr/bin/env python3
import os
import re
import json
import time
from typing import Iterator
import configparser
import subprocess

import toml
import tqdm
import subprocess
from pathlib import Path

# FIXME:
from ansible.inventory.manager import InventoryManager
from ansible.parsing.dataloader import DataLoader
from ansible.vars.manager import VariableManager
import socket

"""
Use static ip for nodes
ping them until they respond

================================================================
Notes:

arp -a is cached

Phase 1: get used IP and range

ip route get 1
1.0.0.0 via 192.168.8.1 dev eno1 src 192.168.8.156 uid 1001 
    cache 

Phase 2: scan for neighbors without cache
nmap -p 22 192.168.8.0/24 -oG -

Phase 3:
"""


def main(serversIP: list):
    serversIP: dict = {n: str(ip) for n, ip in enumerate(serversIP)}
    outerPbar = tqdm.tqdm(total=len(serversIP), position=0, ascii=True)
    innerPbar = tqdm.tqdm(total=1000, position=1, ascii=True)
    outerPbar.set_description(desc=f"[INFO] Wait for [{len(serversIP):*>4}] SERVERS")

    while serversIP:
        idx, ip = serversIP.popitem()
        innerPbar.set_description(desc=f"[INFO] Try SERVER no [{idx:*>4}] with IP [{ip}]")
        innerPbar.update(1)
        if is_ip_open_on_port(ip, '22'):
            outerPbar.update(1)
            continue
        else:
            time.sleep(1)
            serversIP[idx] = ip


def is_ip_open_on_port(ip, port) -> bool:
    try:
        socket.create_connection((ip, int(port)), timeout=1)
        return True
    except socket.timeout:
        return False
    except OSError: # no route to host
        return False


if __name__ == '__main__':
    nodesStaticInventory = f'inventories/slaves/static'
    if os.path.exists(nodesStaticInventory):
        inventory = InventoryManager(loader=DataLoader(), sources=nodesStaticInventory)
        nodesIP = inventory.get_hosts()
        main(nodesIP)
    else:
        raise ValueError(f"Static and dynamic inventory files do not exist for slaves.")
