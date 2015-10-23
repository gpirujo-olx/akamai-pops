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
