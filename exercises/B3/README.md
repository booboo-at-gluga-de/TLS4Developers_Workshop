# Exercise B.3: Certificate Revocation

https://akshayranganath.github.io/OCSP-Validation-With-Openssl/

github.com: CRL + OCSP
letsencrypt.org: OCSP only

Apache doku check client Cert
https://httpd.apache.org/docs/current/mod/mod_ssl.html
SSLCARevocationCheck chain
SSLOCSPEnable leaf

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

## Revoke a Certificate

The concrete steps for revoking a certificate are a little different from CA to CA. Please see instructions provided by the Certificate Authority (CA) which issued the certificate.

## Check for Revocation

__IMPORTANT:__ For fully verifying a certificate presented to you by your communication partner, make sure you do not only check the validity of the certificate but also to check it for revocation. Your communication partner might be a server you are connecting to (presenting a server certificate) or - in mTLS usecase - also a client (authenticating by a client certificate).

Most Browsers nowadays do check revocation of server certificates by default. Other software components and libraries often (by default) don't. Make sure to configure a proper check! (You will do this in one example in a few moments.)

Each certificate contains the URL where the according CRL can be retrieved, or the URL of the according OCSP responder. Or if you are really lucky: Both (in this case you have the free choice on which to use).

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

## Steps

   * tbd

## Conclusion

tbd
