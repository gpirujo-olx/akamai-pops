echo Regenerating map
geopref="05-locations"
web="index.html"

cat "pre.html" >$web
cat "$geopref"/[0-9]* |
while read line
do
    echo "            new google.maps.Marker({position: new google.maps.LatLng($line)}),"
done >>$web
cat "post.html" >>$web
