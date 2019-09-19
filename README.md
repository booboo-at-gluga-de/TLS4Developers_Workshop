# TLS4Developers Workshop

In addition to the TLS4Developers Workshop you find some exercises here to get a little more hands-on.
You might want to use them to practice at home.

## Prerequisites

You need a machine running Linux (or maybe MacOS) as your playground

   * This could be your local workstation or needs to be reachable by network from your workstation.
   * The playground machine needs internet access.
   * Single exercises maybe depend on additional prerequisites. They are named there.
   * The exercises probably will work on MacOS too, but maybe need to be adapted. They have been created and tested on Linux - so if you are looking for the easy way: Go for Linux.
   * You might want to use __Vagrant__ to set up a playground machine. For your convenience it cares for most of the prerequisites.

### With Vagrant

   * cd to the directory where you cloned this Git repository. (*Vagrantfile* provided here needs to be in your current working directory)
   * `vagrant up`
   * `vagrant ssh`

### Without Vagrant

You need to care for these additional prerequisites yourself:

   * On your playground machine you need an Apache Webserver (in a recent version) up and running and mod_ssl needs to be enabled.
   * You need to be able to configure and restart the Apache webserver there. If you have root access, this is easy. Other permissions to do so are absolutly fine too!
   * OpenSSL needs to be installed in a recent version.
   * A commandline HTTP client needs to be installed on your playground machine, curl is preferred.
   * Clone this Git repository on your playground machine.

## Chapter A: Selfsigned Certificates and a CA Created by Yourself

### Exercises

Now it's time to jump to the exercise you are interested in:

   * [__Exercise A.1__](exercises/A1/):
     Establish a connection between HTTPS server and client with a selfsigned certificate
   * [__Exercise A.2__](exercises/A2/):
     Establish a HTTPS connection with a selfsigned certificate - without any certificate warning
   * [__Exercise A.3__](exercises/A3/):
     A Certificate Authority (CA) - created by yourself
   * [__Exercise A.4__](exercises/A4/):
     The Client needs to authenticate by a Client Certificate: mTLS

## Chapter B: Using Certificates of an Official CA

### Exercises

   * to be done
