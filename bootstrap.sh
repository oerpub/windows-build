#!/usr/bin/env bash

# Just a simple way of checking if you we need to install everything
if [ ! -d "/var/www" ]
then
    # Update and begin installing some utility tools
    sudo apt-get -y update
    sudo apt-get install -y python-software-properties git curl build-essential apache2

    # vboxfs doesn't support sendfile, turn that off
    echo "EnableSendfile off" >> /etc/apache2/apache2.conf

    sudo service apache2 restart

    # Build latest node.js from source
    cd /tmp
    sudo git clone -b v0.10.22-release https://github.com/joyent/node.git
    cd node
    sudo ./configure
    sudo make
    sudo make install

    sudo npm install -g bower
fi


if [ -d "/home/vagrant/oerpub" ]
then
  rm -rf /home/vagrant/oerpub
fi

cd /vagrant
git submodule update --init --recursive
cp -r /vagrant /home/vagrant/oerpub
cd /home/vagrant/oerpub/github-bookeditor

npm install

sudo rm /var/www/*
for i in `ls`; do sudo ln -s /vagrant/github-bookeditor/$i /var/www/$1; done

cd /home/vagrant/oerpub/github-bookeditor/bower_components

rm -rf aloha-editor bookish

ln -s /vagrant/Aloha-Editor aloha-editor
ln -s /vagrant/bookish bookish

cd /var/www

sudo rm bower_components

sudo ln -s /home/vagrant/oerpub/github-bookeditor/bower_components bower_components
