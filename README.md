# TLS4Developers Workshop: Hands-on-Labs

Due to increasing security needs nowadays software developers and admins need to have a solid knowledge on TLS (SSL) connections and x.509 certificates and how to handle them. TLS is used in HTTPS / SMTPS / IMAPS / ... connections, for encrypting or digitally signing files, etc. And these technologies help to reduce attack surface.

For novices joining development or operations teams as well as for people working in the teams for a long time, but feel their knowledge should be improved, we started these Hands-on training lab. You will learn step by step from very basic topics to more advanced ones. You might want to use these Hands-on-Labs as your only source of new knowledge or in addition to the TLS4Developers Workshop. They are designed in a way you can also do them at home if you feel you would like to have more time for real Hands-on experience or need more practicing.

## Prerequisites

You need a machine running Linux (or maybe MacOS) as your playground

   * This could be your local workstation or some machine reachable (by network) from your workstation.
   * The playground machine needs internet access.
   * Single exercises maybe depend on additional prerequisites. They are named there.
   * The exercises probably will work on MacOS too, but maybe need to be adapted. They have been created and tested on Linux - so if you are looking for the easy way: Go for Linux.
   * You might want to use __Vagrant__ to set up a playground machine. For your convenience it cares for most of the prerequisites.

### Prerequisites using Vagrant

   * cd to the directory where you cloned this Git repository. (*Vagrantfile* provided here needs to be in your current working directory)
   * `vagrant up`
   * `vagrant ssh`

If you are not familiar with Vagrant, you might want to have a look at our short [VAGRANT_HOWTO](VAGRANT_HOWTO.md).

### Prerequisites without using Vagrant

You need to care for these additional prerequisites yourself:

   * On your playground machine you need an Apache Webserver (in a recent version) up and running and mod_ssl needs to be enabled.
   * You need to be able to configure and restart the Apache webserver there. If you have root access, this is easy. Other permissions to do so are absolutly fine too!
   * OpenSSL needs to be installed in a recent version.
   * A commandline HTTP client needs to be installed on your playground machine, curl is preferred.
   * Clone this Git repository on your playground machine.

## Hints: Working with the exercises

   * Some of the exercises are marked optional - the headline includes the word **optional** and they are set in an _italic font_: Decide if you think they provide additional value for you or if you want to jump to the next exercise. (E. g. if you are not developing anything in Java, you might want to skip the Java examples.)
   * All other exercises we would recommend to do!
   * Every exercise uses a different port (to avoid port conflicts: You might want to have more than one exercise online at once.)  
     So be careful when using commands from your history if they are form an other exercise. Think of changing the port.
   * Port numbers of chapter A start with 1, chapter B with 2.  
     Second digit is the number of the exercise. So:  
      - Exercise A.1 uses port 11443
      - Exercise A.2 uses port 12443
      - ...
      - Exercise B.1 uses port 21443
      - ...
   * We added port forwardings for all of these ports in the Vagrantfile.  
     So if you want to do some tests with client software on your workstation: Use the same ports there. (By default they will be bound to the localhost interface.)

## Chapter A: Selfsigned Certificates and a CA Created by Yourself

### Exercises

Now it's time to really start exercising:

   * [__Exercise A.1__](exercises/A1/):
     Establish a connection between a client and the HTTPS server, secured by a selfsigned certificate
   * [__Exercise A.2__](exercises/A2/):
     Establish a HTTPS connection with a selfsigned certificate - without any certificate warning
   * [__Exercise A.3__](exercises/A3/):
     A Certificate Authority (CA) - created by yourself
   * [__Exercise A.4__](exercises/A4/):
     The Client needs to authenticate by a Client Certificate: mTLS
   * [__Exercise A.5__](exercises/A5/):
     Useful Commands for Dealing with Certificates and Keystores
   * [__Exercise A.6__](exercises/A6/):
     Setting up an HTTPS-Enabled Spring Boot Application


## Chapter B: Using Certificates of an Official CA

You will do similar exercises here as in chapter A, but with certifcates from an official CA. Differnce is: Browsers and other HTTPS clients have these CA certificates in their truststore by default: No need to trust them explicitly.  
Additionally you will learn about intermediate certificates, also called chain certificates.

### Additional Prerequisites

(The playground machine you are using in chapter B can be a different one than you used in chapter A.)

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

If you are unsure how to get a certificate for the exercises, you might want to have a look at our [LETSENCRYPT_MINI_HOWTO](LETSENCRYPT_MINI_HOWTO.md).

### Hints

In chapter B you will not have such a standardized environment than in chapter A. Because this is a more real-world-scenario you will use your individual domain name, certificate, ...  
That's why you will need to adapt the examples given.

| Where ever you see...                                        | Replace it by...                                               |
|--------------------------------------------------------------|----------------------------------------------------------------|
| `exercise.jumpingcrab.com`                                   | The DNS name of your playgroud machine.                        |
| `/etc/letsencrypt/live/exercise.jumpingcrab.com/cert.pem`    | The full path of your certificate in PEM format.               |
| `/etc/letsencrypt/live/exercise.jumpingcrab.com/chain.pem`   | The full path of your chain certificate in PEM format.         |
| `/etc/letsencrypt/live/exercise.jumpingcrab.com/privkey.pem` | The full path of your certificate's private key in PEM format. |

### Exercises

   * [__Exercise B.1__](exercises/B1/):
     An Intermediate Certificate (and a HTTPS Connection with an Official Server Certificate)
   * [__Exercise B.2__](exercises/B2/):
     mTLS Connection with Intermediate Certificate (from an Official CA)
   * [__Exercise B.3__](exercises/B3/):
     Certificate Revocation
   * [__Exercise B.4__](exercises/B4/):
     OCSP Stapling
   * [__Exercise B.5__](exercises/B5/):
     Expiring Certificates / Monitoring
