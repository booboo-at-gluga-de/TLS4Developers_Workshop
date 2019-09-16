#!/bin/bash

# 2019-09-16 Bernd Strößenreuther
# this is being executed on the Vagrant VM at "vagrant up"

echo
echo "TLS4Developers Workshop"
echo "======================="
echo
echo "### Adding some packages and configurations needed for the exercises"
echo

# needed packages
yum -y install httpd mod_ssl vim-enhanced net-tools
# switch SELinux to permissive mode (as this is a playground system)
setenforce 0
# enable and start Apache Webserver
systemctl enable httpd
systemctl start httpd

echo
echo "### vagrant.bootstrap.sh ended"
echo
