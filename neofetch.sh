#!/bin/bash


echo "Updating Package List"
sudo apt update

echo "installing neofetch"
sudo apt install neofetch -y

echo "Succes installing neofetch"
neofetch