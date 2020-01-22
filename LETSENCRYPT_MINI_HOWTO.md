# Let's Encrypt Mini-HowTo

This document is not supposed to be a (more or less) complete Let's Encrypt HowTo. The only purpose is to show you two common ways how to get a certificate from an official CA (in this case: Let's Encrypt) to be used for the exercises in chapter B.

When using Let's Encrypt in a real world scenario it is recommended to configure the Let's Encrypt certbot to automatically renew your certificate(s) - see https://letsencrypt.org/getting-started/  
For our use case here getting a certificate once is absolutely sufficient, so we show the manual approach.

## Prerequisites

   * Certificates from Let's Encrypt always are issued for some domain name in DNS, which is resolvable in the internet. So first of all you need some domain. This can be:
      - A Subdomain of a DNS domain you own
      - Alternatively some providers offer DNS records for free, e. g. https://freedns.afraid.org/
   * And Let's Encrypt needs to make sure you are "in control" of the domain before issuing a certificate. To proof this you can:
      - Add a given TXT record in DNS for this domain.  
        (This usually easily can be done for a domain you own.)
      - Deliver some given content by HTTP (port 80) under this domain.  
        (This is also possible with a subdomain offered by a free DNS provider.)
   * Install certbot (or certbot-auto) on your playground machine.
      - If you are using our Vagrant box, `certbot-auto` is already included.
      - For all other cases see instructions on https://certbot.eff.org/

## Hints

   * In this example we will assume you own a domain `jumpingcrab.com` and want to use the subdomain `exercise.jumpingcrab.com` for your playground machine. Of course your domain has a different name: Please replace it in the steps below accordingly.

   * The default client provided by Let's Encrypt offers a binary called `certbot-auto` or `certbot`, depending on the Linux distribution you are using. Both are accepting the same parameters. In the example we will use `certbot-auto` because this one is included in our Vagrant box. If you installed `certbot` instead, you just need to replace the command.

   * The only difference is:
       - `certbot` installs dependent packages at install time of certbot.
       - `certbot-auto` installs dependent packages in the moment you use it for the first time. (Please confirm this.)

## With a Domain You Own

   * Register the subdomain `exercise.jumpingcrab.com` in the DNS server of your domain `jumpingcrab.com`. (E. g. via the web frontend of your hosting provider.) For the certificate retrieval process it doesn't matter where the name points to. So you can directly make it point to your playground machine. (Add an AAAA or A record pointing to the IP of your playground machine.)

   * On your playground machine request the certificate:  
     ```Bash
     ~# sudo certbot-auto certonly --manual --preferred-challenges dns -d exercise.jumpingcrab.com
     Saving debug log to /var/log/letsencrypt/letsencrypt.log
     Plugins selected: Authenticator manual, Installer None
     Obtaining a new certificate
     Performing the following challenges:
     dns-01 challenge for exercise.jumpingcrab.com

     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     NOTE: The IP of this machine will be publicly logged as having requested this
     certificate. If you're running certbot in manual mode on a machine that is not
     your server, please ensure you're okay with that.

     Are you OK with your IP being logged?
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     (Y)es/(N)o: y

     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     Please deploy a DNS TXT record under the name
     _acme-challenge.exercise.jumpingcrab.com with the following value:

     PC1nAM6BLcCaL2ebrieOxaXIxqB3u2elpE_PxD1Xxv8

     Before continuing, verify the record is deployed.
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     Press Enter to Continue
     Waiting for verification...
     Cleaning up challenges

     IMPORTANT NOTES:
      - Congratulations! Your certificate and chain have been saved at:
        /etc/letsencrypt/live/exercise.jumpingcrab.com/fullchain.pem
        Your key file has been saved at:
        /etc/letsencrypt/live/exercise.jumpingcrab.com/privkey.pem
        Your cert will expire on 2020-04-15. To obtain a new or tweaked
        version of this certificate in the future, simply run certbot
        again. To non-interactively renew *all* of your certificates, run
        "certbot renew"
      - If you like Certbot, please consider supporting our work by:

        Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
        Donating to EFF:                    https://eff.org/donate-le
     ```

   * Within the retrieval process there is a point where it asks you to add a specific TXT record in the DNS. Please add it (again e. g. with the web frontent of your hosting provider) before you continue. This TXT record can be removed immediatelly after you successfully retrieved the certificate.


### With a HTTP Server You Control

GET -> http://exercise.jumpingcrab.com/


~# certbot certonly --manual --preferred-challenges http -d exercise.jumpingcrab.com
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for exercise.jumpingcrab.com

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

http://exercise.jumpingcrab.com/.well-known/acme-challenge/s0nG_tTNp6bisZcZbSOm61ADOOrL-Nqq04kydIGhouA

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/exercise.jumpingcrab.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/exercise.jumpingcrab.com/privkey.pem
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

