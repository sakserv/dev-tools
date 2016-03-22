Hadoop Zookeeper Slider Build Vagrant
--------------------------------------
This project performs the following tasks to accelerate development of Apache Hadoop:
* Provisions a centos 7 VM
* Updates all packages
* Adds the EPEL Repo
* Installs and starts the latest version of Docker
* Installs Java 8, git, maven, ansible, openssl, and protobuf
* Installs the gcc development tools
* Configures maven for hwx jetty
* Configures SSH keys for ansible
* Stages and builds Hadoop from source
* Stages and builds Zookeeper from source
* Stages and builds Slider from source
* Deploys Hadoop via Ansible
* Deploys Zookeeper via Ansible
* Deploys Slider via Ansible
* Sets PATH and JAVA_HOME for all projects

Pre-requisites
--------------
* git
* Hadoop 2.x source
* Zookeeper source
* Slider source
* Vagrant 1.1+
* VirtualBox
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)

vagrant-vbguest
---------------
To leverage shared folders and port forwarding, VirtualBox Guest Additions is required.

vagrant-vbguest is a Vagrant plugin that automatically installs VirtualBox Guest Additions on <code>vagrant up</code>

Simple run the following once on the host machine:

```
vagrant plugin install vagrant-vbguest
```
Setup
-----
This project will take the source code from the host machine and stage it on the VM using shared folders (building on shared folders is painfully slow). As a result, we need to tell Vagrant/VirtualBox where the source code lives on the host machine.

Modify the Vagrantfile and change the source path for each of the projects (DO NOT change the destination mount point):

```
# Shared dirs
config.vm.synced_folder "/Users/skumpf/git/hadoop-hwx", "/hadoop_src"
config.vm.synced_folder "/Users/skumpf/git/zookeeper-hwx", "/zookeeper_src"
config.vm.synced_folder "/Users/skumpf/git/slider-hwx", "/slider_src"
```

Using
-----
After performing the setup above, simple start the virtual machine via Vagrant:

```
  vagrant up
```

Once all provisioning completes, the VM can be accessed by running the following in the working directory:

```
  vagrant ssh
```

The projects will be installed to /usr/local/src/<project_name> by default.


Deploying Code Changes
----------------------

After making code changes, to rebuild and redeploy, simple run the project specific bootstrap script. These scripts clean up the old installation and deploy any updated code changes.

* Hadoop
```
  /vagrant/tools/bootstrap_hadoop.sh
```

* Zookeeper
```
  /vagrant/tools/bootstrap_zookeeper.sh
```

* Slider
```
  /vagrant/tools/bootstrap_slider.sh
```


TODO
----
* Allow the source directories on the host machine to be defined with environment variables.

