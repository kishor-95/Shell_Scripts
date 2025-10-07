#!bin/bash
## Frist we add  repos
echo "adding jenkins repo" 
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

## Importing the key for jenkins 
echo "Importing key......"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
if [[ $? == 0 ]] 
then
  echo "Key Imported"
else
  echo "Key Imporing Failed"
  exit 1;
fi
## Update the new package including jenkins 
echo "Updateing the packages"
sudo yum upgrade -y

# Add required dependencies for the jenkins package
sudo yum install fontconfig java-21-openjdk
if [[ $? == 0 ]]
then 
  echo "Dependenicies are installed now Installaing Jenkins"
else
  echo "Failed to install depedenicies check the logs"
  exit 1;
fi
## Installing the jenkins
sudo yum install jenkins
## start and enable the service 
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins

## Adding jenkins port in firewall
sudo firewall-cmd --add-port=8080/tcp --permant
sudo firewall-cmd --reload
