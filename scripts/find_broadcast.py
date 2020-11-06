#!/usr/bin/env python3
import os
import re
import json
import time
import subprocess
from pathlib import Path

def get_ip():
    dummyIp = '1.0.0.0'
    output = subprocess.check_output(['ip', 'route', 'get', dummyIp],timeout=3).decode('utf-8')
    lines = output.strip()
    pattern = rf'(?!{dummyIp} via)' + r'(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b){1}'
    ip = re.search(pattern, lines).group(0)
    return ip

def calc_broadcast(ip):
    a,b,c,_ = ip.split('.') 
    broadcast = '.'.join((a,b,c,'255'))
    return broadcast

def main():
    ip = get_ip()
    broadcast = calc_broadcast(ip)
    print(broadcast)


if __name__ == '__main__':
    main()
