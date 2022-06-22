function create_user() 
{
echo "dn: cn=rsc_group`printf %02i $1`,dc=example,dc=org"
echo "gidnumber: $(( 600+$1 ))"
cat << EOF 
objectclass: posixGroup
objectclass: top
EOF
echo -e "\n\n"

echo "dn: cn=rsc_group`printf %02i $1`,dc=example,dc=org"
cat << EOF 
changetype: modify
add: memberuid
memberuid: test
EOF
echo -e "\n\n"

}

for i in `seq 1 32`
do
create_user $i
done
