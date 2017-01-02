#!/bin/sh

if ! [ `which ansible` ]; then
    yum install -y epel-release
    yum install -y ansible
fi

/bin/ansible-playbook -i /vagrant/provisioning/hosts /vagrant/provisioning/site.yml
