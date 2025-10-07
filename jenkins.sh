#!/bin/bash
## First we add repos
echo "Adding Jenkins repo..."
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

## Importing the key for Jenkins
echo "Importing key..."
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
if [[ $? == 0 ]]; then
  echo "Key Imported"
else
  echo "Key Importing Failed"
  exit 1
fi

## Update the new package list including Jenkins
echo "Updating the packages..."
sudo yum upgrade -y

## Add required dependencies for the Jenkins package
echo "Installing dependencies..."
sudo yum install -y fontconfig java-21-openjdk
if [[ $? == 0 ]]; then 
  echo "Dependencies installed successfully. Installing Jenkins..."
else
  echo "Failed to install dependencies. Check the logs."
  exit 1
fi

## Installing Jenkins
sudo yum install -y jenkins

## Start and enable the Jenkins service
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins

## Adding Jenkins port in firewall
echo "Opening port 8080 for Jenkins..."
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

echo "✅ Jenkins installation and setup completed successfully!"
echo "Access Jenkins at: http://<your-server-ip>:8080"
