#!/bin/bash

ANSIBLE_NOCOWS=1 ansible-playbook main.yml -i inventories/production $@

    
