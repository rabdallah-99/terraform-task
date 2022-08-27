#!/bin/bash
#Installing Docker

sudo apt-get update
sudo apt install curl -y
curl https://get.docker.com | sudo bash
sudo usermod -aG docker $(whoami)
sudo systemctl enable docker 
sudo systemctl restart docker

#run docker
sudo docker run -p 80:80 --name nginx  nginx:latest
