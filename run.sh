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

echo Consolidating edge server list
con="04-unique-servers/list.txt"

for i in $(seq 1 255)
do
    cat "$respref"/$i.*.*.* 2>/dev/null
done |
sort |
uniq |
egrep '^\d+\.\d+\.\d+\.\d+$' >$con

echo Geolocating edge servers
geopref="05-locations"

cat $con |
while read ip
do
    geo="$geopref/$ip"
    if ! test -f $geo
    then
        curl -s -H "X-Forwarded-For: $ip" "http://dev.olx.com/edgescape.php" |
        grep -e ^lat= -e ^long= |
        sort |
        xargs echo |
        sed 's/lat=\(.*\) long=\(.*\)/\1,\2/' >$geo
    fi
done

echo Regenerating map
web="index.html"

cat "pre.html" >$web
cat "$geopref"/[0-9]* |
while read line
do
    echo "            new google.maps.Marker({position: new google.maps.LatLng($line)}),"
done >>$web
cat "post.html" >>$web
