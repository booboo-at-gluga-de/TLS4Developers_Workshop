# Exercise A.6: Setting up an HTTPS-Enabled Spring Boot Application

## Disclaimer

This exercise is entirely optional -- the upcoming exercises of this workshop will neither require the results of this exercise nor an understanding of the concepts taught therein.

## Objective
The preceding exercises A2 and A4 involved a Spring Boot application establishing connections to a small demo REST service running on an HTTPS-enabled Apache server, meaning the Spring Boot applications have acted as clients. During this exercise, on the other hand, you'll learn how to set up a Spring Boot application acting as an HTTPS-enabled backend. 

In the real world, such a setup is commonly encountered in the context of Spring-Boot based API gateways that act as SSL termination entities (rather than a dedicated web server) that might then pass on requests to some application landscape (think, for example, of a set of micro services) or even orchestrate processing flow.

## Prerequisites
As we'll reuse the self-signed certificate from exercise A2, it's advisable you do that exercise first (hint: the creation of the private key will ask you for a password -- please write it down somewhere because you'll need it again a bit further down the line). As soon as you've created the self-signed certificate and its private key in scope of exercise A2, you'll want to put both of them into a new keystore (in fact, that's an optional step in said exercise, so if you have already done that step, feel free to skip ahead):
```Bash
~# openssl pkcs12 -export -in localhost.crt -inkey localhost.key -out localhost.keystore.p12
```
(This command assumes you're operating from the `/home/vagrant` directory.)

The above command will ask you for a password to be set for the new keystore. Please make sure to write down or otherwise remember that password, as our application will need it to retrieve the keystore contents a bit later on.

Putting both, the certificate as well as its private key, into a keystore makes sense since we want to establish a secure application that clients can trust, and hence, the application requires key material to present to a client rather than merely trust material (for an explanation of the characteristics of and differences between trust and key material, please refer to [this section](../A2#establishing-secure-backend-connections-using-a-resttemplate) of the Java example for exercise A2).

Finally, create a new folder for our application to retrieve the keystore from and place the keystore there:
```Bash
~# mkdir ~/material_java_a6
~# mv localhost.keystore.p12 ~/material_java_a6
```
Similarly to the Java examples for exercises A2 and A4, the application will add the contents of this directory to its classpath and attempt to load a file called `localhost.keystore.p12` from it. So, if you've run the above commands as provided there, the application will work as-is, but if your keystore is called differently, please make sure to update the relevant line within the `src/main/resources/application.properties` file. Please also verify this file contains the correct passwords for your keystore and the private key it contains (properties `server.ssl.key-store-password` and `server.ssl.key-password`, respectively).

## Securing our Application's Endpoints
For the sake of this example, our application will expose a dummy REST endpoint that, upon being queried, produces a simple JSON-formatted greeting. The good news is securing such endpoints is remarkably simple in Spring Boot -- all we have to do is provide the keystore (which you've already done) and set some properties in the `application.properties` file (or alternatively an `application.yml` file), and Spring Boot's auto-configuration will do its magic for us. The properties in question are as follows:

```Bash
server.port=16443
server.ssl.key-store=classpath:localhost.keystore.p12
server.ssl.key-store-password=test123
server.ssl.key-password=test123
```
The `server.port` property would normally be populated with a more common value like `8443`, but we're sticking to the port numbering scheme of the exercises in this workshop here, according to which the secure port our application will use to listen for incoming requests is `16443`.

This configuration means our application no longer supports a plain HTTP connector because Spring Boot does not support the configuration of both an HTTP and an HTTPS connector by means of the `application.properties` file (though it can be configured programmatically if required).

## Establishing an HTTPS Redirect
Suppose our application exposed an insecure, plain HTTP endpoint that clients already consumed. In this case, establishing an HTTPS redirect might be a more desirable solution than simply shutting down or disabling the insecure endpoint. For the context of our example, we assume the application has exposed a plain HTTP endpoint on port `16080` (again, we're following the workshop port numbering scheme here rather than using a more common value like, say, `8080`), and for this port to be redirected to our secure port (`16443`), we'll have to apply some configuration to Spring Boot's embedded Tomcat server.

The following shows an excerpt from class `de.tls4developers.examples.exercisea6.EmbeddedTomcatConfiguration`:
```Java
SecurityConstraint securityConstraint = new SecurityConstraint();
securityConstraint.setUserConstraint("CONFIDENTIAL");
SecurityCollection securityCollection = new SecurityCollection();
securityCollection.addPattern("/*");
securityConstraint.addCollection(securityCollection);
context.addConstraint(securityConstraint);
``` 
Essentially, we tell Tomcat to treat all URL patterns as confidential, which is expressed in the code through the `securityCollection.addPattern("/*");` and `securityConstraint.setUserConstraint("CONFIDENTIAL");` lines. By combining `SecurityConstraint`s and `SecurityCollection`s, it is possible to exercise more fine-grained control over what's confidential (and should therefore be communicated through HTTPS) and what isn't, but for the sake of this example, we tell Tomcat to simply treat everything as confidential.

Additionally, we have to tell Tomcat which HTTP/-S connectors to employ, which we also do in class `de.tls4developers.examples.exercisea6.EmbeddedTomcatConfiguration`. Here's a short excerpt: 
```Java
connector.setScheme("http");
connector.setPort(16080);
connector.setSecure(false);
connector.setRedirectPort(securePort);
```
Here, we tell Tomcat port `16080` is insecure and it should be redirected to whatever value is contained in the `securePort` variable, which in this case is taken from our `application.properties` file, where it was set to `16443`.

## Verifying Expected Application Behavior
With our application in place, we can now proceed to verify it behaves as expected:
1. Querying `https://localhost:16443/greetings` should yield a certificate error when queried without the client explicitly trusting the self-signed certificate contained in the application's keystore.
1. Repeating the first step with a client configured to explicitly trust the self-signed certificate should result in query success, with a short JSON-formatted greeting from the application's dummy REST endpoint being displayed as response payload.
1. Attempting to invoke the endpoint via plain HTTP (`http://localhost:16080/greetings`) should result in an HTTP redirect response, redirecting clients to port `16443`.

First, launch the Spring Boot application by means of the following command:
```Bash
mvn -f /vagrant/exercises/A6/java_sample/pom.xml spring-boot:run
```
Once the application has started, it will expose the HTTPS-enabled port `16443` for us to query. We can now verify the above expectations one-by-one:

1.  Using `curl` without any additional configuration to query our application yields the following:
    ```Bash
    ~# curl https://localhost:16443/greetings?name=Dave
    curl: (60) SSL certificate problem: self signed certificate
    More details here: https://curl.haxx.se/docs/sslcerts.html

    curl failed to verify the legitimacy of the server and therefore could not
    establish a secure connection to it. To learn more about this situation and
    how to fix it, please visit the web page mentioned above.
    ```
    As expected, because the server we're querying presents a self-signed certificate to our client, the latter cannot verify the former's legitimacy. To fix this, we have to explicitly trust the server's certificate. 
1.  Configuring `curl` to trust the self-signed certificate leads to the following (assuming you run this command from `/home/vagrant`, where the `localhost.crt` file should reside from doing exercise A2):
    ```Bash
    ~# curl --cacert localhost.crt https://localhost:16443/greetings?name=Dave
    {"message":"Hello, Dave!"}
    ```
    So, trusting the certificate, we can successfully query our application's endpoint.
1.  Finally, an attempt to invoke the dummy endpoint through plain HTTP on port `16080` should make the application return a redirect response (HTTP status code `302`) with the `Location` header being populated with the correct URL the client should use instead:
    ```Bash
    ~# curl --verbose http://localhost:16080/greetings?name=Dave
    *   Trying 127.0.0.1...
    * TCP_NODELAY set
    * Connected to localhost (127.0.0.1) port 16080 (#0)
    > GET /greetings?name=Dave HTTP/1.1
    > Host: localhost:16080
    > User-Agent: curl/7.61.1
    > Accept: */*
    > 
    < HTTP/1.1 302 
    < Cache-Control: private
    < Expires: Thu, 01 Jan 1970 00:00:00 GMT
    < Location: https://localhost:16443/greetings?name=Dave
    < Content-Length: 0
    < Date: Tue, 14 Apr 2020 10:54:50 GMT
    < 
    * Connection #0 to host localhost left intact
    ```
    The `--verbose` (or `-V`) flag was used here to reveal the information shown above, and it is visible the response does, in fact, contain the expected `HTTP 302` status code along with the `Location` header being set to `https://localhost:16443/greetings?name=Dave`. If we wanted `curl` to follow that redirect (which it does not do by default), we could make use of its `--location` (or `-L`) flag, but consuming the HTTPS-enabled endpoint, of course, requires the certificate presented there to be explicitly trusted:
    ```Bash
    ~# curl --location --cacert localhost.crt http://localhost:16080/greetings?name=Dave
    {"message":"Hello, Dave!"}
    ```
    
## Conclusion
Establishing an application that exposes its endpoints over HTTPS is remarkably easy in Spring Boot; all we have to do is point the relevant property to the keystore it is supposed to load key material from and tell it the passwords for the keystore itself and for the certificate's private key. Configuring HTTPS redirects is also rather easy, and we can use built-in libraries to assert fine-grained control over what should be redirected to an HTTPS-enabled port and what communication, on the other hand, is alright to go over plain HTTP.


