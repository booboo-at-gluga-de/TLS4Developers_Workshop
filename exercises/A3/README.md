# Exercise A.3: A Certificate Authority (CA)

## Objective

In the previous exercises you found out that selfsigned certificates are hard to use. The certificate of every server needs to be in the truststore of every client. If you have M servers and N clients you would have to distribute M * N entries in truststores. And be aware of certificates have a limited lifetime - you will have to renew all of them from time to time.

So in the real world there are Certificate Authorities (CAs) approving and signing certificates of others. You only need to trust these CA certificates.

In this exercise you will create your own CA certificate and sign your server's certificate with this. Besides this, the setup here is very similar to exercise A.2. Well, to be honest, a CA certificate created by yourself does not help too much, because you still have to put this one into all truststores yourself. For demo purposes you will do it anyway.

One advantage compared to selfsigned certificates stays: You need to distribute only N entries in truststores (which is already way better than M * N).

## Hint

In this exercise some commands reference files by complete path. If you use our Vagrant setup, you do not have to change anything. If you don't: Please change the path accordingly. Wherever you see `/vagrant/...` below you use the path where the file is located at your system. All files referenced are included within this git.

## Steps
   * Prepare some configs for your own Certificate Authority (CA):  
     (within the Vagrant setup you might want to do the following steps directly in `/home/vagrant`)
     ```Bash
     ~# /vagrant/exercises/3/prepare_CA.sh

     Will create a new directory "ca" here (in /home/vagrant).
     Do you want to continue? y

     OK, created directory "ca" for you with following content:
     ==========================================================
     total 20
     -rw-rw-r--. 1 vagrant vagrant 11814 Sep 18 09:55 ca.cnf
     -rw-rw-r--. 1 vagrant vagrant     2 Sep 18 09:55 crlnumber
     -rw-rw-r--. 1 vagrant vagrant     0 Sep 18 09:55 index.txt
     drwxrwxr-x. 2 vagrant vagrant     6 Sep 18 09:55 newcerts
     -rw-rw-r--. 1 vagrant vagrant     2 Sep 18 09:55 serial
     ```

   * Create a private key for your CA certificate.  
     Up to now you generated keys without password protection (as it is an demo only). The private key of the CA certificate will be password protected - that's what the parameter `-aes256` does. Make sure you remember the password you are setting here. You will need it within this exercise and the following:  
     ```Bash
     ~# openssl genrsa -aes256 -out ca/private/cacert.key 4096
     Generating RSA private key, 4096 bit long modulus
     .............................................................................................................................................................................................................++
     .............................................................................................................................++
     e is 65537 (0x10001)
     Enter pass phrase for ca/private/cacert.key:
     Verifying - Enter pass phrase for ca/private/cacert.key:
     ```

   * Create your CA Certificate now.  
     Please note:
      - Generation of the CSR and generation of the certificate is done in one command here. (CSR is not written to a file.)
      - We added some default values into the config file for your convenience. Just press Enter to accept the defaults.
     ```Bash
     ~# openssl req -config ca/ca.cnf -new -x509 -days 3650 -key ca/private/cacert.key -out ca/cacert.pem
     Enter pass phrase for ca/private/cacert.key:
     You are about to be asked to enter information that will be incorporated
     into your certificate request.
     What you are about to enter is what is called a Distinguished Name or a DN.
     There are quite a few fields but you can leave some blank
     For some fields there will be a default value,
     If you enter '.', the field will be left blank.
     -----
     Country Name (2 letter code) [DE]:
     State or Province Name (full name) [Franconia]:
     Locality Name (eg, city) [Nuernberg]:
     Organization Name (eg, company) [Raffzahn GmbH]:
     Organizational Unit Name (eg, section) [IT]:
     Common Name (e.g. server FQDN or YOUR name) [Raffzahn CA]:
     Email Address [raffzahn.ca@example.com]:
     ```

   * You can view the certifcate you just created.  
     Please note the `X509v3 Basic Constraints: CA:TRUE` telling this is an CA certificate.
     ```Bash
     ~# openssl x509 -in ca/cacert.pem -noout -text
     ```

   * to be continued
