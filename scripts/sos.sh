#!/bin/bash

psql afl -c "drop table if exists afl.results;"

psql afl -f sos/standardized_results.sql

psql afl -c "vacuum full verbose analyze afl.results;"

psql afl -c "drop table if exists afl._basic_factors;"
psql afl -c "drop table if exists afl._parameter_levels;"

#R --vanilla -f sos/lmer.R
R -f sos/lmer.R

psql afl -c "vacuum full verbose analyze afl._parameter_levels;"
psql afl -c "vacuum full verbose analyze afl._basic_factors;"

psql afl -f sos/normalize_factors.sql
psql afl -c "vacuum full verbose analyze afl._factors;"

psql afl -f sos/schedule_factors.sql
psql afl -c "vacuum full verbose analyze afl._schedule_factors;"

psql afl -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv

psql afl -f sos/predictions.sql > sos/predictions.txt
cp /tmp/predictions.csv sos/predictions.csv
