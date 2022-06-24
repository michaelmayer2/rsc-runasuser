# rsc-runasuser

This is a repository in order to reproduce an issue when running RunAsUser against EFS and/or FsX 

It assumes a FsX Lustre FS is available in `/scratch` while ab EFS is available in `/efs`.

This setup uses rstudio-connect docker container and combines them with an LDAP server.

Once `docker-compose` has run, there is two RSC instances available:
* Instance using FsX and listening at port 3939
* Instance using EFS and listening at port 3940

# Setup

You will need to have the environment variable `RSC_LICENSE` set to the license key for Connect.

```
# Install docker-compose if needed
if [ ! `which docker-compose` ]; then 
	apt-get update -y
	apt-get install -y docker.io docker-compose 
	systemctl start docker 
fi

# Modify sssd.conf to point to the correct LDAP server

ipaddr=`hostname`
sed -i "s#IPADDR#$ipaddr#" etc/sssd/sssd.conf

# Clean out any leftover from other installs
rm -rf /efs/rsc
rm -rf /scratch/rsc

docker-compose up -d 
``` 
