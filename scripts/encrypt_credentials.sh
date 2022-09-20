#!/usr/bin/bash

for g in {master,slaves}; do
	rm group_vars/$g/vault.yml || true
	cp data/credentials/$g/vault.yml group_vars/$g/vault.yml || true
	ansible-vault encrypt group_vars/$g/vault.yml
done