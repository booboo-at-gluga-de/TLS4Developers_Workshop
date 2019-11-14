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
