# Exercise A.5: Useful Commands for Dealing with Certificates

## Objective

In this exercise you will use some commands which are very useful when dealing with certificates and TLS connections in day-to-day live.

## Prerequisites

   * You need to complete [Exercise A.3](../A3/) before starting this one.  
     Background is: You will need a certificate and a HTTPS host to be used with the commands below.

## Useful Commands

Within the Vagrant setup you might want to do the following steps directly in `/home/vagrant`.

   * Display (in human readable form) a certificate stored in PEM format:  
     ```Bash
     ~# openssl x509 -in server.crt -noout -text
     Certificate:
         Data:
             Version: 3 (0x2)
             Serial Number: 1 (0x1)
         Signature Algorithm: sha256WithRSAEncryption
             Issuer: C=DE, ST=Franconia, L=Nuernberg, O=Raffzahn GmbH, CN=Raffzahn CA/emailAddress=certificates@example.com
             Validity
                 Not Before: Sep 26 16:01:25 2019 GMT
                 Not After : Sep 25 16:01:25 2020 GMT
             Subject: C=DE, ST=Franconia, O=Raffzahn GmbH, CN=localhost/emailAddress=certificates@example.com
             Subject Public Key Info:
                 Public Key Algorithm: rsaEncryption
                     Public-Key: (2048 bit)
                     Modulus:
                         00:c1:33:a9:a4:cc:ea:65:8a:da:62:0f:f1:df:78:
                         38:97:02:ca:2c:64:05:ae:32:63:a4:de:b9:a5:04:
                         40:3b:d2:0c:6b:09:97:c7:96:79:18:32:1b:9c:e8:
                         d5:99:6b:a2:c1:23:6c:39:be:27:7c:7c:82:70:e3:
                         10:dc:3c:1d:8a:77:cf:ec:78:84:34:e2:2f:7f:df:
                         55:bf:55:04:7c:1d:9d:39:6b:b1:89:50:cb:16:01:
                         e5:0e:19:c4:31:19:71:9e:28:fd:ff:49:ee:75:42:
                         54:55:a4:2e:53:f0:bb:6a:d8:f8:5c:d8:37:b5:2e:
                         eb:36:7b:ab:a6:fd:c7:9b:1a:a8:c1:87:b7:9c:01:
                         08:03:7f:b6:39:f2:4c:8f:c1:5f:63:81:b7:62:66:
                         7c:e7:05:e9:27:c2:8b:75:a8:88:d2:fe:c7:bd:43:
                         cb:80:2c:15:4f:da:b8:c1:4b:09:5b:c6:bb:fd:e9:
                         6e:12:bb:1f:29:bc:5e:37:45:ac:ef:83:05:49:0f:
                         7e:6f:56:a1:44:ba:97:c1:29:46:7c:91:76:bd:15:
                         62:97:7a:17:31:78:a7:f0:66:e6:7d:2b:89:77:81:
                         4c:28:73:02:37:57:3c:87:fc:39:8c:5d:9d:bc:f4:
                         2c:b6:37:19:d3:66:75:c5:8e:ca:3f:47:f4:39:5a:
                         78:15
                     Exponent: 65537 (0x10001)
             X509v3 extensions:
                 X509v3 Basic Constraints: 
                     CA:FALSE
                 Netscape Cert Type: 
                     SSL Server
                 Netscape Comment: 
                     OpenSSL Generated Server Certificate
                 X509v3 Subject Key Identifier: 
                     8D:DD:63:5F:83:58:C7:F5:CB:8A:8A:18:73:A0:68:75:81:69:DC:CB
                 X509v3 Authority Key Identifier: 
                     keyid:96:62:6C:81:2B:1E:4C:62:0D:3A:C1:E2:29:15:C6:54:FD:75:4E:92
                     DirName:/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=Raffzahn CA/emailAddress=certificates@example.com
                     serial:C0:D3:BA:43:9C:CE:B1:2B

                 X509v3 Key Usage: critical
                     Digital Signature, Key Encipherment
                 X509v3 Extended Key Usage: 
                     TLS Web Server Authentication
         Signature Algorithm: sha256WithRSAEncryption
              08:f4:93:a9:1d:a1:f0:13:71:8c:1a:9e:fb:33:5e:53:b6:9f:
              cb:67:21:73:dc:24:6b:4e:24:e6:83:1d:95:4f:75:ad:c8:73:
              12:35:6a:de:63:47:32:bf:02:c7:d8:17:e5:7c:7d:43:b3:4e:
              d6:f3:8d:bb:02:05:18:0e:55:ea:df:9d:d0:67:9a:69:d9:66:
              76:d4:cf:85:fc:95:b3:74:b5:0b:1a:95:0b:4d:c8:29:12:c8:
              ed:b9:ae:94:31:7b:0c:2b:80:2b:41:c2:fc:d3:53:37:00:b3:
              ce:e8:0a:09:9a:bd:a8:00:63:87:8c:52:28:97:d0:cd:df:df:
              f7:ab:fb:69:19:73:40:01:f6:84:f4:8c:6f:70:37:7b:65:3d:
              1b:f7:f7:c6:d0:63:b7:90:7f:31:5f:e0:1c:00:f7:53:f4:cf:
              ad:8b:96:26:0d:70:df:d3:e4:85:f1:b8:66:06:be:6c:7e:c2:
              6c:73:25:fe:c1:c5:eb:26:1b:a6:1f:23:e9:c9:3e:2e:92:c1:
              78:65:39:11:0d:57:48:75:b1:af:1a:f5:d9:ee:1c:f4:40:34:
              eb:d3:e3:c3:48:9b:61:26:8b:4a:ad:a1:29:92:00:8e:2b:f9:
              fa:09:b7:e6:1a:de:b9:60:f6:ac:44:f8:0a:84:5d:32:51:f5:
              d9:23:96:c8:a1:fd:c7:fd:fa:c1:f3:d9:e0:81:93:99:22:e8:
              56:82:3a:1b:ac:f1:a9:b6:bf:80:2e:4c:15:e9:ac:97:5f:e6:
              a5:09:e7:4b:27:89:c0:bf:53:2f:ee:31:aa:24:b1:65:41:9f:
              b2:d7:a3:cd:48:ea:e7:1a:00:89:86:1b:08:66:78:3c:a0:a8:
              1c:89:bd:b2:66:fb:96:0a:b5:ed:30:3f:87:dd:0d:2c:7b:04:
              fa:7a:b8:7a:e5:e1:e3:0a:e0:51:67:58:8a:9f:29:1e:41:23:
              27:cf:6c:2b:25:90:a7:4a:e0:b3:bb:5e:2f:01:e0:65:89:d6:
              15:b2:e9:9c:75:79:38:d3:b0:8d:62:09:bb:18:8e:e5:8e:e1:
              ed:fe:c8:ca:55:13:eb:a6:7e:14:01:18:96:0d:2b:3e:1a:97:
              e6:77:75:b3:1b:ef:b0:a4:d0:2b:07:d0:f5:43:04:ef:fb:d8:
              ba:80:42:c4:ca:24:20:a2:4a:92:4f:dd:48:24:5c:78:bc:59:
              b0:59:31:26:8d:95:82:b3:b2:c3:44:b9:04:be:ed:16:a8:ae:
              09:94:a3:93:dc:6b:e2:28:8c:d0:e7:e3:78:d6:23:ac:77:dd:
              ab:4a:92:49:64:5a:b8:b7:6d:0a:b0:63:05:19:6a:2a:3d:7b:
              07:51:df:af:e0:9f:3e:a1
     ```

   * Display the content of a certificate signing request (CSR):  
     ```Bash
     ~# openssl req -in server.csr -noout -text
     Certificate Request:
         Data:
             Version: 0 (0x0)
             Subject: C=DE, ST=Franconia, L=Nuernberg, O=Raffzahn GmbH, CN=localhost/emailAddress=certificates@example.com
             Subject Public Key Info:
                 Public Key Algorithm: rsaEncryption
                     Public-Key: (2048 bit)
                     Modulus:
                         00:c1:33:a9:a4:cc:ea:65:8a:da:62:0f:f1:df:78:
                         38:97:02:ca:2c:64:05:ae:32:63:a4:de:b9:a5:04:
                         40:3b:d2:0c:6b:09:97:c7:96:79:18:32:1b:9c:e8:
                         d5:99:6b:a2:c1:23:6c:39:be:27:7c:7c:82:70:e3:
                         10:dc:3c:1d:8a:77:cf:ec:78:84:34:e2:2f:7f:df:
                         55:bf:55:04:7c:1d:9d:39:6b:b1:89:50:cb:16:01:
                         e5:0e:19:c4:31:19:71:9e:28:fd:ff:49:ee:75:42:
                         54:55:a4:2e:53:f0:bb:6a:d8:f8:5c:d8:37:b5:2e:
                         eb:36:7b:ab:a6:fd:c7:9b:1a:a8:c1:87:b7:9c:01:
                         08:03:7f:b6:39:f2:4c:8f:c1:5f:63:81:b7:62:66:
                         7c:e7:05:e9:27:c2:8b:75:a8:88:d2:fe:c7:bd:43:
                         cb:80:2c:15:4f:da:b8:c1:4b:09:5b:c6:bb:fd:e9:
                         6e:12:bb:1f:29:bc:5e:37:45:ac:ef:83:05:49:0f:
                         7e:6f:56:a1:44:ba:97:c1:29:46:7c:91:76:bd:15:
                         62:97:7a:17:31:78:a7:f0:66:e6:7d:2b:89:77:81:
                         4c:28:73:02:37:57:3c:87:fc:39:8c:5d:9d:bc:f4:
                         2c:b6:37:19:d3:66:75:c5:8e:ca:3f:47:f4:39:5a:
                         78:15
                     Exponent: 65537 (0x10001)
             Attributes:
                 a0:00
         Signature Algorithm: sha256WithRSAEncryption
              69:dd:4c:03:d2:73:e8:c4:85:5b:4e:17:a0:9e:49:63:19:cf:
              7d:c2:97:c8:2e:03:3d:c0:62:f2:f4:6f:a0:bb:fa:58:91:c5:
              1b:85:8b:e9:a7:bb:43:6d:82:bd:de:bd:6b:61:39:96:2e:91:
              87:97:c9:f8:cb:47:94:52:1c:e9:08:cb:21:98:75:d0:c9:91:
              ed:89:33:1c:45:86:2e:77:66:c8:e8:7f:ae:f7:f0:f3:79:07:
              68:c7:6b:a4:d2:bc:4d:01:e3:dc:2a:90:57:11:0f:1f:d3:52:
              f6:38:2c:c3:08:4d:0f:f2:a0:96:de:1a:85:a3:91:98:82:61:
              de:6d:e1:7b:74:68:b7:32:43:9d:b1:2e:d3:27:7c:32:88:c6:
              b3:95:6c:29:09:84:07:be:97:9c:fe:3d:b5:d9:70:64:46:c4:
              9f:3f:56:f8:c6:9c:fe:54:b9:b2:c2:5d:0c:ad:4d:24:82:89:
              9e:94:66:e3:69:f3:80:57:0c:92:d5:3d:cb:96:86:8b:25:d6:
              76:49:e2:74:62:3b:b8:06:b9:cf:7e:b8:90:42:43:a9:b1:d2:
              d5:a3:7f:24:ea:0f:b5:3f:0f:54:c8:de:52:0d:34:b1:f6:a8:
              17:92:4f:47:0e:8c:36:90:d4:0b:91:55:5d:5a:1a:4b:90:8d:
              5e:be:dc:5a
     ```

     * Display the content of a keystore in PKCS12 format:  
       (You will need the password you did set when creating the keystore.)  
     ```Bash
     ~# openssl pkcs12 -in server.keystore.p12 -nodes
     Enter Import Password:
     MAC verified OK
     Bag Attributes
         localKeyID: 35 6A 75 14 93 71 69 E7 77 7A 60 5C 86 B8 DF E0 DA 59 B6 AF 
     subject=/C=DE/ST=Franconia/O=Raffzahn GmbH/CN=localhost/emailAddress=certificates@example.com
     issuer=/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=Raffzahn CA/emailAddress=certificates@example.com
     -----BEGIN CERTIFICATE-----
     MIIF3zCCA8egAwIBAgIBATANBgkqhkiG9w0BAQsFADCBjDELMAkGA1UEBhMCREUx
     EjAQBgNVBAgMCUZyYW5jb25pYTESMBAGA1UEBwwJTnVlcm5iZXJnMRYwFAYDVQQK
     DA1SYWZmemFobiBHbWJIMRQwEgYDVQQDDAtSYWZmemFobiBDQTEnMCUGCSqGSIb3
     DQEJARYYY2VydGlmaWNhdGVzQGV4YW1wbGUuY29tMB4XDTE5MDkyNjE2MDEyNVoX
     DTIwMDkyNTE2MDEyNVowdjELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZyYW5jb25p
     YTEWMBQGA1UECgwNUmFmZnphaG4gR21iSDESMBAGA1UEAwwJbG9jYWxob3N0MScw
     JQYJKoZIhvcNAQkBFhhjZXJ0aWZpY2F0ZXNAZXhhbXBsZS5jb20wggEiMA0GCSqG
     SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBM6mkzOplitpiD/HfeDiXAsosZAWuMmOk
     3rmlBEA70gxrCZfHlnkYMhuc6NWZa6LBI2w5vid8fIJw4xDcPB2Kd8/seIQ04i9/
     31W/VQR8HZ05a7GJUMsWAeUOGcQxGXGeKP3/Se51QlRVpC5T8Ltq2Phc2De1Lus2
     e6um/cebGqjBh7ecAQgDf7Y58kyPwV9jgbdiZnznBeknwot1qIjS/se9Q8uALBVP
     2rjBSwlbxrv96W4Sux8pvF43RazvgwVJD35vVqFEupfBKUZ8kXa9FWKXehcxeKfw
     ZuZ9K4l3gUwocwI3VzyH/DmMXZ289Cy2NxnTZnXFjso/R/Q5WngVAgMBAAGjggFf
     MIIBWzAJBgNVHRMEAjAAMBEGCWCGSAGG+EIBAQQEAwIGQDAzBglghkgBhvhCAQ0E
     JhYkT3BlblNTTCBHZW5lcmF0ZWQgU2VydmVyIENlcnRpZmljYXRlMB0GA1UdDgQW
     BBSN3WNfg1jH9cuKihhzoGh1gWncyzCBwQYDVR0jBIG5MIG2gBSWYmyBKx5MYg06
     weIpFcZU/XVOkqGBkqSBjzCBjDELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZyYW5j
     b25pYTESMBAGA1UEBwwJTnVlcm5iZXJnMRYwFAYDVQQKDA1SYWZmemFobiBHbWJI
     MRQwEgYDVQQDDAtSYWZmemFobiBDQTEnMCUGCSqGSIb3DQEJARYYY2VydGlmaWNh
     dGVzQGV4YW1wbGUuY29tggkAwNO6Q5zOsSswDgYDVR0PAQH/BAQDAgWgMBMGA1Ud
     JQQMMAoGCCsGAQUFBwMBMA0GCSqGSIb3DQEBCwUAA4ICAQAI9JOpHaHwE3GMGp77
     M15Ttp/LZyFz3CRrTiTmgx2VT3WtyHMSNWreY0cyvwLH2BflfH1Ds07W8427AgUY
     DlXq353QZ5pp2WZ21M+F/JWzdLULGpULTcgpEsjtua6UMXsMK4ArQcL801M3ALPO
     6AoJmr2oAGOHjFIol9DN39/3q/tpGXNAAfaE9IxvcDd7ZT0b9/fG0GO3kH8xX+Ac
     APdT9M+ti5YmDXDf0+SF8bhmBr5sfsJscyX+wcXrJhumHyPpyT4uksF4ZTkRDVdI
     dbGvGvXZ7hz0QDTr0+PDSJthJotKraEpkgCOK/n6CbfmGt65YPasRPgKhF0yUfXZ
     I5bIof3H/frB89nggZOZIuhWgjobrPGptr+ALkwV6ayXX+alCedLJ4nAv1Mv7jGq
     JLFlQZ+y16PNSOrnGgCJhhsIZng8oKgcib2yZvuWCrXtMD+H3Q0sewT6erh65eHj
     CuBRZ1iKnykeQSMnz2wrJZCnSuCzu14vAeBlidYVsumcdXk407CNYgm7GI7ljuHt
     /sjKVRPrpn4UARiWDSs+Gpfmd3WzG++wpNArB9D1QwTv+9i6gELEyiQgokqST91I
     JFx4vFmwWTEmjZWCs7LDRLkEvu0WqK4JlKOT3GviKIzQ5+N41iOsd92rSpJJZFq4
     t20KsGMFGWoqPXsHUd+v4J8+oQ==
     -----END CERTIFICATE-----
     Bag Attributes
         localKeyID: 35 6A 75 14 93 71 69 E7 77 7A 60 5C 86 B8 DF E0 DA 59 B6 AF 
     Key Attributes: <No Attributes>
     -----BEGIN PRIVATE KEY-----
     MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDBM6mkzOplitpi
     D/HfeDiXAsosZAWuMmOk3rmlBEA70gxrCZfHlnkYMhuc6NWZa6LBI2w5vid8fIJw
     4xDcPB2Kd8/seIQ04i9/31W/VQR8HZ05a7GJUMsWAeUOGcQxGXGeKP3/Se51QlRV
     pC5T8Ltq2Phc2De1Lus2e6um/cebGqjBh7ecAQgDf7Y58kyPwV9jgbdiZnznBekn
     wot1qIjS/se9Q8uALBVP2rjBSwlbxrv96W4Sux8pvF43RazvgwVJD35vVqFEupfB
     KUZ8kXa9FWKXehcxeKfwZuZ9K4l3gUwocwI3VzyH/DmMXZ289Cy2NxnTZnXFjso/
     R/Q5WngVAgMBAAECggEAAy/P94jtwNkGeyGaMr5v6IXCQfMwaMwp+pk15LPqP1Ja
     pBVXbJJd0vlYnUD17P7qg1cLPPSXACWpnSURrSBMuHD7fAIM5DZq5CgR6QME/Osc
     IctV9Vbg0q8bUR05sDmkNyCj9+cHSOXcMEFyBi5tWPjVN+rVGGb6uD5X+XwsI7HI
     ikl2TDhLoJNwkrlzOLPhn5JOfYsotGk4ZdIE9ZQFSGZOC9z33sXk4tm7LhFRblDn
     Lp6L7oxtezNImDJoQ5LcQvGCjcCexhb8R1XGuMrqcm8MwH99tj77t2dzIO8vfTVF
     Z1IWUBRpMZs8tyfs+zF4arG5k3Djbr1TYjbZZpanjQKBgQDim0ngnL2NS8jtAR16
     9WtRjpt5uuIvoFLT6CX55pxcg/d5BLFZTI6VabxnrUl5//IkIY3gUrTAiFrbjdjs
     DGFmpWmvPFcnlDyv6grth5gd3z+6QikOMe4TIqfjoduTeoXKrhek5C1MeMMYAtAD
     xlQaABzg7fb7Vrr75Bg1rHAx7wKBgQDaQyH+YlmKJCkiOgKJkvhvDnZyvK02aBvN
     PwoH034dhsdC1x47Ujh1ihZB+C4zUsCVIc86IYI34WCcmRV+0dBuI1i50s8KN4jy
     5RPp/dJzx+4Be9w7+e4NudBo1Y3oKNm7mFEIB+vToyHYvbzut0m6Gj4nkbqUVYuM
     J/qNME5qOwKBgGjqqwbSqzRrPSj2VjbiwABvvW5b53NTkGXKWyLb8dMnyoF+ebo1
     puJopTF/WsCgjvTJkE2nHUbzGtYCU8feZ45F0auvjU6m5H4yJ0MYf4Z9IZ1UGnwX
     A/paFk9fVjFvDdjsR8gxWQPJ+dH5I2RMBA5RtQ0zQCHYYxRS5B6dqwiDAoGAfAC8
     JXzXBkb5H7r5ihP4FZCP9yv+9PQ9J2TzW/LqqffS6cSyJl3WOeFUN/K6vOn9BD2L
     MKmtA/aGHzJSJhUqaAio9hoxCsr2gZlosP5GPQWP0UP/ogujFiVFpOn/j7D100D8
     eKWXdEwwhKV32+BCgPs76NtAt9nKSLzF+sVBJ9UCgYEAgmyhgOktmA+XAXL8a5W8
     RrBojg23dujFWPKanZtQxPNuUGiEW+ZNz+B4lXr5vKMkD3qGsJ4LUl3qxp4C1oNA
     aBCapM9XDRh9zfw1CC/NN3gIoA3QW1kMGiQR2KS+1RDgga9QFHq7xvoUNvxuo32j
     Vs5Kc1bpBrNG3yR3OV5TjJg=
     -----END PRIVATE KEY-----
     ```
     If you need more information on the certificate: Put the block from `-----BEGIN CERTIFICATE-----` to `-----END CERTIFICATE-----' (including these lines) into a separate file and use the command for PEM files (see above).

   * You might also find the script [show_ssl_file.sh](https://github.com/booboo-at-gluga-de/booboo-quick-ca/blob/master/bin/show_ssl_file.sh) useful. For several types of TLS related files (certificates in different formats, CSRs, CRLs, keystores, ...) it tries to find out what type it is and to display it's content.

   * Verify a certificate (in PEM format) against a given CA certificate:  
     ```Bash
     ~# openssl verify -CAfile ca/cacert.pem server.crt 
     server.crt: OK
     ```

   * Connect to some TLS enabled service (HTTPS, SMTPS, IMAPS, ...) and see what happens during the TLS handshake.  
      - This is very useful for debugging TLS connection issues.
      - It can also be used to retrieve the current certificate of a server you do not have Shell or filesystem access to.
      - If you are interested in the TLS handshake only (and do not want to interact with the server application itself on layer 7) you can press `Ctrl-C` as soon as the handshake is complete and you see the final line with the 3 dashes
     ```Bash
     ~# openssl s_client -connect localhost:13443
     CONNECTED(00000003)
     depth=0 C = DE, ST = Franconia, O = Raffzahn GmbH, CN = localhost, emailAddress = certificates@example.com
     verify error:num=20:unable to get local issuer certificate
     verify return:1
     depth=0 C = DE, ST = Franconia, O = Raffzahn GmbH, CN = localhost, emailAddress = certificates@example.com
     verify error:num=21:unable to verify the first certificate
     verify return:1
     ---
     Certificate chain
      0 s:/C=DE/ST=Franconia/O=Raffzahn GmbH/CN=localhost/emailAddress=certificates@example.com
        i:/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=Raffzahn CA/emailAddress=certificates@example.com
     ---
     Server certificate
     -----BEGIN CERTIFICATE-----
     MIIF3zCCA8egAwIBAgIBATANBgkqhkiG9w0BAQsFADCBjDELMAkGA1UEBhMCREUx
     EjAQBgNVBAgMCUZyYW5jb25pYTESMBAGA1UEBwwJTnVlcm5iZXJnMRYwFAYDVQQK
     DA1SYWZmemFobiBHbWJIMRQwEgYDVQQDDAtSYWZmemFobiBDQTEnMCUGCSqGSIb3
     DQEJARYYY2VydGlmaWNhdGVzQGV4YW1wbGUuY29tMB4XDTE5MDkyNjE2MDEyNVoX
     DTIwMDkyNTE2MDEyNVowdjELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZyYW5jb25p
     YTEWMBQGA1UECgwNUmFmZnphaG4gR21iSDESMBAGA1UEAwwJbG9jYWxob3N0MScw
     JQYJKoZIhvcNAQkBFhhjZXJ0aWZpY2F0ZXNAZXhhbXBsZS5jb20wggEiMA0GCSqG
     SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBM6mkzOplitpiD/HfeDiXAsosZAWuMmOk
     3rmlBEA70gxrCZfHlnkYMhuc6NWZa6LBI2w5vid8fIJw4xDcPB2Kd8/seIQ04i9/
     31W/VQR8HZ05a7GJUMsWAeUOGcQxGXGeKP3/Se51QlRVpC5T8Ltq2Phc2De1Lus2
     e6um/cebGqjBh7ecAQgDf7Y58kyPwV9jgbdiZnznBeknwot1qIjS/se9Q8uALBVP
     2rjBSwlbxrv96W4Sux8pvF43RazvgwVJD35vVqFEupfBKUZ8kXa9FWKXehcxeKfw
     ZuZ9K4l3gUwocwI3VzyH/DmMXZ289Cy2NxnTZnXFjso/R/Q5WngVAgMBAAGjggFf
     MIIBWzAJBgNVHRMEAjAAMBEGCWCGSAGG+EIBAQQEAwIGQDAzBglghkgBhvhCAQ0E
     JhYkT3BlblNTTCBHZW5lcmF0ZWQgU2VydmVyIENlcnRpZmljYXRlMB0GA1UdDgQW
     BBSN3WNfg1jH9cuKihhzoGh1gWncyzCBwQYDVR0jBIG5MIG2gBSWYmyBKx5MYg06
     weIpFcZU/XVOkqGBkqSBjzCBjDELMAkGA1UEBhMCREUxEjAQBgNVBAgMCUZyYW5j
     b25pYTESMBAGA1UEBwwJTnVlcm5iZXJnMRYwFAYDVQQKDA1SYWZmemFobiBHbWJI
     MRQwEgYDVQQDDAtSYWZmemFobiBDQTEnMCUGCSqGSIb3DQEJARYYY2VydGlmaWNh
     dGVzQGV4YW1wbGUuY29tggkAwNO6Q5zOsSswDgYDVR0PAQH/BAQDAgWgMBMGA1Ud
     JQQMMAoGCCsGAQUFBwMBMA0GCSqGSIb3DQEBCwUAA4ICAQAI9JOpHaHwE3GMGp77
     M15Ttp/LZyFz3CRrTiTmgx2VT3WtyHMSNWreY0cyvwLH2BflfH1Ds07W8427AgUY
     DlXq353QZ5pp2WZ21M+F/JWzdLULGpULTcgpEsjtua6UMXsMK4ArQcL801M3ALPO
     6AoJmr2oAGOHjFIol9DN39/3q/tpGXNAAfaE9IxvcDd7ZT0b9/fG0GO3kH8xX+Ac
     APdT9M+ti5YmDXDf0+SF8bhmBr5sfsJscyX+wcXrJhumHyPpyT4uksF4ZTkRDVdI
     dbGvGvXZ7hz0QDTr0+PDSJthJotKraEpkgCOK/n6CbfmGt65YPasRPgKhF0yUfXZ
     I5bIof3H/frB89nggZOZIuhWgjobrPGptr+ALkwV6ayXX+alCedLJ4nAv1Mv7jGq
     JLFlQZ+y16PNSOrnGgCJhhsIZng8oKgcib2yZvuWCrXtMD+H3Q0sewT6erh65eHj
     CuBRZ1iKnykeQSMnz2wrJZCnSuCzu14vAeBlidYVsumcdXk407CNYgm7GI7ljuHt
     /sjKVRPrpn4UARiWDSs+Gpfmd3WzG++wpNArB9D1QwTv+9i6gELEyiQgokqST91I
     JFx4vFmwWTEmjZWCs7LDRLkEvu0WqK4JlKOT3GviKIzQ5+N41iOsd92rSpJJZFq4
     t20KsGMFGWoqPXsHUd+v4J8+oQ==
     -----END CERTIFICATE-----
     subject=/C=DE/ST=Franconia/O=Raffzahn GmbH/CN=localhost/emailAddress=certificates@example.com
     issuer=/C=DE/ST=Franconia/L=Nuernberg/O=Raffzahn GmbH/CN=Raffzahn CA/emailAddress=certificates@example.com
     ---
     No client certificate CA names sent
     Peer signing digest: SHA512
     Server Temp Key: ECDH, P-256, 256 bits
     ---
     SSL handshake has read 2198 bytes and written 415 bytes
     ---
     New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
     Server public key is 2048 bit
     Secure Renegotiation IS supported
     Compression: NONE
     Expansion: NONE
     No ALPN negotiated
     SSL-Session:
         Protocol  : TLSv1.2
         Cipher    : ECDHE-RSA-AES256-GCM-SHA384
         Session-ID: 2D551D55253FBB9BDCFCBA9422B7DD04D7E489083B08EC5BA2FBBE6472349EFF
         Session-ID-ctx: 
         Master-Key: AB74914F68E7394C4FB38BDBFC95DE5B1C2CC38B0D136CA43694EEB3ED45C10504C73DC4E17B450F469BF1DEF5CD019A
         Key-Arg   : None
         Krb5 Principal: None
         PSK identity: None
         PSK identity hint: None
         TLS session ticket lifetime hint: 300 (seconds)
         TLS session ticket:
         0000 - fb 68 20 80 37 9f ef e8-68 2f c8 ae 61 e5 1d 52   .h .7...h/..a..R
         0010 - 7d 5a a9 b1 0e bb 71 b7-a1 c0 77 14 67 b2 d9 ba   }Z....q...w.g...
         0020 - 5a b7 61 5c 91 19 44 4c-60 cb c5 e7 5c 3f 12 e2   Z.a\..DL`...\?..
         0030 - 40 e6 7f 2f 9c 6f 1c 22-c8 99 11 7b 84 75 d2 d7   @../.o."...{.u..
         0040 - 72 0c b2 9d 17 40 59 97-e8 e6 eb 17 85 b4 10 c3   r....@Y.........
         0050 - 33 18 89 71 98 fa 79 b0-f2 25 ed 87 37 a2 7e a6   3..q..y..%..7.~.
         0060 - 77 b1 04 1f 25 ab 4c ed-15 73 9f c5 f0 c1 9e ac   w...%.L..s......
         0070 - 4f 68 21 cf 54 ed fe ce-68 9c dd bb dc 33 1f 2e   Oh!.T...h....3..
         0080 - c2 e1 46 e6 ef 9a 57 59-20 19 04 18 4b 59 da 6e   ..F...WY ...KY.n
         0090 - f2 ab 7d 49 3e 1a ee 20-2d 5c 3e ce 3a 2e 0c 1a   ..}I>.. -\>.:...
         00a0 - 98 61 b6 e2 98 5b 23 87-2b fb 1a d4 f7 90 4f 26   .a...[#.+.....O&
         00b0 - 3c 02 88 98 18 1f 98 80-f6 46 e8 e2 93 87 19 74   <........F.....t

         Start Time: 1569563465
         Timeout   : 300 (sec)
         Verify return code: 21 (unable to verify the first certificate)
     ---
     ```
     You see it complains about being unable to verify the first certificate. This is because the CA certificate of your own CA is not in the default truststore. (The commandline gives no dedicated truststore.)

   * If you do the same afterwards - as soon as you completed exercise B.1 - against this server, you see the last line turning into `Verify return code: 0 (ok)`  
     Further please note you can see an intermediate cerfificate is used (you can follow the complete trust chain).
     ```Bash
     ~# openssl s_client -connect exercise.jumpingcrab.com:21443
     CONNECTED(00000003)
     depth=2 O = Digital Signature Trust Co., CN = DST Root CA X3
     verify return:1
     depth=1 C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
     verify return:1
     depth=0 CN = exercise.jumpingcrab.com
     verify return:1
     ---
     Certificate chain
      0 s:/CN=exercise.jumpingcrab.com
        i:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
      1 s:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
        i:/O=Digital Signature Trust Co./CN=DST Root CA X3
     ---
     Server certificate
     -----BEGIN CERTIFICATE-----
     MIIFaDCCBFCgAwIBAgISAy2MmKlr8UX5QRZzo5ekoOgOMA0GCSqGSIb3DQEBCwUA
     MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
     ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xOTA5MjQxOTI5MjBaFw0x
     OTEyMjMxOTI5MjBaMCMxITAfBgNVBAMTGGV4ZXJjaXNlLmp1bXBpbmdjcmFiLmNv
     bTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOoW1HvZ4jtg/MCCY8wc
     D2N87FhKuy3kpyZRFtmLdfiYO5JNEsywr6ymR4FBgfPlYxrRpw7Bnc4Ic2Wx0WHI
     2gq6HkK+picvAWUqN1c1mKCO7aM/n0u93a/sf16hTvrKcIy6EldYXblX9IoXHK/9
     38WuCg/c0aaJ8C2pyG31jqrCwXErT8ppecGvYJESPTz36zeptMK0ldAfQFlzXL9y
     9H7dYH6sV+xrmlattbqRgfI3YUv/V9f07UXcmpzX4h+81CKR3Ddm95YMeO83RyZS
     UvzKaP++Tqt7L1vxB4viauCJosUEAsOMjVWn0m16nEchtYHgDpKUjggxIScUpbG6
     1/0CAwEAAaOCAm0wggJpMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEF
     BQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQUCOfluPBnpX9l
     20iJ+nBtGUZgjQ8wHwYDVR0jBBgwFoAUqEpqYwR93brm0Tm3pkVl7/Oo7KEwbwYI
     KwYBBQUHAQEEYzBhMC4GCCsGAQUFBzABhiJodHRwOi8vb2NzcC5pbnQteDMubGV0
     c2VuY3J5cHQub3JnMC8GCCsGAQUFBzAChiNodHRwOi8vY2VydC5pbnQteDMubGV0
     c2VuY3J5cHQub3JnLzAjBgNVHREEHDAaghhleGVyY2lzZS5qdW1waW5nY3JhYi5j
     b20wTAYDVR0gBEUwQzAIBgZngQwBAgEwNwYLKwYBBAGC3xMBAQEwKDAmBggrBgEF
     BQcCARYaaHR0cDovL2Nwcy5sZXRzZW5jcnlwdC5vcmcwggEEBgorBgEEAdZ5AgQC
     BIH1BIHyAPAAdgDiaUuuJujpQAnohhu2O4PUPuf+dIj7pI8okwGd3fHb/gAAAW1k
     9tM6AAAEAwBHMEUCICOoKU3itBQajrCtL5+7cAOIeScyx5N1SBDuMc5v4HhOAiEA
     39wmRfOwrFbaTw5/lu9SYKJt/g94lPmlb6BTvuL5rgwAdgBj8tvN6DvMLM8LcoQn
     V2szpI1hd4+9daY4scdoVEvYjQAAAW1k9tMuAAAEAwBHMEUCIQDaIBrJKeOeVkMA
     UaJ2NirtIHz70SFq7GFJ0g89z+cmIAIgBIDNNuts5BKQp9rLjdeUDHi+Ym0Gfc7f
     lhvZ5DvCvcMwDQYJKoZIhvcNAQELBQADggEBAAaXxp7f3UEYZa5SHHci7jN0i3vQ
     KNKcEohttFi7qB20jOQHfx9SQlplkmLGERhJxnCKym/bhEAkaETZEMSw+bkV2jD5
     P6KJcyXZmvLCHSnlUs2wvLvmyh+AqksYPix55OugthsjZSweVGleaUGcEdqXcWg/
     Nfm+vmkwKNiS4zWSPlulMAn1FghLKfs9b/RDqRUL0M4HSL1gnIn8TginANEJZ++S
     B6gPurE4S2+ALtAGx4HthB6tuoMBPVEF2sRlDE7lV1Z1z/swrN605F3msE+17Hf0
     nG1/wqcXNj/L0o0CKGF3rHQ/aaYf3kXK1ldpiPBhbt0Yn0mvBZNzTuok2sQ=
     -----END CERTIFICATE-----
     subject=/CN=exercise.jumpingcrab.com
     issuer=/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
     ---
     No client certificate CA names sent
     Peer signing digest: SHA512
     Server Temp Key: ECDH, P-256, 256 bits
     ---
     SSL handshake has read 3256 bytes and written 415 bytes
     ---
     New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
     Server public key is 2048 bit
     Secure Renegotiation IS supported
     Compression: NONE
     Expansion: NONE
     No ALPN negotiated
     SSL-Session:
         Protocol  : TLSv1.2
         Cipher    : ECDHE-RSA-AES256-GCM-SHA384
         Session-ID: 836BCDE2E6FB31178F1187CB3FD20591417AE245ABF674ABFBAE9672FC140EC9
         Session-ID-ctx: 
         Master-Key: 1983D2805F283BE06E0506718B08767359441DAE433F3E5542A96D9F5B90D3FB67A71FCC6307BBE69305A2EEAC781B5B
         Key-Arg   : None
         Krb5 Principal: None
         PSK identity: None
         PSK identity hint: None
         TLS session ticket lifetime hint: 300 (seconds)
         TLS session ticket:
         0000 - 6c b8 9f 4c fe f6 f2 ac-73 96 e3 d8 ea 35 bc 63   l..L....s....5.c
         0010 - 58 bd 44 84 b0 d1 6f d9-8c 85 a1 18 34 ff 36 67   X.D...o.....4.6g
         0020 - f6 7d ce 10 89 ce df 4c-68 ea 28 3a 3a d2 6f ba   .}.....Lh.(::.o.
         0030 - b8 d3 d4 d1 87 29 ad 50-6c a1 15 cd 7d fa e0 e1   .....).Pl...}...
         0040 - 98 db bd d2 89 0c c5 32-1c b9 d4 cf 79 a7 71 3b   .......2....y.q;
         0050 - 6b 64 c4 6f b9 6c b8 37-8b b4 44 37 46 2b 17 2d   kd.o.l.7..D7F+.-
         0060 - 07 5b c4 7f 4f c0 fe 82-1d 1f 3f 80 eb 56 7c d5   .[..O.....?..V|.
         0070 - 9b be 23 cc cc 01 1d 8e-b5 c1 9b 8f 22 36 c4 5c   ..#........."6.\
         0080 - ea fb 63 a4 6a cd 81 07-25 69 e6 85 5b 9d a3 a8   ..c.j...%i..[...
         0090 - b0 9d 5c b9 9f cd bf 81-58 35 82 fc da b0 8f d9   ..\.....X5......
         00a0 - d3 7d 91 89 09 cf fe 26-31 99 07 a2 e1 4a c3 8a   .}.....&1....J..
         00b0 - b3 aa e6 2d 4b 1e 8e 0c-66 9b eb 04 92 09 56 e6   ...-K...f.....V.

         Start Time: 1569564399
         Timeout   : 300 (sec)
         Verify return code: 0 (ok)
     ---
     ```
