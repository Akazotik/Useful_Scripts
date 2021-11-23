for ip in $(cat domain.txt)
do
echo $ip
echo '<================>'
soa=$(host -C $ip 8.8.8.8) 
echo $soa | sed s/^.*"record"//g | sed s/^.*":"//g
olo=$(echo $soa | sed s/^.*"record"//g | sed s/^.*":"//g)
any=$(host -a $ip $olo)
echo $any |sed s/^.*";; ANSWER SECTION:"//g |sed s/'IN'/\\n/g 
echo '<================>'
done>hostany.csv


