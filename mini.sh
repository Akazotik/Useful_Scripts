for i in $(cat ip.txt)
do
echo $i
a=$(whois $i )
echo "<=========>"
echo "$a" | egrep '\S+?:\s'
echo "<=========>" 
done>mimi2.csv


