# Exercise A.1: A Connection with a Selfsigned Certificate

## Objective
In this exercise you will setup a secure (HTTPS) virtual server within an Apache Webserver and connect to it. The connection will be secured by a selfsigned certificate you will create and sign yourself.

## Steps

   * Generate a new private key file (in PEM format):  
     (within the Vagrant setup you might want to do the following steps directly in `/home/vagrant`)
     ```Bash
     ~# openssl genrsa -out example.com.key 2048
     Generating RSA private key, 2048 bit long modulus
     ....................................................................+++++
     ..............................................................................+++++
     e is 65537 (0x010001)
     ```

   * Create a new certificate signing request (CSR) from the private key you just generated:
     ```Bash
     ~# openssl req -new -key example.com.key -out example.com.csr
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
     Common Name (e.g. server FQDN or YOUR name) []:example.com
     Email Address []:certifcates@example.com

     Please enter the following 'extra' attributes
     to be sent with your certificate request
     A challenge password []:
     An optional company name []:
     ```

   * Create a selfsigned certificate from the CSR above.
     ```Bash
     ~# openssl x509 -req -days 1000 -in example.com.csr -signkey example.com.key -out example.com.crt
     Signature ok
     subject=C = DE, ST = Franconia, L = Nuernberg, O = Raffzahn GmbH, CN = example.com, emailAddress = certifcates@example.com
     Getting Private key
     ```
     You have 3 new files now:
     ```Bash
     ~# ls -l
     total 12
     -rw-r--r-- 1 booboo booboo 1302 Sep 13 15:16 example.com.crt
     -rw-r--r-- 1 booboo booboo 1054 Sep 13 15:15 example.com.csr
     -rw------- 1 booboo booboo 1675 Sep 13 15:12 example.com.key
     ```

   * Now let's setup a secure (HTTPS) virtual server within Apache:  
     Copy `exercises/A1/apache_conf.d/exercise-A1.conf` to a directory where Apache looks for configurations and edit all paths in there (to match the paths you choose on your system).
      * in our Vagrant setup this is
        ```Bash
        ~# sudo cp /vagrant/exercises/A1/apache_conf.d/exercise-A1.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A1.conf
        ```
      * in other CentOS / RedHat Enterprise setups do something like
        ```Bash
        ~# sudo cp exercises/A1/apache_conf.d/exercise-A1.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise-A1.conf
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo cp exercises/A1/apache_conf.d/exercise-A1.conf /etc/apache2/sites-available
        ~# sudo vim /etc/apache2/sites-available/exercise-A1.conf
        ```
     At `DocumentRoot` you give the full path of your `exercises/A1/htdocs` directory  
     (make sure the runtime user of your Apache is allowed to read this directory)  
     `SSLCertificateFile` and `SSLCertificateKeyFile` refrence the full path of the files you created above.

   * Enable the config now and reload your Apache.
      * in our Vagrant setup as well as in other CentOS / RedHat Enterprise setups this is
        ```Bash
        ~# sudo systemctl restart httpd
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo a2ensite exercise-A1
        ~# sudo systemctl reload apache2
        ```

   * Make sure it has an TCP Listener on Port 11443 now:
     ```Bash
     ~# sudo netstat -pltn
             # or alternatively
     ~# sudo lsof | grep LISTEN
     ```

   * Now it's time to test it:
     ```Bash
     ~# curl https://localhost:11443/index.html
     curl: (60) Peer certificate cannot be authenticated with known CA certificates
     ```
     Or - depending on the versions in use - the message might also be:
     ```Bash
     curl: (60) SSL certificate problem: self signed certificate
     ```
     That's what we expected. We not yet did put our selfsigned certificate into the truststore of our client (curl). So it is not trusted. Let's tell curl explicitly which certificate we trust:
     ```Bash
     ~# curl --cacert example.com.crt https://localhost:11443/index.html
     curl: (51) SSL: certificate subject name 'example.com' does not match target host name 'localhost'
     ```
     Or maybe the wording of the message might be:
     ```Bash
     curl: (51) Unable to communicate securely with peer: requested domain name does not match the server's certificate.
     ```
     Ah! Oh! Still doesn't work. Name (CN) in the certificate doesn't match the name in the URL (localhost). That's the point where users tend to click buttons like "Continue anyway!" or "I accept the insecure way!" (or add parameters to the curl command telling the same). We - of course - **NEVER DO SUCH THINGS!!** We want trust! We fix problems instead of working around them.

   * Please continue with [Exercise A.2](../A2/) to see how we manage to do this.
