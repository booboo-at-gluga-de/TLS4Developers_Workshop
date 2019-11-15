#!/bin/bash

echo '::: ###################################################################'
echo '::: solving exercise A.1'
echo '::: ###################################################################'

echo '::: generating key'
openssl genrsa -out /home/vagrant/example.com.key 2048

echo '::: generating CSR'
openssl req -new -key /home/vagrant/example.com.key -out /home/vagrant/example.com.csr -subj "/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=example.com/emailAddress=certificates@example.com"

echo '::: generating certificate'
openssl x509 -req -days 365 -in /home/vagrant/example.com.csr -signkey /home/vagrant/example.com.key -out /home/vagrant/example.com.crt

echo '::: Apache config exercise-A1.conf'
sudo cp /vagrant/exercises/A1/apache_conf.d/exercise-A1.conf /etc/httpd/conf.d/

echo '::: restarting Apache'
sudo systemctl restart httpd

echo '::: ###################################################################'
echo '::: solving exercise A.2'
echo '::: ###################################################################'

echo '::: generating key'
openssl genrsa -out /home/vagrant/localhost.key 2048

echo '::: generating CSR'
openssl req -new -key /home/vagrant/localhost.key -out /home/vagrant/localhost.csr -subj "/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=localhost/emailAddress=certificates@example.com"

echo '::: generating certificate'
openssl x509 -req -days 365 -in /home/vagrant/localhost.csr -signkey /home/vagrant/localhost.key -out /home/vagrant/localhost.crt

echo '::: Apache config exercise-A2.conf'
sudo cp /vagrant/exercises/A2/apache_conf.d/exercise-A2.conf /etc/httpd/conf.d/

echo '::: restarting Apache'
sudo systemctl restart httpd

echo '::: ###################################################################'
echo '::: solving exercise A.3'
echo '::: ###################################################################'

echo '::: checking for previous created CA and removing it'
[[ -d /home/vagrant/ca ]] && rm -Rf /home/vagrant/ca

echo '::: preparing config for the CA'
/vagrant/exercises/A3/prepare_CA.sh /home/vagrant

echo '::: generating CA key'
openssl genrsa -out /home/vagrant/ca/private/cacert.key 4096

echo '::: generating CA certificate'
openssl req -config /home/vagrant/ca/ca.cnf -new -x509 -days 3650 -key /home/vagrant/ca/private/cacert.key -out /home/vagrant/ca/cacert.pem -subj "/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=Raffzahn CA/emailAddress=certificates@example.com"

echo '::: generating server key'
openssl genrsa -out /home/vagrant/server.key 2048

echo '::: generating CSR'
openssl req -new -key /home/vagrant/server.key -out /home/vagrant/server.csr -subj "/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=localhost/emailAddress=certificates@example.com"

echo '::: signing with CA certificate (creating server certificate)'
openssl ca -batch -config /home/vagrant/ca/ca.cnf -extensions server_cert -days 365 -in /home/vagrant/server.csr -out /home/vagrant/server.crt

echo '::: Apache config exercise-A3.conf'
sudo cp /vagrant/exercises/A3/apache_conf.d/exercise-A3.conf /etc/httpd/conf.d/

echo '::: restarting Apache'
sudo systemctl restart httpd

echo '::: ###################################################################'
echo '::: solving exercise A.4'
echo '::: ###################################################################'

echo '::: generating client key'
openssl genrsa -out /home/vagrant/client.key 2048

echo '::: generating CSR'
openssl req -new -key /home/vagrant/client.key -out /home/vagrant/client.csr -subj "/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=User Hans Wurst/emailAddress=hans.wurst@example.com"

echo '::: signing with CA certificate (creating client certificate)'
openssl ca -batch -config /home/vagrant/ca/ca.cnf -extensions client_cert -days 365 -in /home/vagrant/client.csr -out /home/vagrant/client.crt

echo '::: Apache config exercise-A4.conf'
sudo cp /vagrant/exercises/A4/apache_conf.d/exercise-A4.conf /etc/httpd/conf.d/

echo '::: restarting Apache'
sudo systemctl restart httpd
