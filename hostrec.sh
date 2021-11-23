readarray -t timer < domain.txt
for ip in ${!timer[*]}
do
if (($ip%10!=0))
then
echo ${timer[$ip]}
echo "<================>"
soa=$(host -C ${timer[$ip]} 8.8.8.8) 
echo $soa | sed s/^.*"record"/\\t/g | sed s/";;".*//g
any=$(echo $soa | sed s/^.*"record"//g | sed s/";;".*//g)
a=$(host -t A ${timer[$ip]} $any)
olo=$(echo $a | sed s/"${timer[$ip]} has address "//g | sed s/^.*":"//g)
ns=$(host -t NS ${timer[$ip]} $any)
mx=$(host -t MX ${timer[$ip]} $any)
txt=$(host -t TXT ${timer[$ip]} $any)
echo $a | sed s/"${timer[$ip]} has address "//g | sed s/^.*":"/"A= \\t"/g
echo $ns | sed s/"${timer[$ip]} name server"//g | sed s/^.*":"/"NS= \\t"/g
echo $mx | sed s/"${timer[$ip]} mail is handled by"//g | sed s/^.*":"/"MX= \\t"/g
echo $txt | sed s/"${timer[$ip]} descriptive text"//g | sed s/^.*":"/"TXT= \\t"/g
for i in $olo
do
ptr=$(host $i)
echo "PTR= "$ptr | sed s/"PTR= "/"PTR= \\t"/g
done
echo "<================>"

else
echo "10 element"
sleep 10
echo ${timer[$ip]}
echo "<================>"
soa=$(host -C ${timer[$ip]} 8.8.8.8) 
echo $soa | sed s/^.*"record"/\\t/g | sed s/";;".*//g
any=$(echo $soa | sed s/^.*"record"//g | sed s/";;".*//g)
a=$(host -t A ${timer[$ip]} $any)
olo=$(echo $a | sed s/"${timer[$ip]} has address "//g | sed s/^.*":"//g)
ns=$(host -t NS ${timer[$ip]} $any)
mx=$(host -t MX ${timer[$ip]} $any)
txt=$(host -t TXT ${timer[$ip]} $any)
echo $a | sed s/"${timer[$ip]} has address "//g | sed s/^.*":"/"A= \\t"/g
echo $ns | sed s/"${timer[$ip]} name server"//g | sed s/^.*":"/"NS= \\t"/g
echo $mx | sed s/"${timer[$ip]} mail is handled by"//g | sed s/^.*":"/"MX= \\t"/g
echo $txt | sed s/"${timer[$ip]} descriptive text"//g | sed s/^.*":"/"TXT= \\t"/g
for i in $olo
do
ptr=$(host $i)
echo "PTR= "$ptr | sed s/"PTR= "/"PTR= \\t"/g
done
echo "<================>"
fi
done>hostrec.csv 
pandoc -s hostrec.csv -o hostrec.pdf