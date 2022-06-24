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

# Test Users 

* users `test1` and `test2` (password same as username). 
* both users belong to group `rstudio-connect` and groups `rsc_group01...32`
* users `john`, `julie`, `jen`, `ashley`, ... only belong to two groups

```
uid=1005(test1) gid=500(rstudio-connect) groups=500(rstudio-connect),601(rsc_group01),602(rsc_group02),603(rsc_group03),604(rsc_group04),605(rsc_group05),606(rsc_group06),607(rsc_group07),608(rsc_group08),609(rsc_group09),610(rsc_group10),611(rsc_group11),612(rsc_group12),613(rsc_group13),614(rsc_group14),615(rsc_group15),616(rsc_group16),617(rsc_group17),618(rsc_group18),619(rsc_group19),620(rsc_group20),621(rsc_group21),622(rsc_group22),623(rsc_group23),624(rsc_group24),625(rsc_group25),626(rsc_group26),627(rsc_group27),628(rsc_group28),629(rsc_group29),630(rsc_group30),631(rsc_group31),632(rsc_group32)
uid=1007(test2) gid=500(rstudio-connect) groups=500(rstudio-connect),601(rsc_group01),602(rsc_group02),603(rsc_group03),604(rsc_group04),605(rsc_group05),606(rsc_group06),607(rsc_group07),608(rsc_group08),609(rsc_group09),610(rsc_group10),611(rsc_group11),612(rsc_group12),613(rsc_group13),614(rsc_group14),615(rsc_group15),616(rsc_group16),617(rsc_group17),618(rsc_group18),619(rsc_group19),620(rsc_group20),621(rsc_group21),622(rsc_group22),623(rsc_group23),624(rsc_group24),625(rsc_group25),626(rsc_group26),627(rsc_group27),628(rsc_group28),629(rsc_group29),630(rsc_group30),631(rsc_group31),632(rsc_group32)
uid=1004(jen) gid=500(rstudio-connect) groups=500(rstudio-connect),503(support_group)
``` 


