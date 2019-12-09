# ToDo's within this Project

   * expiring certificates / renewal / monitoring
       * HTTPS: check_http -H exercise.jumpingcrab.com -p 443 --ssl --sni --certificate=21
       * IMAPS: check_imap -H $HOSTADDRESS$ -p 993 -S --certificate=21
       * SMTP + starttls: check_smtp -H $HOSTADDRESS$ --starttls --certificate=21
       * Client certificates: check_ssl_cert -H localhost -f /path/to/cert.pem --warning 30
         see https://github.com/matteocorti/check_ssl_cert
       * plus regression tests
   * Exercise B3: Example on how to check a certificate against a CRL (plus regression test for this)
       ~# openssl verify -untrusted /tmp/github.com.chain.pem /tmp/github.com.pem
       /tmp/github.com.pem: OK
       ~# openssl verify -crl_check -CRLfile /tmp/crl.for.github.com.crl.pem -untrusted /tmp/github.com.chain.pem /tmp/github.com.pem
       /tmp/github.com.pem: OK
       ~# openssl verify -crl_check_all -CRLfile /tmp/crl.for.github.com.crl.pem -CRLfile /tmp/crl.for.github.com.chain.crl.pem -untrusted /tmp/github.com.chain.pem /tmp/github.com.pem
       /tmp/github.com.pem: OK
