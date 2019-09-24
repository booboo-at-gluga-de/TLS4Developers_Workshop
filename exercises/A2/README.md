# Exercise A.2: A Connection with a Selfsigned Certificate - completely verified

## Objective
You will do pretty much the same as in Exercise A.1, but will make sure the CN in the certificate matches the domain name used in the URL ("localhost"). This way you make sure to get along without any certificate warning.

## Steps

   * Generate a new private key file (in PEM format):  
     (within the Vagrant setup you might want to do the following steps directly in `/home/vagrant`)
     ```Bash
     ~# openssl genrsa -out localhost.key 2048
     Generating RSA private key, 2048 bit long modulus
     ....................................................................+++++
     ..............................................................................+++++
     e is 65537 (0x010001)
     ```

   * Create a new certificate signing request (CSR) from the private key you just generated:  
     __ATTENTION:__ Make sure in the field "Common Name" you enter `localhost`
     ```Bash
     ~# openssl req -new -key localhost.key -out localhost.csr
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
     Organizational Unit Name (eg, section) []:
     Common Name (e.g. server FQDN or YOUR name) []:localhost
     Email Address []:certifcates@example.com

     Please enter the following 'extra' attributes
     to be sent with your certificate request
     A challenge password []:
     An optional company name []:
     ```

   * Create a selfsigned certificate from the CSR above.
     ```Bash
     ~# openssl x509 -req -days 365 -in localhost.csr -signkey localhost.key -out localhost.crt
     Signature ok
     subject=C = DE, ST = Franconia, L = Nuernberg, O = Raffzahn GmbH, CN = localhost, emailAddress = certifcates@example.com
     Getting Private key
     ```
     You have 3 new files now:
     ```Bash
     ~# ls -l
     total 12
     -rw-r--r-- 1 booboo booboo 1302 Sep 13 17:26 localhost.crt
     -rw-r--r-- 1 booboo booboo 1054 Sep 13 17:25 localhost.csr
     -rw------- 1 booboo booboo 1675 Sep 13 17:22 localhost.key
     ```

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
        `openssl pkcs12 -export -in localhost.crt -inkey localhost.key -out localhost.keystore.pkcs12`  
        (make sure you remember the keystore password you are setting here)
      - To display the content of the keystore:  
        `openssl pkcs12 -in localhost.keystore.pkcs12 -nodes`
      - If the HTTPS client is e. g. written in Java, you will need to provide it a truststore. A truststore contains every certificate you trust, usually CA certificates only (and no private keys). In our example with the selfsigned certificate you need the localhost certificate itself in the truststore in PKCS12 format. Create it by:  
        `openssl pkcs12 -export -in localhost.crt -nokeys -out localhost.truststore.pkcs12`


## Conclusion

   * It works now completly without any certificate warning. Exactly the same way it would work if we used a FQDN in the URL as well as in the CN of the certificate.
   * __Learning:__ Selfsigned certificates are not less secure than certificates signed by an official CA. Encryption is fully in place.
   * __Drawback:__ It's not practical anyway! If you wanted to deal with selfsigned certificates in the real world, you would need to make sure the certificate of your server is included in the truststore of every client connecting to it.