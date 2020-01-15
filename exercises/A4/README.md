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
     ~# curl --cacert ca/cacert.pem --cert ./client.crt --key client.key https://localhost:14443/index.html
     This content is only displayed if you authenticate successfully by a client certificate!
     (you connected to webspace of exercise A.4)
     ```

   * Negative test:  
     Let's check what happens, if we connect to the server without providing a client certificat.
     ```Bash
     ~# curl --cacert ca/cacert.pem https://localhost:14443/index.html
     curl: (56) OpenSSL SSL_read: error:1409445C:SSL routines:ssl3_read_bytes:tlsv13 alert certificate required, errno 0
     ```

   * Optional steps:  
      - If you need your client certificate and private key in a PKCS12 keystore (in PKCS12 format):  
        `openssl pkcs12 -export -in client.crt -inkey client.key -out client.keystore.p12`
        
## Java Example

Just like in exercise A2, the code for this Java example can be found within in the _java_sample_ directory.

### What you'll learn in this Java example
This Java example will demonstrate how connections to an mTLS-enabled backend can be made (i. e. a backend requesting client-side authentication on the transport level). In doing so, it will also outline how the difference between a truststore and a keystore impacts the client-side code.

For a detailed explanation of the difference between truststores and keystores, please refer to [this section](https://github.com/AntsInMyEy3sJohnson/TLS4Developers_Workshop/tree/master/exercises/A2#establishing-secure-backend-connections-using-a-resttemplate) of the Java example for exercise A2.

### Prerequisites
There are three prerequisites to running this Java example, namely, an mTLS-enabled backend and two files -- a truststore and a keystore (theoretically, the contents of both could be put into the same file, but that would defeat an important point of this example, so we'll put the trust material and key material into two different files). At this point, the first prerequisite should already be fulfilled if you have followed the steps above, so we're going to create a truststore and a keystore next.

+ __Creation of the truststore__: Our truststore in JKS format will contain the CA certificate you have created in scope of exercise A3 rather than a self-signed certificate -- as you'll recall from exercise A2, self-signed certificates entail a significant disadvantage concerning their distribution and management. To create a truststore containing the CA certificate, the following command can be used (from within the `/home/vagrant` directory):  
`$ mkdir material_java_a4 && keytool -import -file ca/cacert.pem -keystore material_java_a4/cacert.truststore.jks`  
This command will ask you for a password. Make sure to remember it, as we'll need it a bit further down the line.
+ __Creation of the keystore__: As you'll recall from the Java sample of exercise A2, a key entry in a keystore typically contains and entity's identity and its private key. Here, the client's identity is the `client.crt` file, and its private key is the `client.key` file. Hence, we have to make sure to include both in our keystore. To create a keystore containing both files, you can run the following command (in `/home/vagrant`):   
`$ openssl pkcs12 -export -in client.crt -inkey client.key -out client.keystore.p12`    
The resulting keystore in PKCS12 format then has to be transformed to a _Java Key Store_, i. e. a file in _JKS_ format. To do so, you can make use of the following command (in `/home/vagrant`):   
`$ keytool -importkeystore -deststorepass [destination_keystore_password] -destkeypass [destination_key_password] -destkeystore material_java_a4/client.keystore.jks -srckeystore client.keystore.p12 -srcstorepass [source_keystore_password]`   
Please make sure to remember the passwords you have provided for `-deststorepass` and `-destkeypass` as we'll need to provide both in our Java application's configuration.

So, you should now have two JKS files in your `/home/vagrant/material_java_a4` directory, namely, `cacert.truststore.jks` and `client.keystore.jks`. With those two files in place, you'll only have to adapt the passwords in the Java application's properties file, which you can find in `/vagrant/exercises/A4/java_sample/src/main/resources/application.properties`. Here, make sure to set the `http.client.ssl.trust-store-password`, `-key-store-password`, and `-key-password` properties in accordance to the passwords you have provided above.

### Setup of a `RestTemplate` to use both a truststore and a keystore
This Java example wouldn't be complete without having a short look at the difference in the configuration of our `RestTemplate` object compared to exercise A2, specifically with regards to loading a truststore versus loading a keystore.

If you take a look inside class `de.tls4developers.examples.exercisea4.MtlsEnabledRestTemplateConfiguration`, you'll notice we now invoke two methods on the `SSLContext` object (that will eventually be incorporated into the `RestTemplate`). You'll recognize the `loadTrustMaterial` method from exercise A2 -- we still use it to load truststore information. To load keystore information, on the other hand, we have to make use of the `loadKeyMaterial` method, which also gets the parameters it is called with from the `application.properties` file. You'll notice two things about this method:

+ Its parameters point to the keystore rather than the truststore, which is perfectly reasonable as the client's identity -- which we have to include because the backend we would like to talk to has mTLS enabled -- is contained in the keystore, not the truststore. 
+ There is a third parameter, namely, a password for the client's private key within the keystore. That also makes sense, since our command to create the JKS keystore involved setting a password for the client's key. 

With both the `loadTrustMaterial` and `loadKeyMaterial` methods in place, we can now run the application and see what happens once it attempts to issue a call against the mTLS-enabled backend.

### Running the application and verifying expected behavior

You can invoke the following command to run our Java sample application:

```bash
$ mvn -f /vagrant/exercises/A4/java_sample/pom.xml spring-boot:run
```

(Once again, if you run this command without ever having run a similar Maven command within the same Vagrant box, Maven will now proceed to download a whole bunch of stuff.)

As soon as the application has started, you'll find it listening for requests on port `14080`. To verify everything works as expected, issue the following command on the terminal (within the Vagrant box):

```bash
$ curl http://localhost:14080
```

This will make the application execute a call against our mTLS-enabled Apache web server (`https://localhost:14443/index.html`), which, as you'll recall from the exercise steps before this Java example, will only be successful if the application -- the client -- can authenticate itself to the Apache web server. If this is the case, you'll see the following:

```bash
[vagrant@centos8 ~]$ curl http://localhost:14080
<!doctype html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>TLS4Developers Workshop -- Exercise A2</title>
</head>
<body>
<div class="page-content">
    <h2>Eureka!</h2>
    <h3>Query successful:</h3>
    <p>This content is only displayed if you authenticate successfully by a client certificate!
(you connected to webspace of exercise A.4)
</p>
</div>
</body>
</html>
```


## Conclusion

   * In this Exercise the client certificate and the server certificate are signed by the same CA. In real world scenarios it can be done this way, but it does not need to.
   * Client certificate can be signed by a different CA than the server certificate. In this case the client needs to trust the CA which signed the server certificate. And the server needs to trust the CA which signed the client certificate.
