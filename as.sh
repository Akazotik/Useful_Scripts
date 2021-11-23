for as in $(cat as.txt):
do echo -e $as;
fields=$(whois -h whois.radb.net -i origin $as | egrep 'route:|route6:|descr:')
echo $fields | sed s/'route:'/\\r/g | sed s/'route6:'/\\n/g | sed s/'descr:'/\\t/g
done>as.csv
