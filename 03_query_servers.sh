#echo "Querying name servers for $1"
rel="02-reliable-dns/$1.txt"
respref="03-dns-queries"

cat $rel |
while read dns
do
    res="$respref/$dns"
    if ! test -f "$res"
    then
        dig +short "@$dns" "olx.com.edgesuite.net" |
        egrep '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' >$res
        echo -n .
    fi
done
echo
