# Exercise B.1: An Intermediate Certificate (and a HTTPS Connection with an Official Server Certificate)

## Objective
You will learn what an intermediate certificate (also called chain certificate) is. Afterwards you will setup a webserver using an certificate from an official CA, using an intermediate certificate. Finally you will connect to it with your browser (and get a green lock icon.)

## What is an Intermediate Certificate (or Chain Certificate)?
The root certificates of the official Certificate Authorities (CAs) are (by default) in the truststores of billions of browsers and other clients worldwide. So exchanging one of them in a short time (e. g. if it was compromised) is hardly possible. So their private keys need to be very well protected. Usually they are stored offline in high secure facilities.

On the other hand CAs need to sign lots of certificates every day - which would be really hard to do with an offline machine (containing the CA certificate). So one level of indirection needs to be added to make it work in day-to-day business:

The (offline) Root CA signs the certificate of (online) signing CA. And the signing CA signs certificates of the customers (e. g. server certificates, client certificates, ...). If the certificate of the signing CA was compromised, it can easily be revoked by the Root CA and a new signing CA certificate can be issued: No need to touch anything on the billions of clients.

__Next problem:__ Nobody would trust the server or client certificates. They are issued by the signing CA and their certificate is not in the truststore.

__Solution:__ Whenever I send over my certificate to my communication partner (during the TLS handshake) I do not only send my own certificate but also add the certificate of the signing CA. My communication partner can then verify my certificate against the certificate of the signing CA and the certificate of the signing CA against the certificate of the Root CA, which is in the truststore.

When including the certificate of the signing CA in the TLS handshake, we call it an intermediate certificate or chain certificate because it completes the chain of trust.

__ATTENTION:__ Make sure you __NEVER NEVER NEVER__ put some intermediate certificate into some truststore! This would only help if you messed up your TLS handshake. Of course it would work in the first place. But you will be in trouble later if the intermediate will be revoked or needs to be renewed (because it expires). All these well proven concepts will not work any longer.  
So please: __NEVER NEVER NEVER__ put some intermediate certificate into some truststore! Go ahead: Fix your config instead!!

## Steps

   * Make sure you have all the additional prerequisites for chapter B in place. You find them in section "Additional Prerequisites" of the [global README](../../).

   * Now let's setup a secure (HTTPS) virtual server within Apache:  
     Copy `exercises/A2/apache_conf.d/exercise-A2.conf` to a directory where Apache looks for configurations and edit all paths in there (to match the paths you choose on your system).
      * in our Vagrant setup this is
        ```Bash
        ~# sudo cp /vagrant/exercises/A2/apache_conf.d/exercise-A2.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A2.conf
        ```
      * in other CentOS / RedHat Enterprise setups do something like
        ```Bash
        ~# sudo cp exercises/A2/apache_conf.d/exercise-A2.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A2.conf
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo cp exercises/A2/apache_conf.d/exercise-A2.conf /etc/apache2/sites-available
        ~# sudo vim /etc/apache2/sites-available/exercise-A2.conf
        ```
     At `DocumentRoot` you give the full path of your `exercises/A2/htdocs` directory  
     (make sure the runtime user of your Apache is allowed to read this directory)  
     `SSLCertificateFile` and `SSLCertificateKeyFile` refrence the full path of the files you created above.

   * Enable the config now and reload your Apache.
      * in our Vagrant setup as well as in other CentOS / RedHat Enterprise setups this is
        ```Bash
        ~# sudo systemctl restart httpd
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo a2ensite exercise-A2
        ~# sudo systemctl reload apache2
        ```

   * Make sure it has an TCP Listener on Port 12443 now:
     ```Bash
     ~# sudo netstat -pltn
             # or alternatively
     ~# sudo lsof | grep LISTEN
     ```

   * Now it's time for the next test (explicitly trusting our selfsigned certificate):
     ```Bash
     ~# curl --cacert localhost.crt https://localhost:12443/index.html
     Hello World
     (you connected to webspace of exercise A.2)
     ```
     __Yeah! It works now without certificate warnings!__

   * Optional steps:  
      - In some usecases you need your certificate in a keystore (in PKCS12 format). To place the localhost certificate plus it's private key in a (newly created) PKCS12 keystore:  
        `openssl pkcs12 -export -in localhost.crt -inkey localhost.key -out localhost.keystore.p12`  
        (make sure you remember the keystore password you are setting here)
      - To display the content of the keystore:  
        `openssl pkcs12 -in localhost.keystore.p12 -nodes`
      - If the HTTPS client is e. g. written in Java, you will need to provide it a truststore. A truststore contains every certificate you trust, usually CA certificates only (and no private keys). In our example with the selfsigned certificate you need the localhost certificate itself in the truststore in PKCS12 format. Create it by:  
        `openssl pkcs12 -export -in localhost.crt -nokeys -out localhost.truststore.p12`


## Conclusion

   * It works now completly without any certificate warning. Exactly the same way it would work if we used a FQDN in the URL as well as in the CN of the certificate.
   * __Learning:__ Selfsigned certificates are not less secure than certificates signed by an official CA. Encryption is fully in place.
   * __Drawback:__ It's not practical anyway! If you wanted to deal with selfsigned certificates in the real world, you would need to make sure the certificate of your server is included in the truststore of every client connecting to it.
