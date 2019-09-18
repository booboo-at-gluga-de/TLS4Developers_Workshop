# Exercise 3: A Certificate Authority (CA)

## Objective

In the previous exercises you found out that selfsigned certificates are hard to use. The certificate of every server needs to be in the truststore of every client. If you have M servers and N clients you would have to distribute M * N entries in truststores. And be aware of certificates have a limited lifetime - you will have to renew all of them from time to time.

So in the real world there are Certificate Authorities (CAs) approving and signing certificates of others. You only need to trust these CA certificates.

In this exercise you will create your own CA certificate and sign your server's certificate with this. Besides this, the setup here is very similar to exercise 2. Well, to be honest, a CA certificate created by yourself does not help too much, because you still have to put this one into all truststores yourself. For demo purposes you will do it anyway.

One advantage compared to selfsigned certificates stays: You need to distribute only N entries in truststores (which is already way better than M * N).

## Hint

In this exercise some commands reference files by complete path. If you use our Vagrant setup, you do not have to change anything. If you don't: Please change the path accordingly. Wherever you see `/vagrant/...` below you use the path where the file is located at your system. All files referenced are included within this git.

## Steps
   * Prepare some configs for your own Certificate Authority (CA):  
     (within the Vagrant setup you might want to do the following steps directly in `/home/vagrant`)
     ```Bash
     ~# /vagrant/exercises/3/prepare_CA.sh
     ```

   * to be continued
