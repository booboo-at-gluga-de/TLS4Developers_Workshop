# Exercise B.3: Certificate Revocation

## Objective

In this exercise you will learn about certificate revocation and how to check if a certificate (your communication partner is presenting) is revoked.

## Preface

Security of x.509 certificates relies on the private key being kept secret. Only authorized persons / systems are allowed to access it. If this is not guaranteed any more the certificate needs to be invalidated immediatelly. This is called __certificate revocation__ in x.509 context and needs to be done at least in the following situations:

   * The private key is stolen or suspected to be stolen.
   * An attacker had access (or suspected to have access) to the system storing the private key.

Depending on regulations in your organisation you might additionally need to revoke a certificate:

   * If the owning system is deprovisioned and the remaining validity period is exceeding a certain amount of time (e. g. more than 90 days remaining)
   * A colleague left the organisation who had access to the private key.

Only the Certifcate Authority (CA) which issued the certificate is able to revoke it.

## CRL versus OCSP

Everyone verifying certificates needs a method to check if the certificate has been revoked. Two different methods are currently used:

   * A __certificate revocation list__ (CRL) is one file containing information about every revoked certificate issued by this CA. It is digitaly signed by the CA, has a limited validity period and is distributed via a HTTP server.  
     See also: https://en.wikipedia.org/wiki/Certificate_revocation_list

   * With the __Online Certificate Status Protocol__ (OCSP) you can send a specific query to an OCSP reponder (provided by the CA) to check the revocation status of one single certificate. For the transfer also HTTP is used. The response is also digitaly signed by the CA and also has a limited livetime.  
     See also: https://en.wikipedia.org/wiki/Online_Certificate_Status_Protocol

Nowadays OCSP is more widly used than CRLs.

## Revoke a Certificate

The concrete steps for revoking a certificate are a little different from CA to CA. Please see instructions provided by the Certificate Authority (CA) which issued the certificate.

## Check for Revocation

__IMPORTANT:__ For fully verifying a certificate presented to you by your communication partner, make sure you do not only check the validity of the certificate but also to check it for revocation. Your communication partner might be a server you are connecting to (presenting a server certificate) or - in mTLS usecase - also a client (authenticating by a client certificate).

Most Browsers nowadays do check revocation of server certificates by default. Other software components and libraries often (by default) don't. Make sure to configure a proper check! (You will do this in one example in a few moments.)

Each certificate contains the URL where the according CRL can be retrieved, or the URL of the according OCSP responder. Or if you are really lucky: Both (in this case you have the free choice on which to use).

## Steps

### Display Content of CRL

   * Point your browser to https://github.com/ and examine the certificate. Probably it will contain both (at least for now - October 2019 - it does). One or more CRL URL(s):  
     ![CRL URL(s) within the certificate](images/crl_info.png "CRL URL(s) within the certificate")  
     And a OCSP URL:  
     ![OCSP URL within the certificate](images/ocsp_info.png "OCSP URL within the certificate")

   * You can use the CRL URL (just found out) to download it and have a look at it:  
     ```Bash
     ~# wget -O /tmp/sha2-ev-server-g2.crl http://crl3.digicert.com/sha2-ev-server-g2.crl
     --2019-10-22 17:24:56--  http://crl3.digicert.com/sha2-ev-server-g2.crl
     Resolving crl3.digicert.com (crl3.digicert.com)... 93.184.220.29
     Connecting to crl3.digicert.com (crl3.digicert.com)|93.184.220.29|:80... connected.
     HTTP request sent, awaiting response... 200 OK
     Length: 881818 (861K) [application/x-pkcs7-crl]
     Saving to: ‘/tmp/sha2-ev-server-g2.crl’

     /tmp/sha2-ev-server-g2.crl      100%[=======================================================>] 861.15K   995KB/s    in 0.9s

     995 KB/s - ‘/tmp/sha2-ev-server-g2.crl’ saved [881818/881818]

     ~# openssl crl -in /tmp/sha2-ev-server-g2.crl -inform der -noout -text
     Certificate Revocation List (CRL):
             Version 2 (0x1)
             Signature Algorithm: sha256WithRSAEncryption
             Issuer: C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert SHA2 Extended Validation Server CA
             Last Update: Oct 21 21:36:27 2019 GMT
             Next Update: Oct 28 21:36:27 2019 GMT
             CRL extensions:
                 X509v3 Authority Key Identifier: 
                     keyid:3D:D3:50:A5:D6:A0:AD:EE:F3:4A:60:0A:65:D3:21:D4:F8:F8:D6:0F

                 X509v3 CRL Number: 
                     861
                 X509v3 Issuing Distribution Point: critical
                     Full Name:
                       URI:http://crl3.digicert.com/sha2-ev-server-g2.crl

     Revoked Certificates:
         Serial Number: 039F0B833D605C80AADFA805BBF8BF71
             Revocation Date: Sep  1 18:14:59 2017 GMT
         Serial Number: 0FE92680E5D4D721F88FD7311BBD950A
             Revocation Date: Sep 11 19:00:19 2017 GMT
         Serial Number: 052F967F3E35CEB82A5925211B7E3E7F
             Revocation Date: Sep 16 09:03:21 2017 GMT
         Serial Number: 0A077759472127F2EC03B99D2677247F
             Revocation Date: Sep 22 15:26:34 2017 GMT
         Serial Number: 04E73B9986FCB24355B0C5525F30FADF
             Revocation Date: Sep 23 19:09:05 2017 GMT
         Serial Number: 01AC27990B900397CC6E0930471416A7
             Revocation Date: Sep 25 18:37:48 2017 GMT
         Serial Number: 0B866584D82860A3EDB4A9FB9FC69678
     [...]
     ```
     You can see:
        - When the CRL was created
        - When it will expire
        - A (long) list of serial numbers of revoked certificates together with it's revocation date

### Check a Certificate against OCSP (manually)

   * Retrieve the server certificate from the server and save it to a file.  
     (This is the certificate we want to check in a few moments.)  
     ```Bash
     ~# openssl s_client -connect github.com:443 </dev/null | sed -n '/-----BEGIN/,/-----END/p' >/tmp/github.com.pem
     depth=2 C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert High Assurance EV Root CA
     verify return:1
     depth=1 C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert SHA2 Extended Validation Server CA
     verify return:1
     depth=0 businessCategory = Private Organization, jurisdictionC = US, jurisdictionST = Delaware, serialNumber = 5157550, C = US, ST = California, L = San Francisco, O = "GitHub, Inc.", CN = github.com
     verify return:1
     DONE
     ```

   * For checking against OCSP we also need the intermediate certificate. Let's retrieve this one now too:  
     ```Bash
     ~# openssl s_client -showcerts -connect github.com:443 </dev/null | sed -n '/-----BEGIN/,/-----END/p' >/tmp/github.com.chain.pem 
     depth=2 C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert High Assurance EV Root CA
     verify return:1
     depth=1 C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert SHA2 Extended Validation Server CA
     verify return:1
     depth=0 businessCategory = Private Organization, jurisdictionC = US, jurisdictionST = Delaware, serialNumber = 5157550, C = US, ST = California, L = San Francisco, O = "GitHub, Inc.", CN = github.com
     verify return:1
     DONE
     ```

   * In `/tmp/github.com.chain.pem` now there are two certificates, the server certificate and the intermediate. We only need the intermediate certificate. So open the file in a texteditor and delete the first certificate block:  
     ```Bash
     ~# vim /tmp/github.com.chain.pem 
     ```

   * From the certifcate to check you can extract the OCSP URL by:  
     ```Bash
     ~# openssl x509 -in /tmp/github.com.pem -noout -ocsp_uri
     http://ocsp.digicert.com
     ```  
     Use the URL found here in the next step for the `-url` parameter.

   * Now you have everything ready to really check against the CA's OCSP handler:  
     ```Bash
     ~# openssl ocsp -issuer /tmp/github.com.chain.pem -cert /tmp/github.com.pem -text -url http://ocsp.digicert.com

     OCSP Request Data:
         Version: 1 (0x0)
         Requestor List:
             Certificate ID:
               Hash Algorithm: sha1
               Issuer Name Hash: 49F4BD8A18BF760698C5DE402D683B716AE4E686
               Issuer Key Hash: 3DD350A5D6A0ADEEF34A600A65D321D4F8F8D60F
               Serial Number: 0A0630427F5BBCED6957396593B6451F
         Request Extensions:
             OCSP Nonce: 
                 041015510200F4B569CCAA069B5E2311ECE5
     OCSP Response Data:
         OCSP Response Status: successful (0x0)
         Response Type: Basic OCSP Response
         Version: 1 (0x0)
         Responder Id: 3DD350A5D6A0ADEEF34A600A65D321D4F8F8D60F
         Produced At: Oct 22 20:09:41 2019 GMT
         Responses:
         Certificate ID:
           Hash Algorithm: sha1
           Issuer Name Hash: 49F4BD8A18BF760698C5DE402D683B716AE4E686
           Issuer Key Hash: 3DD350A5D6A0ADEEF34A600A65D321D4F8F8D60F
           Serial Number: 0A0630427F5BBCED6957396593B6451F
         Cert Status: good
         This Update: Oct 22 20:09:41 2019 GMT
         Next Update: Oct 29 19:24:41 2019 GMT

         Signature Algorithm: sha256WithRSAEncryption
              0f:45:59:82:44:81:2f:be:1d:22:5b:af:bb:cf:1d:98:b8:72:
              ed:fa:c7:cb:76:5f:28:65:78:ce:1b:91:19:aa:e2:03:2b:6a:
              c0:73:d4:80:23:e0:d7:d0:c6:34:42:47:fc:21:57:44:13:47:
              3f:06:a6:f3:c2:a3:18:cb:62:7a:7a:c4:73:9c:87:85:6a:d0:
              72:56:73:83:fd:35:b7:77:fb:4c:75:0c:ea:0a:8f:7c:d2:45:
              c6:3e:ff:76:d6:ac:3c:2b:71:50:c5:36:b4:2b:7a:11:d0:58:
              75:4b:dd:6e:b5:33:a2:4b:93:8c:d3:5f:90:cb:08:f7:b8:76:
              8e:d3:77:9b:ce:8a:f2:71:0c:60:f5:49:4c:d7:ea:c3:d9:a3:
              02:ad:b5:18:b2:b6:a5:32:c4:8a:34:a2:b2:8b:61:1e:54:7b:
              40:1c:8b:0e:bb:d7:46:77:32:0f:82:46:b2:f7:92:79:74:c4:
              36:b4:17:dc:50:25:a2:9e:23:1c:5c:a3:61:98:15:a3:be:a2:
              e0:54:6f:b8:82:ce:26:3d:e9:5b:fc:1a:a5:39:cd:be:2c:8e:
              3f:20:c8:91:3d:39:e7:0b:b1:a8:ee:3a:03:76:9e:52:67:14:
              10:e9:6b:17:f3:d9:a7:b4:5d:c2:e7:5d:63:88:ad:b0:ad:bf:
              df:90:19:9f
     WARNING: no nonce in response
     Response verify OK
     /tmp/github.com.pem: good
        This Update: Oct 22 20:09:41 2019 GMT
        Next Update: Oct 29 19:24:41 2019 GMT
     ```

### Always check for revocation (automatically)

To continue with the next steps you need to have finished [__Exercise B.2__](../B2/).

   * tbd

    LogLevel debug
    SSLOCSPEnable on
    SSLOCSPUseRequestNonce off
    SSLOCSPResponderCertificateFile /etc/letsencrypt/live/exercise.jumpingcrab.com/chain.pem


## Conclusion

tbd
