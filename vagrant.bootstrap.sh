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
sed -i "s/^\s*SELINUX\s*=.*/SELINUX=permissive/" /etc/sysconfig/selinux
sed -i "s/^\s*SELINUX\s*=.*/SELINUX=permissive/" /etc/selinux/config
setenforce 0
# disable nftables rules (as this is a playground system)
systemctl stop firewalld
systemctl is-enabled --quiet firewalld.service && echo There is nothing wrong if the next lines are displayed in red
systemctl disable firewalld
# configure, enable and start Apache Webserver
if [[ ! -e "/etc/httpd/conf.d/default.servername.conf" ]]; then
    echo ServerName localhost:80 >/etc/httpd/conf.d/default.servername.conf
    chmod 644 /etc/httpd/conf.d/default.servername.conf
fi
if [[ -e "/etc/httpd/conf.d/ssl.conf" ]]; then
   BACKUP_SSL_CONF=$(mktemp --tmpdir=/etc/httpd/conf.d/ ssl.conf_BACKUP_XXXXXX)
   mv -f /etc/httpd/conf.d/ssl.conf $BACKUP_SSL_CONF
fi
systemctl enable httpd
systemctl start httpd
# create directory for trusted CA certs
if [[ ! -e "/etc/httpd/ssl.trust/" ]]; then
    mkdir -p /etc/httpd/ssl.trust/
fi
chmod 755 /etc/httpd/ssl.trust/
# create directory for CRLs
if [[ ! -e "/etc/httpd/ssl.crl/" ]]; then
    mkdir -p /etc/httpd/ssl.crl/
fi
chmod 755 /etc/httpd/ssl.crl/

# install goss (for regression tests)
curl -fsSL https://goss.rocks/install | sh

echo
echo "### vagrant.bootstrap.sh ended"
echo
