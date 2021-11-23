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
for key in ${!params[@]}; 
do
    output+=$key';'
done
output=${output%?}

echo $output >> $_fileout

for j in $(cat $_filein);

do 
    _whois=$(whois $j)
    for k in ${!params[@]}
     do    
    
      _tmp=$(echo "$_whois" | grep $k | sed s/$k://g)
      params[$k]=$_tmp
     done;


       output=$j';'
for key in ${!params[@]}; 
do
      output+=${params[$key]}';'
      
done
output=${output%?}

echo $output >> $_fileout

done