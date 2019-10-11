# Exercise B.2: mTLS Connection with Intermediate Certificate

## Objective

In this Exercise you will create a very similar setup as in [Exercise A.4](../A4/) with a few new things:
   * You will use official certificates now.
   * An intermediate certificate will be used when the client authenticates the server.
   * An intermediate certificate will be used when the server authenticates the client.

## Prerequisites

   * Make sure you have all the additional prerequisites for chapter B in place. You find them in section "Additional Prerequisites" of the [global README](../../../../).
   * You need a client certificate issued by an official CA or corporate CA.
      - You will also need the intermediate certificate for your client certificate.
      - And you will need the root certificate of the CA issuing your client certificate.
        (Probably it will be available in the default truststore but you need to know which one it is.)
      - If you are doing this exercise with an Let's Encrypt certificate as server certificate you can use the same certificate as client certificate too. This is not really a setup you will use in your production environment, but will be absolutely ok here. It works because Let's Encrypt by default does not only add the server flag to a certificate issued, but also the client flag.
        ```Bash
        ~# sudo openssl x509 -in /etc/letsencrypt/live/exercise.jumpingcrab.com/cert.pem -noout -text | grep -A1 "Extended Key Usage:"
                    X509v3 Extended Key Usage: 
                        TLS Web Server Authentication, TLS Web Client Authentication
        ```
   * Usually the client and the server run on different machines. For this example it's absolutely ok to have both of them on one machine (your playground machine). Additionally you can use the browser on your workstation as client.

## Steps

   * If you are using one single Let's Encrypt Certificate in both roles (server certificate and client certificate) please copy it - for the use as client certificate - over to your home directory.
     ```Bash
     ~# mkdir ~/clientcrt
     ~# chmod 700 ~/clientcrt/
     ~# sudo readlink -f /etc/letsencrypt/live/exercise.jumpingcrab.com/cert.pem /etc/letsencrypt/live/exercise.jumpingcrab.com/chain.pem /etc/letsencrypt/live/exercise.jumpingcrab.com/fullchain.pem /etc/letsencrypt/live/exercise.jumpingcrab.com/privkey.pem
     /etc/letsencrypt/archive/exercise.jumpingcrab.com/cert1.pem
     /etc/letsencrypt/archive/exercise.jumpingcrab.com/chain1.pem
     /etc/letsencrypt/archive/exercise.jumpingcrab.com/fullchain1.pem
     /etc/letsencrypt/archive/exercise.jumpingcrab.com/privkey1.pem
     ~# sudo cp /etc/letsencrypt/archive/exercise.jumpingcrab.com/cert1.pem  /etc/letsencrypt/archive/exercise.jumpingcrab.com/chain1.pem /etc/letsencrypt/archive/exercise.jumpingcrab.com/fullchain1.pem /etc/letsencrypt/archive/exercise.jumpingcrab.com/privkey1.pem ~/clientcrt/
     ```
     This way you at least have different files for the client certificate (in `~/clientcrt/`) and for the server certificate (in `/etc/letsencrypt/live/`). From this point on: Do not care about the fact these are just copies. Imagine they are differnt!
   * Setup a secure (HTTPS) virtual server, having mTLS enabled:  
     Copy `exercises/B2/apache_conf.d/exercise-B2.conf` to a directory where Apache looks for configurations and edit all paths in there (to match the paths you choose on your system).
      * in CentOS / RedHat Enterprise setups do something like
        ```Bash
        ~# sudo cp exercises/B2/apache_conf.d/exercise-B2.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-B2.conf
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo cp exercises/B2/apache_conf.d/exercise-B2.conf /etc/apache2/sites-available
        ~# sudo vim /etc/apache2/sites-available/exercise-B2.conf
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
     ~# curl --cacert ca/cacert.pem --cert ./client.crt --key client.key https://localhost:14443/index.html
     This content is only displayed if you authenticate successfully by a client certificate!
     (you connected to webspace of exercise A.4)
     ```

   * Negative test:  
     Let's check what happens, if we connect to the server without providing a client certificat.
     ```Bash
     ~# curl --cacert ca/cacert.pem https://localhost:14443/index.html
     curl: (35) NSS: client certificate not found (nickname not specified)
     ```

   * Optional steps:  
      - If you need your client certificate and private key in a PKCS12 keystore (in PKCS12 format):  
        `openssl pkcs12 -export -in client.crt -inkey client.key -out client.keystore.p12`

## Conclusion

   * In this Exercise the client certificate and the server certificate are signed by the same CA. In real world scenarios it can be done this way, but it does not need to.
   * Client certificate can be signed by a different CA than the server certificate. In this case the client needs to trust the CA which signed the server certificate. And the server needs to trust the CA which signed the client certificate.




[vagrant@localhost ~]$ curl --cert ./fullchain1.pem --key privkey1.pem https://exercise.jumpingcrab.com:22443/index.html
This content is only displayed if you authenticate successfully by a client certificate!
(you connected to webspace of exercise B.2)

