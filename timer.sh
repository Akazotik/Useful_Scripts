mapfile -t dig < ip.txt

for i in ${!dig[*]}
do
 if  (($i % 4 == 0))  
 then
 sleep 3
 echo "Element [$i] ${dig[$i]}"
 else echo "Element [$i] ${dig[$i]}"
 fi
done