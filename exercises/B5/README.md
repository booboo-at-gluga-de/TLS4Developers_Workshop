# Exercise B.5: Expiring Certificates / Monitoring

## Objective

In this exercise you will learn why a monitoring for the expiration of certificates is important and how to setup a solid certificate expiration monitoring.


## Why to Set Up Certificate Expiration Monitoring

All x.509 certificates have a limited validity period. After expiration they are not accepted by your peers any longer.  
If the client is a browser or an other client application on the user's workstation, a certificate warning is displayed. Uncertainty at the user is the consequence - ugly enough.

If the certificate is used in a server-to-server communication (e. g. web application is calling a HTTPS webservice) usually the communication immediatelly stops working and an error is thrown instead.

The nasty thing about this is: It happens within a second. While in the one moment everything is still working completly without problems, in the next moment you might face a complete outage! So better be prepared!

The golden rule here is: __When ever you use a certificate somewhere, add an according monitoring for expiration!__


## Steps

In this exercise we assume you have some monitoring system in place which is capable of using Nagios compatible check plugins. (If not: find out how to set up something similar in your monitoring system.)

Checking server certificates for expiration is best done by connecting to the server and checking the certificate it presents. This has one big advantage: If renewal of the certificate was successful, but there was no restart of the service, it probably still will use the old certificate. You want an alert in this situation too. (The information about certificate renewal (only) being successful is not sufficient.)

All the checks shown here can be done with the default Nagios plugins found as package in your distribution or at https://www.nagios.org/downloads/nagios-plugins/

   * Checkking a HTTPS server can be done by:  
     ```Bash
     ~# check_http -H $HOSTADDRESS$ -p 443 --ssl --sni --certificate=21
     ```  
     This way you would get an alert 21 days before expiration of the server certificate.  
     `$HOSTADDRESS$` in Nagios & Co. refers to the IP address of the host the check is assosiated to.  
     To issue the check on command line you might use something like:  
     ```Bash
     ~# /usr/lib64/nagios/plugins/check_http -H exercise.jumpingcrab.com -p 21443 --ssl --sni --certificate=21
     SSL WARNING - Certificate 'exercise.jumpingcrab.com' expires in 4 day(s) (2019-12-23 19:29 +0000/UTC).
     ```
   * Something very similar can be done for IMAPS servers:  
     ```Bash
     ~# check_imap -H $HOSTADDRESS$ -p 993 -S --certificate=21
     ```
   * If you have a service like SMTP which uses `starttls` for checking you need something like: 
     ```Bash
     ~# check_smtp -H $HOSTADDRESS$ --starttls --certificate=21
     ```  
     If you are not familiar with `starttls`, short explanation: The client connects to the server in clear text. Within the connection the client sends a `starttls` command and they can agree on continuing the conversation encrypted.

For client certificates there is no easy way for monitoring them "in use". So the only reasonable way for doing expiration checks is issuing the checks against the certificate file in the filesystem at the machine using the certificate.

   * A check plugin capable doing such a check unfortunatelly is not part of the default Nagios plugins package but can be found at https://github.com/matteocorti/check_ssl_cert  
     In our Vagrant box it is already available. In all other cases please download the check plugin and make it executable:  
     ```Bash
     ~# sudo wget -O /usr/local/bin/check_ssl_cert https://raw.githubusercontent.com/matteocorti/check_ssl_cert/master/check_ssl_cert
     ~# sudo chmod 755 /usr/local/bin/check_ssl_cert
     ```
   * Now you can test the check:  
     ```Bash
     ~# /usr/local/bin/check_ssl_cert -H localhost -f ~/client.crt --warning 21
     SSL_CERT OK - x509 certificate 'User Hans Wurst' from 'Raffzahn CA' valid until Dec 15 13:47:24 2020 GMT (expires in 362 days)|days=362;21;;;
     ```

## Conclusion

You made it up to here! Congratulations! We hope your new gained knowledge will be helpful for you! Enjoy the additional security!
