#!/usr/bin/bash


if ! (ansible --version); then
	sudo apt-add-repository ppa:ansible/ansible -y
	sudo apt-get update
	sudo apt install ansible -y
fi
