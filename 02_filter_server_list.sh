echo "Looking for reliable name servers for $1"
csv="01-csv/$1.csv"
rel="02-reliable-dns/$1.txt"

cat $csv |
while IFS=, read ip x x x x x x r x
do
    if test "$r" = "1.0"
    then
        echo $ip |
        egrep '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
    fi
done >$rel
