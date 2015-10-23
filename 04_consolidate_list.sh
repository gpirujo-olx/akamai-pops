echo Consolidating edge server list
respref="03-dns-queries"
con="04-unique-servers/list.txt"

for i in $(seq 1 255)
do
    cat "$respref/$i".*.*.* 2>/dev/null
done |
sort |
uniq |
egrep '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' >$con
