readarray -t timer < domain.txt
for ip in ${!timer[*]}
do
if (($ip%10!=0))
then
soa=$(dig  @8.8.8.8 ${timer[$ip]} soa +short)
a=$(dig @$soa ${timer[$ip]} a  +short)
ns=$(dig @$soa ${timer[$ip]} ns +short)
mx=$(dig @$soa ${timer[$ip]} mx +short)
txt=$(dig @$soa ${timer[$ip]} txt +short)
declare -a dig
dig=("soa="$soa, "a="$a, "ns="$ns,"mx="$mx, "txt="$txt)
echo ${timer[$ip]}
echo "<================>"
for key in "${dig[*]}";
do
echo $key | sed s/","/\\n/g
echo "<================>"
done
else
echo "10 element"
soa=$(dig  @8.8.8.8 ${timer[$ip]} soa +short)
a=$(dig @$soa ${timer[$ip]} a  +short)
ns=$(dig @$soa ${timer[$ip]} ns +short)
mx=$(dig @$soa ${timer[$ip]} mx +short)
txt=$(dig @$soa ${timer[$ip]} txt +short)
declare -a dig
dig=("soa="$soa, "a="$a, "ns="$ns,"mx="$mx, "txt="$txt)
echo ${timer[$ip]}
echo "<================>"
for key in "${dig[*]}";
do
echo $key | sed s/","/\\n/g
echo "<================>"
done
fi
done>dig.csv
