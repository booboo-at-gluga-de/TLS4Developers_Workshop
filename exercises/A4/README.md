# Exercise A.4: mTLS Connection

## Objective

Up to now you used "regular" TLS connections with a keypair and certificate for the server only: The client is able to proof he is talking to the right server, because the server authenticated itself (by certificate). But any client is allowed to connect to the server. The client does not need to authenticate (at least not at transport level - maybe the applications ask for credentials **after** a successful connect, but that's something different).

Now you will add an additional level of trust: The client will need to provide (cryptographically strong) authentication directly within the TLS handshake. This is called "mutual TLS" (mTLS).

Conceptual there are two different sorts of Client Certificates:
   * Client Certificates authenticating a user personally (a human being)
   * Client Certificates authenticating a client machine (in a machine to machine communication)
Technically both are absolutely the same (except you will fill the CN field in a diffent way). Which one is used depends on the usecase. In this exercise you will generate a Client Certificate for a person.

## Prerequisites

   * You need to complete [Exercise A.3](../A3/) before starting this one.  
     Background is: You need two keypairs and two certificates for this exercise - one for the server, one for the client. Plus additionally the CA certificate for signing both of them. The server certificate and the CA certificate you will reuse from exercise A.3.
   * Usually the client and the server run on different machines. For this example it's absolutely ok to have both of them on one machine (your playground machine)

## Steps

   * Generate an additional new private key file for the client:  
     (within the Vagrant setup you might want to do the following steps directly in `/home/vagrant`)
     ```Bash
     ~# openssl genrsa -out client.key 2048
     Generating RSA private key, 2048 bit long modulus
     ....................................................................+++++
     ..............................................................................+++++
     e is 65537 (0x010001)
     ```

   * Create a new certificate signing request (CSR) from the private key you just generated.  
      - Make sure you fill at least `Common Name` (and maybe `Email Address`) with meaningful values
     ```Bash
     ~# openssl req -config openssl.cnf -new -key client.key -out client.csr
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
     Organizational Unit Name (eg, section) []:IT
     Common Name (e.g. server FQDN or YOUR name) []:User Hans Wurst
     Email Address [certificates@example.com]:hans.wurst@example.com

     Please enter the following 'extra' attributes
     to be sent with your certificate request
     A challenge password []:
     An optional company name []:
     ```

   * Sign the CSR with your own CA (created in exercise A.3):
     ```Bash
     ~# openssl ca -config ca/ca.cnf -extensions client_cert -days 365 -in client.csr -out client.crt
     Using configuration from ca/ca.cnf
     Enter pass phrase for /home/vagrant/ca/private/cacert.key:
     Check that the request matches the signature
     Signature ok
     Certificate Details:
             Serial Number: 2 (0x2)
             Validity
                 Not Before: Sep 24 05:51:01 2019 GMT
                 Not After : Sep 23 05:51:01 2020 GMT
             Subject:
                 countryName               = DE
                 stateOrProvinceName       = Franconia
                 organizationName          = Raffzahn GmbH
                 organizationalUnitName    = IT
                 commonName                = User Hans Wurst
                 emailAddress              = hans.wurst@example.com
             X509v3 extensions:
                 X509v3 Basic Constraints: 
                     CA:FALSE
                 Netscape Cert Type: 
                     SSL Client, S/MIME
                 Netscape Comment: 
                     OpenSSL Generated Client Certificate
                 X509v3 Subject Key Identifier: 
                     CC:2D:60:A9:B6:11:C5:A6:B2:A5:A4:B2:7F:5A:A9:BC:AD:27:B5:FD
                 X509v3 Authority Key Identifier: 
                     keyid:9F:4B:28:60:6D:B3:AD:2A:58:D4:4A:2B:2F:99:F0:CF:D5:D8:24:86

                 X509v3 Key Usage: critical
                     Digital Signature, Non Repudiation, Key Encipherment
                 X509v3 Extended Key Usage: 
                     TLS Web Client Authentication, E-mail Protection
     Certificate is to be certified until Sep 23 05:51:01 2020 GMT (365 days)
     Sign the certificate? [y/n]:y


     1 out of 1 certificate requests certified, commit? [y/n]y
     Write out database with 1 new entries
     Data Base Updated
     ```

   * Again setup a secure (HTTPS) virtual server, now having mTLS enabled:  
     Copy `exercises/A4/apache_conf.d/exercise-A4.conf` to a directory where Apache looks for configurations and edit all paths in there (to match the paths you choose on your system).
      * in our Vagrant setup this is
        ```Bash
        ~# sudo cp /vagrant/exercises/A4/apache_conf.d/exercise-A4.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A4.conf
        ```
      * in other CentOS / RedHat Enterprise setups do something like
        ```Bash
        ~# sudo cp exercises/A4/apache_conf.d/exercise-A4.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A4.conf
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo cp exercises/A4/apache_conf.d/exercise-A4.conf /etc/apache2/sites-available
        ~# sudo vim /etc/apache2/sites-available/exercise-A4.conf
        ```
     At `DocumentRoot` you give the full path of your `exercises/A4/htdocs` directory  
     (make sure the runtime user of your Apache is allowed to read this directory)  
     `SSLCertificateFile` and `SSLCertificateKeyFile` refrence the full path of the `server.crt` and `server.key` file you created in exercise A.3.  
     `SSLCACertificateFile` gets the full path of your CA certificate `ca/cacert.pem` also created in exercise A.3.

   * Enable the config now and reload your Apache.
      * in our Vagrant setup as well as in other CentOS / RedHat Enterprise setups this is
        ```Bash
        ~# sudo systemctl restart httpd
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo a2ensite exercise-A4
        ~# sudo systemctl reload apache2
        ```

   * Make sure it has an TCP Listener on Port 14443 now:
     ```Bash
     ~# sudo netstat -pltn
             # or alternatively
     ~# sudo lsof | grep LISTEN
     ```

   * Let's test!  
     Acting as a client now you trust (`--cacert`) the CA. And you need to authenticate with your own client certificate (and for authentication you need the private key of this keypair as a "proof of possession").
     ```Bash
     ~# curl --cacert ca/cacert.pem --cert client.crt --key client.key https://localhost:14443/index.html
     This content is only displayed if you authenticate successfully by a client certificate!
     (you connected to webspace of exercise A.4)
     ```

   * Negative test:  
     Let's check what happens, if we connect to the server without providing a client certificat.
     ```Bash
     ~# curl --cacert ca/cacert.pem https://localhost:14443/index.html
     curl: (35) NSS: client certificate not found (nickname not specified)
     ```

## Conclusion

   * ...
