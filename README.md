# Build [Migu](http://mix-mplus-ipa.osdn.jp/migu/) & [Ricty](http://www.rs.tus.ac.jp/yyusa/ricty.html) fonts

 1. Install [VirtualBox](https://www.virtualbox.org/)

 2. Install [Vagrant](https://www.vagrantup.com/)

 3. Launch VM

        $ vagrant up

 4. Make fonts

        $ vagrant ssh
        [vagrant@centos ~]$ /vagrant/make.sh

    You will get fonts in fonts/ directory.

 5. Cleanup

        $ vagrant destroy
