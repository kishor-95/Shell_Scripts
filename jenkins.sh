#!/bin/bash

# Update the machine

sudo apt update -y 
## First we add repos
echo "Importing key..."
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  
if [[ $? == 0 ]]; then
  echo "Key Imported"
else
  echo "Key Importing Failed"
  exit 1
fi

## Update the new package list including Jenkins
echo "Updating the packages..."
sudo apt upate -y && sudo apt upgrade -y

## Add required dependencies for the Jenkins package
echo "Installing dependencies..."
sudo apt install fontconfig openjdk-21-jre -y
if [[ $? == 0 ]]; then 
  echo "Dependencies installed successfully. Installing Jenkins..."
else
  echo "Failed to install dependencies. Check the logs."
  exit 1
fi

## Installing Jenkins
sudo apt install jenkins -y

## Start and enable the Jenkins service
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins

## Adding Jenkins port in firewall
##echo "Opening port 8080 for Jenkins..."
##sudo firewall-cmd --add-port=8080/tcp --permanent
##sudo firewall-cmd --reload

echo "✅ Jenkins installation and setup completed successfully!"
echo "Access Jenkins at: http://<your-server-ip>:8080"


