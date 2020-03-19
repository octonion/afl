#!/bin/bash

psql arf -c "drop table if exists afl.results;"

psql arf -f sos/standardized_results.sql

psql arf -c "vacuum full verbose analyze afl.results;"

psql arf -c "drop table if exists afl._basic_factors;"
psql arf -c "drop table if exists afl._parameter_levels;"

R --vanilla -f sos/lmer.R

psql arf -c "vacuum full verbose analyze afl._parameter_levels;"
psql arf -c "vacuum full verbose analyze afl._basic_factors;"

psql arf -f sos/normalize_factors.sql
psql arf -c "vacuum full verbose analyze afl._factors;"

psql arf -f sos/schedule_factors.sql
psql arf -c "vacuum full verbose analyze afl._schedule_factors;"

psql arf -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv

psql arf -f sos/predictions.sql > sos/predictions.txt
cp /tmp/predictions.csv sos/predictions.csv
