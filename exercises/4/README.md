# Exercise 4: mTLS Connection (with a Selfsigned Certificate)

## Objective

Up to now you used "regular" TLS connections with one keypair and one certificate: The client is able to proof he is talking to the right server, because the server authenticated itself (by certificate). But any client is allowed to connect to the server. The client does not need to authenticate (at least not at transport level - maybe the applications ask for credentials **after** a successful connect, but that's something different).

Now you will add an additional level of trust: The client will need to provide (cryptographically strong) authentication directly within the TLS handshake. This is called "mutual TLS" (mTLS).

Conceptual there are two different sorts of Client Certificates:
   * Client Certificates authenticating a user personally (a human being)
   * Client Certificates authenticating a client machine (in a machine to machine communication)
Technically both are absolutely the same (except you will fill the CN field in a diffent way). Which one is used depends on the usecase. In this example you will generate a Client Certificate for a person.

## Prerequisites

   * You need to complete [Exercise 2](../2/) before starting this one.  
     Background is: You need two keypairs and two certificates for this exercise - one for the server, one for the client. The server certificate you will reuse from exercise 2.
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

   * Create a new certificate signing request (CSR) from the private key you just generated:
     ```Bash
     ~# openssl req -new -key client.key -out client.csr
     You are about to be asked to enter information that will be incorporated
     into your certificate request.
     What you are about to enter is what is called a Distinguished Name or a DN.
     There are quite a few fields but you can leave some blank
     For some fields there will be a default value,
     If you enter '.', the field will be left blank.
     -----
     Country Name (2 letter code) [AU]:DE
     State or Province Name (full name) [Some-State]:Franconia
     Locality Name (eg, city) []:Nuernberg
     Organization Name (eg, company) [Internet Widgits Pty Ltd]:Raffzahn GmbH
     Organizational Unit Name (eg, section) []:IT
     Common Name (e.g. server FQDN or YOUR name) []:User Hans Wurst
     Email Address []:hans.wurst@example.com

     Please enter the following 'extra' attributes
     to be sent with your certificate request
     A challenge password []:
     An optional company name []:
     ```

   * Create a selfsigned certificate from the CSR above.
     ```Bash
     ~# openssl x509 -req -days 1000 -in client.csr -signkey client.key -out client.crt
     Signature ok
     subject=/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/OU=IT/CN=User Hans Wurst/emailAddress=hans.wurst@example.com
     Getting Private key
     ```
     You have at least 6 files now:
     ```Bash
     ~# ls -l
     total 24
     -rw-rw-r--. 1 vagrant vagrant 1346 Sep 16 14:44 client.crt
     -rw-rw-r--. 1 vagrant vagrant 1074 Sep 16 14:44 client.csr
     -rw-rw-r--. 1 vagrant vagrant 1679 Sep 16 14:43 client.key
     -rw-rw-r--. 1 vagrant vagrant 1298 Sep 16 14:04 localhost.crt
     -rw-rw-r--. 1 vagrant vagrant 1054 Sep 16 14:04 localhost.csr
     -rw-rw-r--. 1 vagrant vagrant 1679 Sep 16 14:03 localhost.key
     ```

   * Now let's setup a secure (HTTPS) virtual server having mTLS enabled:  
     Copy `exercises/4/apache_conf.d/exercise4.conf` to a directory where Apache looks for configurations and edit all paths in there (to match the paths you choose on your system).
      * in our Vagrant setup this is
        ```Bash
        ~# sudo cp /vagrant/exercises/4/apache_conf.d/exercise4.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise4.conf
        ```
      * in other CentOS / RedHat Enterprise setups do something like
        ```Bash
        ~# sudo cp exercises/4/apache_conf.d/exercise4.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise4.conf
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo cp exercises/4/apache_conf.d/exercise4.conf /etc/apache2/sites-available
        ~# sudo vim /etc/apache2/sites-available/exercise4.conf
        ```
     At `DocumentRoot` you give the full path of your `exercises/4/htdocs` directory  
     (make sure the runtime user of your Apache is allowed to read this directory)  
     `SSLCertificateFile` and `SSLCertificateKeyFile` refrence the full path of the `localhost.crt` and `localhost.key` file you created in exercise 2.

   * Enable the config now and reload your Apache.
      * in our Vagrant setup as well as in other CentOS / RedHat Enterprise setups this is
        ```Bash
        ~# sudo systemctl restart httpd
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo a2ensite exercise4
        ~# sudo systemctl reload apache2
        ```

   * Make sure it has an TCP Listener on Port 14443 now:
     ```Bash
     ~# sudo netstat -pltn
             # or alternatively
     ~# sudo lsof | grep LISTEN
     ```

   * Let's test!  
     Acting as a client now you trust (`--cacert`) the other party (the server). And you need to authenticate with your own client certificate (and for authentication you need the private key of this keypair as a "proof of possession").
     ```Bash
     ~# curl --cacert localhost.crt --cert client.crt --key client.key https://localhost:14443/index.html
     This content is only displayed if you authenticate successfully by a client certificate!
     ```

   * Negative test:  
     Let's check what happens, if we connect to the server without providing a client certificat.
     ```Bash
     ~# curl --cacert localhost.crt https://localhost:14443/index.html
     curl: (35) NSS: client certificate not found (nickname not specified)
     ```

## Conclusion

   * ...
