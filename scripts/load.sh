#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'arf';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb arf;"
   eval $cmd
fi

psql arf -f schema/create_schema.sql

mkdir /tmp/data
cp csv/afl*.csv /tmp/data

dos2unix /tmp/data/*
tail -q -n+2 /tmp/data/*.csv >> /tmp/games.csv
sed -e 's/$/,,/' -i /tmp/games.csv

rpl "GWS GIANTS" "GWS Giants" /tmp/games.csv
rpl "Gold Coast SUNS" "Gold Coast Suns" /tmp/games.csv

psql arf -f loaders/load_games.sql

rm /tmp/data/*.csv
rmdir /tmp/data
rm /tmp/games.csv
