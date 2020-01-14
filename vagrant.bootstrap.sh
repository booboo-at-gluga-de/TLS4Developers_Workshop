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
yum -y install httpd mod_ssl vim-enhanced net-tools nagios-plugins-http maven
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
GOSS_INSTALLER=$(mktemp /usr/local/src/goss.install.XXX)
curl -o $GOSS_INSTALLER -fsSL https://goss.rocks/install
sed -i $GOSS_INSTALLER -e "s/curl/curl -sS/"
sh $GOSS_INSTALLER
# original command from the doc is:
# curl -fsSL https://goss.rocks/install | sh
# but this messes up vagrant output by trying to display progress

# install Nagios plugin check_ssl_cert for Exercise B.5
echo Downloading check_ssl_cert
curl -o /usr/local/bin/check_ssl_cert -fsSL https://raw.githubusercontent.com/matteocorti/check_ssl_cert/master/check_ssl_cert
chmod 755 /usr/local/bin/check_ssl_cert

# do sudoers configuration
cat >/etc/sudoers.d/TLS4Developers <<EOF
# the goss checks (in run-all-tests.sh) read the domain name used for
# exercises of chapter B from this variable
# (and they need to run with root privileges to be able to read the
# certificates)
Defaults    env_keep += "DOMAIN_NAME_CHAPTER_B"
EOF

echo
echo "### vagrant.bootstrap.sh ended"
echo
