if [ ! `which docker` ]; then 
	apt-get update -y
	apt-get install -y docker.io 
	systemctl start docker 
fi

docker ps | grep -v CONT | awk '{print $1}' | xargs docker kill

docker run -p 389:389 -p 636:636 --env LDAP_ADMIN_PASSWORD="secret" --env LDAP_TLS=false --detach osixia/openldap

sleep 5 

#add vanilla users and groups 

ldapadd -H ldap://ip-172-31-42-109 -x -w secret -D "cn=admin,dc=example,dc=org" -f users.ldif

# create groups rsc_group01..32 and add test user to it

bash add-groups.sh > new.ldif
ldapadd -H ldap://ip-172-31-42-109 -x -w secret -D "cn=admin,dc=example,dc=org" -f new.ldif

# make sure that something somehow works ;) 

ldapsearch -x -H ldap://ip-172-31-42-109 -b dc=example,dc=org -D "cn=admin,dc=example,dc=org" -w secret

export RSC_LICENSE=3ICD-YGR2-4I28-SCMD-6KVI-EU5R-XETA

# Run docker container and modify/configure sssd 

rm -rf /efs/rsc

docker run -it --privileged \
    -p 3939:3939 \
    -v /efs/rsc:/data \
    -v $PWD/etc/sssd/sssd.conf:/etc/sssd/sssd.conf \
    -v $PWD/etc/pam.d/rstudio-connect:/etc/pam.d/rstudio-connect \
    -v $PWD/etc/rstudio-connect/rstudio-connect.gcfg:/etc/rstudio-connect/rstudio-connect.gcfg \
    -v $PWD/usr/local/bin/startup.sh:/usr/local/bin/startup.sh \
    -e RSC_LICENSE=$RSC_LICENSE -d \
    rstudio/rstudio-connect:latest

rm -rf /scratch/rsc

docker run -it --privileged \
    -p 3940:3939 \
    -v /scratch/rsc:/data \
    -v $PWD/etc/sssd/sssd.conf:/etc/sssd/sssd.conf \
    -v $PWD/etc/pam.d/rstudio-connect:/etc/pam.d/rstudio-connect \
    -v $PWD/etc/rstudio-connect/rstudio-connect.gcfg:/etc/rstudio-connect/rstudio-connect.gcfg \
    -v $PWD/usr/local/bin/startup.sh:/usr/local/bin/startup.sh \
    -e RSC_LICENSE=$RSC_LICENSE -d \
    rstudio/rstudio-connect:latest

