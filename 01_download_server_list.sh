echo "Downloading dns server list for $1"
csv="01-csv/$1.csv"

curl -s http://public-dns.tk/nameserver/$1.csv >$csv
