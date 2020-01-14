# Exercise B.4: OCSP Stapling

## Objective

You saw some disadvantages of OCSP in [__Exercise B.3__](../B3/). Now you will learn how OCSP Stapling adresses these and you will configure an Apache for OCSP Stapling.

## Advantages of OCSP Stapling

Let's quickly repeat some disadvantage of OCSP already discussed in [__Exercise B.3__](../B3/):
   * One additional network connection (between client and OCSP handler) during each TLS handshake. (This takes a little extra time.)
   * You rely on the availability of the OCSP handler: If the OCSP handler (operated by the CA) is unavailable, clients might be unable to request anything from your webserver because they are unable to trust your certificate.
   * Maybe privacy concerns: The CA could - by analyzing the access logs of the OCSP handler - track the usage of every certificate because they get one request within every TLS handshake. (IP address, timestamp, ...)

When using OCSP Stapling, the server does the OCSP request for it's own server certificate and sends the response to the client as part of the TLS handshake. The client can trust it anyway because the OCSP response is digitally signed by the CA.
   * No extra connection between client and OCSP handler is needed - no extra roundtrip time, no privacy concerns.
   * And: The server can very efficiently cache the OCSP response for a while. So short outages or overload situations of the OCSP handler do not have an impact.

See https://en.wikipedia.org/wiki/OCSP_stapling for more information on OCSP Stapling.

## Steps

To continue with the next steps you need to have finished [__Exercise B.1__](../B1/). There you did set up a HTTPS webserver with a certificate of an official CA.

   * First of all: Let's see a method how to find out if a server provides a (stapled) OCSP response within the TLS handshake. The easiest way is to use the parameter `-status` with openssl.  
     ```Bash
     ~# echo QUIT | openssl s_client -connect exercise.jumpingcrab.com:21443 -status
     CONNECTED(00000004)
     depth=2 O = Digital Signature Trust Co., CN = DST Root CA X3
     verify return:1
     depth=1 C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
     verify return:1
     depth=0 CN = exercise.jumpingcrab.com
     verify return:1
     OCSP response: no response sent
     ---
     Certificate chain
      0 s:CN = exercise.jumpingcrab.com
        i:C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
      1 s:C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
        i:O = Digital Signature Trust Co., CN = DST Root CA X3
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
     subject=CN = exercise.jumpingcrab.com

     issuer=C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3

     ---
     No client certificate CA names sent
     Peer signing digest: SHA256
     Peer signature type: RSA-PSS
     Server Temp Key: X25519, 253 bits
     ---
     SSL handshake has read 3127 bytes and written 421 bytes
     Verification: OK
     ---
     New, TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384
     Server public key is 2048 bit
     Secure Renegotiation IS NOT supported
     Compression: NONE
     Expansion: NONE
     No ALPN negotiated
     Early data was not sent
     Verify return code: 0 (ok)
     ---
     DONE
     ```  
     Please especially note the line:  
     ```Bash
     OCSP response: no response sent
     ```

   * Now edit your Apache's `exercise-B1.conf` file and __outside__ the `VirtualHost` section please add something like:  
     ```Bash
     SSLStaplingCache shmcb:/run/httpd/ocsp(512000)
     ```  
     Maybe you need a different path on your system. Suggestion: Use the same directory as in your `SSLSessionCache` directive.

   * And __inside__ the `VirtualHost` section please add:  
     ```Bash
     SSLUseStapling on
     SSLStaplingResponseMaxAge 3600
     ```  
     to enable OCSP Stapling.

   * If you are interested in what's going on during the TLS handshake and want to read every detail in the log, please add __inside__ the `VirtualHost` section:  
     ```Bash
     LogLevel debug
     ```

   * Now reload your Apache:
      * in CentOS / RedHat Enterprise setups this is
        ```Bash
        ~# sudo systemctl reload httpd
        ```
      * and in Debian / Ubuntu / Mint you do something like
        ```Bash
        ~# sudo systemctl reload apache2
        ```

   * And repeat the test from above:  
     ```Bash
     ~# echo QUIT | openssl s_client -connect exercise.jumpingcrab.com:21443 -status
     CONNECTED(00000004)
     depth=2 O = Digital Signature Trust Co., CN = DST Root CA X3
     verify return:1
     depth=1 C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
     verify return:1
     depth=0 CN = exercise.jumpingcrab.com
     verify return:1
     OCSP response:
     ======================================
     OCSP Response Data:
         OCSP Response Status: successful (0x0)
         Response Type: Basic OCSP Response
         Version: 1 (0x0)
         Responder Id: C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
         Produced At: Nov 26 20:29:00 2019 GMT
         Responses:
         Certificate ID:
           Hash Algorithm: sha1
           Issuer Name Hash: 7EE66AE7729AB3FCF8A220646C16A12D6071085D
           Issuer Key Hash: A84A6A63047DDDBAE6D139B7A64565EFF3A8ECA1
           Serial Number: 032D8C98A96BF145F9411673A397A4A0E80E
         Cert Status: good
         This Update: Nov 26 20:00:00 2019 GMT
         Next Update: Dec  3 20:00:00 2019 GMT

         Signature Algorithm: sha256WithRSAEncryption
              02:c7:4f:51:dd:6a:b0:ed:b9:99:15:1b:74:76:4e:11:da:7b:
              b1:26:0c:4f:3c:fc:92:66:77:95:87:87:67:d1:be:47:d2:df:
              cb:34:0d:3a:05:0a:67:aa:a4:8c:5d:33:4b:61:93:df:3a:c3:
              9d:1d:16:49:fc:49:1b:24:36:9b:1d:a5:20:fd:bc:30:9e:78:
              29:df:67:8e:58:19:17:f0:d2:6c:7f:93:56:b8:2e:1c:0a:4f:
              89:b2:a7:53:66:4d:2c:2d:9b:99:d5:e0:26:b5:63:0e:31:e5:
              8a:ef:fa:80:e3:72:33:54:e5:ea:c8:39:3a:ee:e4:c2:4a:d8:
              e2:6f:59:64:be:d4:cb:98:e0:5b:7d:03:10:93:5f:95:9b:48:
              eb:78:65:dd:39:a8:97:a8:7a:45:2d:0f:ad:62:0e:a1:09:4b:
              a1:09:29:d7:a1:2b:d2:3f:9f:1e:19:c6:ae:d5:fe:e7:39:88:
              58:93:32:c9:91:f6:5d:d7:1a:3f:97:69:7e:84:bc:5e:17:5f:
              28:c6:95:4d:37:b9:e9:d1:64:cf:cc:d1:26:4e:97:cd:7c:c7:
              a1:90:7b:69:8a:52:18:72:7a:84:00:16:8c:46:d9:b7:84:ab:
              08:1c:67:be:06:31:ec:2f:2b:11:81:0a:19:c4:d5:df:61:b8:
              82:0c:2f:42
     ======================================
     ---
     Certificate chain
      0 s:CN = exercise.jumpingcrab.com
        i:C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
      1 s:C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
        i:O = Digital Signature Trust Co., CN = DST Root CA X3
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
     subject=CN = exercise.jumpingcrab.com

     issuer=C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3

     ---
     No client certificate CA names sent
     Peer signing digest: SHA256
     Peer signature type: RSA-PSS
     Server Temp Key: X25519, 253 bits
     ---
     SSL handshake has read 3662 bytes and written 421 bytes
     Verification: OK
     ---
     New, TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384
     Server public key is 2048 bit
     Secure Renegotiation IS NOT supported
     Compression: NONE
     Expansion: NONE
     No ALPN negotiated
     Early data was not sent
     Verify return code: 0 (ok)
     ---
     DONE
     ```  
     Note: The `OCSP response` section now contains information.

   * If you use a HTTP client - `curl https://exercise.jumpingcrab.com:21443/index.html` or the browser on your workstation - you may not remark any changes in the behavior.

## Summary: Which Way Should I use for Revocation Checks?

You learned about CRLs, OCSP and OCSP Stapling. But which of them is the best in real life?  
The clear answer is: Well, it depends!

It depends on how many certificates you check per time interval and if all of them are issued from a small number of CAs, or if they are issued from many different CAs.  
Good news is: In many usecases we can break it down to one of two suggestions:

   * A client (e. g. a browser connecting to HTTPS websites) often connects to lots of servers with certificates from many different CAs. The client needs to do revocation checking for all of them. So for server certificates the recommendation is to use OCSP Stapling, because at the server side OCSP responses can be cached very efficiently: The server usually offers TLS based services with a limited number of certificates and provides services for a way bigger number of clients.

   * In an mTLS setup a server needs to do revocation checking for lots of different client certificates. On the other hand usually a server accepts Client Certificates from one single CA only (or maybe a very small number). Here revocation checking against a CRL is very efficient, because the server needs to download one (or very few) CRLs only and can efficiently cache them for a while.

Advantages are:

   * Both scenarios work with cached revocation information. That's why they are robust against short outages or performace issues on components at the CA side.
   * No privacy concerns (see above)
   * The number of network connections is optimized: Saving the roundtrip times of one extra connection.
   * Both of them need central configuration (at the server side) only.  
     (In many setups configurations of a limited number of servers is considered to be easier to roll out, than configurations at many clients.)

Caching Time Considerations (in both cases):

   * Updating CRLs or OSCP responses more often means more network traffic.
   * On longer intervals there is a longer time in which a certificate, which is already revoked, will still be accepted (and could be abused).  
     On the other hand: It also will take you some time to remark a certificate (or a whole machine) is compromised, and to do the revocation process.

So caching time depends on the concrete needs of your setup, but in most cases a time range in minutes does not make too much sense. Maybe thinking in hours could be better.

## Conclusion

Almost done! You already learned a lot. You might want to have a look on [__Exercise B.5__](../B5/) anyway, to make sure expiring certificates will not hurt you all over sudden.
