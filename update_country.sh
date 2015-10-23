echo Downloading dns server list
csv="01-csv/$1.csv"

curl -s http://public-dns.tk/nameserver/$1.csv >$csv

echo Looking for reliable name servers
rel="02-reliable-dns/$1.txt"

cat $csv |
while IFS=, read ip x x x x x x rel x
do
    if test "$rel" = "1.0"
    then
        echo $ip |
        egrep '\d+\.\d+\.\d+\.\d+'
    fi
done >$rel

echo Querying name servers
respref="03-dns-queries"

cat $rel |
while read dns
do
    res="$respref/$dns"
    if ! test -f $res
    then
        dig +short "@$dns" "olx.com.edgesuite.net" |
        egrep '\d+\.\d+\.\d+\.\d+' >$res
    fi
done
