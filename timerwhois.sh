declare -A params


_fileout=""
_filein=""

for i in $@
do
    if [ $1 == $i ]
    then
    _fileout=$i
     else
                if [ $2 == $i ]
            then
            _filein=$i
            else
            params[${i}]=""
            fi
    fi
done

echo -n > $_fileout

output='IP;'
for key in ${!params[@]}
do
    output+=$key';'
done
output=${output%?}

echo $output >> $_fileout

mapfile -t timer < $_filein

for j in  ${!timer[*]}

do 
if (($j%4!=0))
then
echo "it is not 4 element"
echo [$j}":" ${timer[$j]}
    _whois=$(whois ${timer[$j]})
    for k in ${!params[@]}
     do    
    
      _tmp=$(echo "$_whois" | grep $k | sed s/$k://g)
      params[$k]=$_tmp
     done;


       output=${timer[$j]}';'
for key in ${!params[@]}
do
      output+=${params[$key]}';'
      
done
else 
echo "it is 4 element"
sleep 3
echo [$j}":" ${timer[$j]}
 _whois=$(whois ${timer[$j]})
    for k in ${!params[@]}
     do    
    
      _tmp=$(echo "$_whois" | grep $k | sed s/$k://g)
      params[$k]=$_tmp
     done;


       output=${timer[$j]}';'
for key in ${!params[@]}
do
      output+=${params[$key]}';'
      
done
fi
output=${output%?}

echo $output >> $_fileout

done
