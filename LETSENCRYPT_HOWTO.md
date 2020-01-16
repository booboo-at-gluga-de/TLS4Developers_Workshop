# Let's Encrypt Mini-HowTo

For the exercises in chapter B you need a certificate from an official CA. 

Install certbot. See instructions on https://certbot.eff.org/

## With a Domain You Own

~# certbot certonly --manual --preferred-challenges dns -d exercise.example.com
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for exercise.example.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.exercise.example.com with the following value:

PC1nAM6BLcCaL2ebrieOxaXIxqB3u2elpE_PxD1Xxv8

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/exercise.example.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/exercise.example.com/privkey.pem
   Your cert will expire on 2020-04-15. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

### With a HTTP Server You Control

GET -> http://cert-example.jumpingcrab.com/


~# certbot certonly --manual --preferred-challenges http -d cert-example.jumpingcrab.com
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for cert-example.jumpingcrab.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Create a file containing just this data:

s0nG_tTNp6bisZcZbSOm61ADOOrL-Nqq04kydIGhouA.zuDGECcSkf3gNGFyeHkCf9Md_2ZDAsHZHScrYfkThjQ

And make it available on your web server at this URL:

http://cert-example.jumpingcrab.com/.well-known/acme-challenge/s0nG_tTNp6bisZcZbSOm61ADOOrL-Nqq04kydIGhouA

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/cert-example.jumpingcrab.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/cert-example.jumpingcrab.com/privkey.pem
   Your cert will expire on 2020-04-15. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le


----------------------------------------------

   * You need a DNS name pointing to the IP of your playground machine.  
     (We will reference to it in the exercises as `exercise.jumpingcrab.com`)
      - Means: If you do a `ping6 exercise.jumpingcrab.com` (or `ping exercise.jumpingcrab.com` if you are in a legacy network) from your workstation, make sure your playground machine answers. And if you do the same from your playground machine itself of course it should answer too.
      - If you are using a test machine in a corporate network it probably will already have a DNS record.
      - If you have an own domain you can add an AAAA, A or CNAME record pointing to your playground machine.
      - Alternatively some providers offer DNS records for free, e. g. https://freedns.afraid.org/
   * A certificate valid for this domain name is needed and needs to be issued by an official CA.
     (The DNS name above needs to be the CN of the certificate or in one of the SAN fields.)
      - If you are using a test machine in a corporate network it maybe will already have a valid certificate issued by your corporate CA. (In this case: Make sure the CA certificate is distributed in the truststore of all used clients.)
      - Alternatively get a cerfificate form your preferred CA. At https://letsencrypt.org/ you can get one for free.

