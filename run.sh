for country in ae ar bg bh bo by cm co cr de dz ec eg gh gt hn ho id in ir jo ke kw kz lb ly ma ng ni om pa pe ph pk pl pt py qa ro sa sn sv tn tz ua ug uy ve za
do
    echo ===========
    echo UPDATING $country
    sh update_country.sh $country
done

echo ===========
echo UPDATING MAP
sh update_map.sh
