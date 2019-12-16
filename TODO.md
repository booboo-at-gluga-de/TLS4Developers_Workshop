# ToDo's within this Project

   * expiring certificates / renewal / monitoring
       * HTTPS: check_http -H exercise.jumpingcrab.com -p 443 --ssl --sni --certificate=21
       * IMAPS: check_imap -H $HOSTADDRESS$ -p 993 -S --certificate=21
       * SMTP + starttls: check_smtp -H $HOSTADDRESS$ --starttls --certificate=21
       * Client certificates: check_ssl_cert -H localhost -f /path/to/cert.pem --warning 30
         see https://github.com/matteocorti/check_ssl_cert
       * plus regression tests
