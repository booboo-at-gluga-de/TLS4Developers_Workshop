# Exercise A.2: A Connection with a Selfsigned Certificate - completely verified

## Objective
You will do pretty much the same as in Exercise A.1, but will make sure the CN in the certificate matches the domain name used in the URL ("localhost"). This way you make sure to get along without any certificate warning.

## A.2.1 Steps

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
     -rw-r--r-- 1 vagrant vagrant 1302 Sep 13 17:26 localhost.crt
     -rw-r--r-- 1 vagrant vagrant 1054 Sep 13 17:25 localhost.csr
     -rw------- 1 vagrant vagrant 1675 Sep 13 17:22 localhost.key
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

   * _Optional steps:_  
      - _In some usecases you need your certificate in a keystore (in PKCS12 format). To place the localhost certificate plus it's private key in a (newly created) PKCS12 keystore:_  
        `openssl pkcs12 -export -in localhost.crt -inkey localhost.key -out localhost.keystore.p12`  
        _(make sure you remember the keystore password you are setting here)_
      - _To display the content of the keystore:_  
        `openssl pkcs12 -in localhost.keystore.p12 -nodes`
      - _If the HTTPS client is e. g. written in Java, you will need to provide it a truststore. A truststore contains every certificate you trust, usually CA certificates only (and no private keys). In our example with the selfsigned certificate you need the localhost certificate itself in the truststore in PKCS12 format. Create it by:_  
        `openssl pkcs12 -export -in localhost.crt -nokeys -out localhost.truststore.p12`

## A.2.2 (optional) Java Example

_The code for the Java example is located in the [java_sample](java_sample/) directory._

### What You'll Learn in Scope of this Java Example
_The goal of this short Java example is to demonstrate how you can establish secure connections to a small REST service running on the HTTPS-enabled Apache web server you've just set up. It's important to remember this Apache uses a self-signed certificate for now, and although this does not impair encryption in any way, a self-signed certificate comes with a significant disadvantage: All clients - such as a Java client - have to explicitly trust it by referencing a truststore containing the certificate. This is precisely what we'll do in scope of this example._

### Prerequisites

_For the this Java example, we're going to need a JKS-type truststore (JKS: Java Key Store). Import the self-signed certificate (created above) into such a truststore:_  
_(Stay in the directory where you created `localhost.crt`, probably directly in `/home/vagrant`)_

```bash
~# mkdir ~/material_java_a2
~# keytool -import -file localhost.crt -trustcacerts -keystore ~/material_java_a2/localhost.truststore.jks
```

_The `keytool -import` command will ask you for a password to be set on the new truststore. Make sure to remember this password as you'll need it again soon._

_The other component you're going to need to run this Java example is, of course, an HTTPS-enabled backend the sample code can talk to, which in this case will simply be the Apache web server set up in scope of the preceding steps._

_The given Java example loads the previously created `/home/vagrant/material_java_a2` directory into its classpath and attempts to retrieve a truststore called `localhost.truststore.jks` from there - as you'll notice, that's the name provided for the certificate import command you've just run. So, if you ran the command as-is, the application will work out of the box. If the truststore has a different filename or is stored in a different path, please make sure to adapt the name in the [`src/main/resources/application.properties`](java_sample/src/main/resources/application.properties) file accordingly. Please also verify the truststore password provided in the `application.properties` file matches the password you've set on the _JKS_ truststore._

### Establishing Secure Backend Connections Using a `RestTemplate`
_If you've been using Spring Boot within a micro-service architecture - not too wild a use case, as Spring Boot seems to be rather popular these days with micro-service aficionados, and rightfully so - you may not have come across the necessity yet to make a `RestTemplate` - or any other client-side object able to perform simple, HTTP-based operations against a remote backend, for that matter - establish secure connections with such a backend. This is because in a micro-service architecture, you would normally have some HTTPS-terminating entity in front of your micro-services, so all communication between the latter is exchanged in plain HTTP. There is not much to be done for such use cases - you may just auto-wire a `RestTemplate` bean into your application context and get on with it. Things get a bit more interesting, however, if you actually *do* have to make secure connections._

_In scope of this example, you can find the magic to create an HTTPS-enabled `RestTemplate` in class [`de.tls4developers.examples.exercisea2.HttpsEnabledRestTemplateConfiguration`](java_sample/src/main/java/de/tls4developers/examples/exercisea2/HttpsEnabledRestTemplateConfiguration.java). Our previously created truststore is made available here through the `http.client.ssl.trust-store` property. As you can see in the source code of the `HttpsEnabledRestTemplateConfiguration` class, an `SSLContextBuilder` is invoked to load our truststore into an `SSLContext` object. The `SSLContextBuilder` offers two methods able to load _JKS_ files - or any common type of keystores and truststores - namely, `loadTrustMaterial` and `loadKeyMaterial`. These two methods may seem very similar on first glance, but serve two distinctly different purposes, so it's important to point out which method is used for what in light of the difference between keystores and truststores:_

   * _A keystore - or_ key material, _more generally speaking - is used for purposes such as authentication and data integrity. To fulfil this purpose, a_ key entry _consists of an entity's identity and its private key. Typically, an entity uses a keystore whenever it wants to assert its identity to another entity. Therefore, keystores are most often used on the server side, but can also be found on the client side if a server requests client-side authentication (means: As a client you need to use a client certificate). So, you'll want to use the `loadKeyMaterial` method whenever you want your program to assert its identity to another entity._
   * _A truststore, on the other hand, is a store used to make decisions about whom or what to trust. Therefore, a truststore typically stores (server or CA) certificates to establish a well-defined set of entities the client using that store can safely trust. Hence, you'll want to make use of the `loadTrustMaterial` method whenever you want your program to trust another entity that would otherwise not be trusted._

_In this case, we want our program to explicitly trust the HTTPS-enabled Apache web server and therefore have to employ the `loadTrustMaterial` method - if we didn't invoke this method to load our truststore, the web server would not be trusted because it uses a self-signed certificate (i. e. a certificate not signed by a CA for which trust is established using Java's default truststore)._

### Running the Application and Verifying Expected Behavior

_You can run the Java sample application using the following command:_

```bash
~# mvn -f /vagrant/exercises/A2/java_sample/pom.xml spring-boot:run
```

_(If you can now observe Maven downloading what feels like approximately half the Internet, don't worry - that's perfectly normal.)_

_Once the application has started, on a new terminal session (within your Vagrant Box), run the following command:_

```bash
~# curl http://localhost:12080
```
_or point the browser (at your workstation) to http://localhost:12080 (we provided a port forwarding into the Vagrant Box for you.)_

_This will trigger a small piece of functionality in the application to attempt a call to_ https://localhost:12443/services/weatherinfos, _invoking a small REST service provided to simulate the invocation of a real-world backend service. This call will only be successful if the truststore has been set up correctly and has been provided to the application's `RestTemplate` (and, of course, if the local HTTPS-enabled Apache is actually listening on that port). The expected behavior is that success of establishing a secure connection to said Apache is indicated like so (your output may be slightly different depending on your current weekday, but the point is you see some output like the following in the first place):_

```bash
~# curl http://localhost:12080
{
    "meta": {
        "origin": "weatherinfo service of exercise A2"
    },
    "data": {
        "day": "Monday",
        "current_weather": "On Mondays the weather around here is always fine",
        "forecast": "Tomorrow it might be even better"
    }
}
```

## A.2.3 Conclusion

   * It works now completely without any certificate warning. Exactly the same way it would work if we used a FQDN in the URL as well as in the CN of the certificate.
   * __Learning:__ Selfsigned certificates are not less secure than certificates signed by an official CA. Encryption is fully in place.
   * __Drawback:__ It's not practical anyway! If you wanted to deal with selfsigned certificates in the real world, you would need to make sure the certificate of your server is included in the truststore of every client connecting to it.  
   For example, consider our simple Java client: Providing it with access to the truststore and managing that truststore (for example, replacing it once the contained certificate expires) does not seem like too much of a burden if you only have one client and if that client shares its machine with the server it wants to make connections to. But what if you had, say, 1.000 clients? Or 10.000? Now further imagine each client ran on its very own machine and you had to log in to each of them to manually replace your self-signed certificate - good bye, sanity! Automating such tasks could obviously mitigate that effort, but the real solution lies elsewhere and you'll get introduced to it in scope of the upcoming exercises.
