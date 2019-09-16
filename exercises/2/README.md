# Exercise 2: A Connection with a Selfsigned Certificate - completely verified

## Objective
You will do pretty much the same as in Exercise 1, but will make sure the CN in the certificate matches the domain name used in the URL ("localhost"). This way you make sure to get along without any certificate warning.

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
~# openssl x509 -req -days 1000 -in localhost.csr -signkey localhost.key -out localhost.crt
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
     Copy `exercises/2/apache_conf.d/exercise2.conf` to a directory where Apache looks for configurations and edit all paths in there (to match the paths you choose on your system).
      * in our Vagrant setup this is
        ```Bash
        ~# sudo cp /vagrant/exercises/2/apache_conf.d/exercise2.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise2.conf
        ```
      * in other CentOS / RedHat Enterprise setups do something like
        ```Bash
        ~# sudo cp exercises/2/apache_conf.d/exercise2.conf /etc/httpd/conf.d/
        ~# sudo vim /etc/httpd/conf.d/exercise2.conf
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo cp exercises/2/apache_conf.d/exercise2.conf /etc/apache2/sites-available
        ~# sudo vim /etc/apache2/sites-available/exercise2.conf
        ```

At `DocumentRoot` you give the full path of your `exercises/2/htdocs` directory
(make sure the runtime user of your Apache is allowed to read this directory)
`SSLCertificateFile` and `SSLCertificateKeyFile` refrence the full path of the files you created above.

   * Enable the config now and reload your Apache.

      * in our Vagrant setup as well as in other CentOS / RedHat Enterprise setups this is

```Bash
~# sudo systemctl restart httpd
```

      * and in Debian / Ubuntu / Mint you do something like

```Bash
~# sudo a2ensite exercise2
~# sudo systemctl reload apache2
```

Make sure it has an TCP Listener on Port 12443 now:

```Bash
~# sudo netstat -pltn
         # or alternatively
~# sudo lsof | grep LISTEN
```

   * Now it's time for the next test (trusting our selfsigned certificate):

```Bash
~# curl --cacert localhost.crt https://localhost:12443/index.html
Hello World
```

__Yeah! It works now without certificate warnings!__


## Conclusion

   * It works now completly without any certificate warning. Exactly the same way it would work if we used a FQDN in the URL and in the CN of the certificate.
   * __Learning:__ Selfsigned certificates are not less secure than certificates signed by an official CA.
   * __Drawback:__ It's not practical anyway. If you wanted to deal with selfsigned certificates in the real world, you would need to make sure the certificate of your server is included in the truststore of every client connecting to it.
