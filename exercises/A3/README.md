# Exercise A.3: A Certificate Authority (CA)

## Objective

In the previous exercises you found out that selfsigned certificates are nasty to use when it comes to day-to-day business. The certificate of every server needs to be in the truststore of every client. If you have M servers and N clients you would have to distribute M * N entries in truststores. And be aware of certificates have a limited lifetime - you will have to renew all of them from time to time.

So in the real world there are Certificate Authorities (CAs) approving and signing certificates of others. You only need to trust these CA certificates.

In this exercise you will create your own CA certificate and sign your server's certificate with this. Besides this, the setup here is very similar to exercise A.2. Well, to be honest, a CA certificate created by yourself does not help too much, because you still have to put this one into all truststores yourself. For demo purposes you will do it anyway.

One advantage compared to selfsigned certificates stays: You need to distribute only N entries in truststores (which is already way better than M * N).

## Hint

In this exercise some commands reference files by complete path. If you use our Vagrant setup, you do not have to change anything. If you don't: Please change the path accordingly. Wherever you see `/vagrant/...` below you use the path where the file is located at your system. All files referenced are included within this git.

## Steps
   * Prepare some configs for your own Certificate Authority (CA):  
     (within the Vagrant setup you might want to do the following steps directly in `/home/vagrant`)
     ```Bash
     ~# /vagrant/exercises/A3/prepare_CA.sh

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
     Up to now you generated keys without password protection (as it is a demo only). The private key of the CA certificate will be password protected - that's what the parameter `-aes256` does. Make sure you remember the password you are setting here. You will need it within this exercise and the following:  
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
      - There are some default values in the config file (`ca/ca.cnf`) for your convenience. Just press Enter to accept the defaults.
      - Please make sure you fill the __Common Name__ field yourself!
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
     Organizational Unit Name (eg, section) []:
     Common Name (e.g. server FQDN or YOUR name) []:Raffzahn CA
     Email Address [certificates@example.com]:

     ```

   * You can view the certifcate you just created.  
     Please note the `X509v3 Basic Constraints: CA:TRUE` telling this is an CA certificate.
     ```Bash
     ~# openssl x509 -in ca/cacert.pem -noout -text
     ```

   * Next step is to create a certificate for the server. Start with a private key file:
     ```Bash
     ~# openssl genrsa -out server.key 2048
     Generating RSA private key, 2048 bit long modulus
     ....................+++
     ................+++
     e is 65537 (0x10001)
     ```

   * Create a CSR now.  
     Please note:
      - using `-config openssl.cnf` is for your convenience only (safe some typing)
      - make sure for `Common Name` you give `localhost`
     ```Bash
     ~# openssl req -config openssl.cnf -new -key server.key -out server.csr
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
     Organizational Unit Name (eg, section) []:
     Common Name (e.g. server FQDN or YOUR name) []:localhost
     Email Address [certificates@example.com]:

     Please enter the following 'extra' attributes
     to be sent with your certificate request
     A challenge password []:
     An optional company name []:
     ```

   * Now you will use your own CA (created above) to sign this CSR:
     ```Bash
     ~# openssl ca -config ca/ca.cnf -extensions server_cert -days 365 -in server.csr -out server.crt
     Using configuration from ca/ca.cnf
     Enter pass phrase for /home/vagrant/ca/private/cacert.key:
     Check that the request matches the signature
     Signature ok
     Certificate Details:
             Serial Number: 1 (0x1)
             Validity
                 Not Before: Sep 23 11:12:32 2019 GMT
                 Not After : Sep 22 11:12:32 2020 GMT
             Subject:
                 countryName               = DE
                 stateOrProvinceName       = Franconia
                 organizationName          = Raffzahn GmbH
                 commonName                = localhost
                 emailAddress              = certificates@example.com
             X509v3 extensions:
                 X509v3 Basic Constraints: 
                     CA:FALSE
                 Netscape Cert Type: 
                     SSL Server
                 Netscape Comment: 
                     OpenSSL Generated Server Certificate
                 X509v3 Subject Key Identifier: 
                     83:B6:62:38:7F:43:11:79:19:D1:AC:DA:9C:57:48:7C:4E:F1:6A:D2
                 X509v3 Authority Key Identifier: 
                     keyid:D6:3B:17:96:65:CB:B2:36:43:5D:EE:29:6E:26:7A:D7:6C:C8:B7:74
                     DirName:/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=Raffzahn CA/emailAddress=certificates@example.com
                     serial:F8:D7:78:1D:20:89:FF:61

                 X509v3 Key Usage: critical
                     Digital Signature, Key Encipherment
                 X509v3 Extended Key Usage: 
                     TLS Web Server Authentication
     Certificate is to be certified until Sep 22 11:12:32 2020 GMT (365 days)
     Sign the certificate? [y/n]:y


     1 out of 1 certificate requests certified, commit? [y/n]y
     Write out database with 1 new entries
     Data Base Updated
     ```

   * You have 3 new files now:
     ```Bash
     ~# ls -l server*
     -rw-rw-r--. 1 vagrant vagrant 6606 Sep 23 11:12 server.crt
     -rw-rw-r--. 1 vagrant vagrant 1054 Sep 23 11:05 server.csr
     -rw-rw-r--. 1 vagrant vagrant 1679 Sep 23 11:03 server.key
     ```

   * Of course you can view the certificate now - if you like - by using the openssl command.  
     (If you do not remember the syntax: Scroll up again!)

   * Now let's again setup a secure (HTTPS) virtual server within Apache:  
     Copy `exercises/A3/apache_conf.d/exercise-A3.conf` to a directory where Apache looks for configurations and edit all paths in there (to match the paths you choose on your system).
      * in our Vagrant setup this is
        ```Bash
        ~# sudo cp /vagrant/exercises/A3/apache_conf.d/exercise-A3.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A3.conf
        ```
      * in other CentOS / RedHat Enterprise setups do something like
        ```Bash
        ~# sudo cp exercises/A3/apache_conf.d/exercise-A3.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A3.conf
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo cp exercises/A3/apache_conf.d/exercise-A3.conf /etc/apache2/sites-available
        ~# sudo vim /etc/apache3/sites-available/exercise-A3.conf
        ```
     At `DocumentRoot` you give the full path of your `exercises/A3/htdocs` directory  
     (make sure the runtime user of your Apache is allowed to read this directory)  
     `SSLCertificateFile` and `SSLCertificateKeyFile` refrence the full path of `server.crt` and `server.key` you created above.

   * Enable the config now and reload your Apache.
      * in our Vagrant setup as well as in other CentOS / RedHat Enterprise setups this is
        ```Bash
        ~# sudo systemctl restart httpd
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo a2ensite exercise-A3
        ~# sudo systemctl reload apache2
        ```

   * Make sure it has an TCP Listener on Port 13443 now:
     ```Bash
     ~# sudo netstat -pltn
             # or alternatively
     ~# sudo lsof | grep LISTEN
     ```

   * Now it's time for the next test (explicitly trusting our CA):
     ```Bash
     ~# curl --cacert ca/cacert.pem https://localhost:13443/index.html
     Hello World
     (you connected to webspace of exercise A.3)
     ```

   * Optional steps:  
      - In some usecases you need your certificate in a keystore (in PKCS12 format). To place the server certificate plus it's private key in a (newly created) PKCS12 keystore:  
        `openssl pkcs12 -export -in server.crt -inkey server.key -out server.keystore.p12`  
        (make sure you remember the keystore password you are setting here)
      - To display the content of the keystore:  
        `openssl pkcs12 -in server.keystore.p12 -nodes`
      - A truststore in PKCS12 format (containing the CA certificate only, no private key) can be created pretty much the same way:  
        `openssl pkcs12 -export -in ca/cacert.pem -nokeys -out ca/truststore.ca.p12`


## Conclusion

   * You are working with two different Certificates now: The server certificate and the CA certificate.
   * The server certificate is needed on the server only - no need to put it onto the truststore of the client.
   * The client has the CA certificate in it's truststore only.
   * If you need to change the server certificate (at the end of it's lifetime) it's a task on the server only: The client does not need to change anything.
