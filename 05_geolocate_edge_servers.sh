echo Geolocating edge servers
con="04-unique-servers/list.txt"
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
