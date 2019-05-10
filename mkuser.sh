#!/bin/bash
XDIR=$(pwd)

if [[ -z $1 ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
  echo "create user and add to sudoer and add public key"
  echo "$(basename $0) new_username pub_key_location"
  exit
fi

name="$1"
sshKey="$2"

if [[ -z "${name}" ]]; then
  echo "empty new user name"
  exit
fi

if [[ -z "${sshKey}" ]]; then
  echo "empty pub key file"
  exit
fi

if [ -d "/home/${name}" ]; then
  echo "user folder already exists"
  exit
fi

if [[ -n $(grep {$name}: /etc/passwd) ]]; then
  echo "user already  exists"
  exit
fi

if [ ! -f ${sshKey} ]; then
  echo "pub key file dont exist"
  exit
fi


sudo adduser --disabled-password --gecos "" ${name}

sudo usermod -aG sudo ${name}


sudo mkdir /home/${name}/.ssh
sudo cp ${XDIR}/${sshKey} /home/${name}/.ssh/id_rsa.pub
sudo mv ${XDIR}/${sshKey} /home/${name}/.ssh/authorized_keys
sudo chmod 400 /home/${name}/.ssh/*
sudo chown -R ${name}:${name} /home/${name}/.ssh
