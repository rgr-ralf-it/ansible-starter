#!/usr/bin/env python3
import os
import re
import json
import time
import subprocess
from pathlib import Path

def main(serversMacs: list, dirName: str):
    user = find_current_user()
    ipDict = {}
    for serverMacs in serversMacs:
        serverMacs = serverMacs.split()
        ip, mac = find_by_mac(serverMacs)
        ipDict[ip] = mac
    inventory = build_inventory(user, ipDict, dirName)
    inventoryJson = json.dumps(inventory, sort_keys=True, indent=2)
    print(inventoryJson)

def find_current_user():
    return os.environ['USER']

def find_by_mac(serverMacs):
    
    output = subprocess.check_output(['ip', 'neigh'],timeout=3).decode('utf-8')
    lines = output.strip().splitlines()
    for mac in serverMacs: 
        matches = list(filter(lambda x: mac in x, lines))
        if matches:
            for line in matches:
                ips = re.findall(r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b", line)
                for ip in ips:
                    return ip, mac
    else:
        # on failure, try again
        time.sleep(1)
        return find_by_mac(serverMacs)


def build_inventory(user, ipDict, dirName):

    rval = {
        dirName: {
            'hosts': list(ipDict.keys()),
            'vars': {
                'macs': list(ipDict.values())
            },
        },
        '_meta': {'hostvars': {}},
    }

    rval['_meta']['hostvars'][dirName] = {'ansible_ssh_user': user}

    return rval

if __name__ == '__main__':
    # This script will block until hosts from data/macs/<dirName> is online
    dirName = os.path.basename(Path(__file__).parent)
    macsFilePath = f'data/macs/{dirName}'
    if os.path.exists(macsFilePath):
        serversMacs = open(macsFilePath).read().splitlines()
        main(serversMacs, dirName)
