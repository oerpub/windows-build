#!/usr/bin/env bash

# Get root up in here
sudo su

# Just a simple way of checking if you we need to install everything
if [ ! -d "/var/www" ]
then
    # Update and begin installing some utility tools
    apt-get -y update
    apt-get install -y python-software-properties git curl build-essential apache2

    # vboxfs doesn't support sendfile, turn that off
    echo "EnableSendfile off" >> /etc/apache2/apache2.conf

    service apache2 restart

    # Build latest node.js from source
    cd /tmp
    git clone -b v0.10.11-release https://github.com/joyent/node.git
    cd node
    ./configure
    make
    make install
fi

if [ -d "~/github-book" ]
then
  rm -rf ~/github-book
fi

cd /vagrant
git submodule update --init --recursive
cp -r /vagrant/github-bookeditor ~/github-bookeditor
cd ~/github-bookeditor

npm install

rm /var/www/*
for i in `ls`; do ln -s /vagrant/github-bookeditor/$i /var/www/$1; done

cd ~/github-bookeditor/bower_components

rm -rf aloha-editor bookish

ln -s /vagrant/Aloha-Editor aloha-editor
ln -s /vagrant/bookish bookish

cd /var/www

rm bower_components

ln -s ~/github-bookeditor/bower_components bower_components
