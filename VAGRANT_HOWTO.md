# What You Need to Know about Vagrant

[Vagrant](https://www.vagrantup.com/) is a tool which makes it easy to quickly setup (and destroy again) test or playground systems as VMs on your local computer, e. g. with VirtualBox.

## Installation

   * On your workstation install some compatible hypervisor, e. g. VirtualBox.  
     For the full list see https://www.vagrantup.com/docs/providers/

   * [Download Vagrant](https://www.vagrantup.com/downloads.html) and install it to your workstation.

## Use Vagrant for Our Exercises

The most important thing to understand is: As you could have multiple Vagrant Boxes on your system, Vagrant needs a way to know which of the boxes you want to address with a specific command. So when ever using some `vagrant` command, make sure your current working directory is a directory containg a `Vagrantfile`. The box described there is used. For our exercises it's the root directory of the Git repository. Make sure this is your current working directory (means: `cd` to this directory before using any `vagrant` command).

### Useful Vagrant Commands

   * Use `vagrant up` to start the VM.

   * If you did some of the exercises and it's enough for now, just use `vagrant halt` to shutdown the VM and persist it's current state.

   * As soon as you want to continue, just use `vagrant up` again. You'll find everything in the way you left it last time. It's just the same as powering your VM off and on again.

   * If you messed up the test VM, a `vagrant destroy` followed by a `vagrant up` brings you to a shiny new instance of the system. Everything you did before in the VM is cleaned up.

   * If you finished all the excercises and do not need the playground VM any longer, `vagrant destroy` is your friend and purges the VM completely from your disk.

   * As the images of the different boxes you used also need space on your hard disk, please note the command `vagrant box`. Use `vagrant box list` to display all of them. `vagrant box remove <name>` deletes a box. Use `vagrant box help` if you want to know more.
