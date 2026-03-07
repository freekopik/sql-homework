#!/bin/bash

DB_NO_IDX="hh_postgres_db_no_index"
DB_WITH_IDX="hh_postgres_db"
SQL_FILE="samples_for_indexes.sql"
OUT_NO_IDX="results_no_indexes.txt"
OUT_WITH_IDX="results_with_indexes.txt"

docker exec -i $DB_NO_IDX psql -U hh_admin -d hh_db < $SQL_FILE > $OUT_NO_IDX
docker exec -i $DB_WITH_IDX psql -U hh_admin -d hh_db < $SQL_FILE > $OUT_WITH_IDX

mapfile -t descriptions < <(grep "^-- " "$SQL_FILE" | sed 's/^-- [0-9.]* //')
no_idx_times=($(grep "Execution Time" $OUT_NO_IDX | awk '{print $3}'))
with_idx_times=($(grep "Execution Time" $OUT_WITH_IDX | awk '{print $3}'))

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "\n=== PERFORMANCE REPORT ==="
TMP_TABLE=$(mktemp)
echo "№|БИЗНЕС-ЗАДАЧА|BEFORE (ms)|AFTER (ms)|SPEEDUP" > "$TMP_TABLE"

for i in {0..17}; do
  num=$((i+1))
  desc=${descriptions[$i]}
  n=${no_idx_times[$i]}
  w=${with_idx_times[$i]}
  
  speedup=$(awk "BEGIN {
    ratio = $n / $w;
    if (ratio >= 1.2) printf \"${GREEN}%.1fx${NC}\", ratio;
    else if (ratio <= 0.8) printf \"${RED}%.1fx${NC}\", ratio;
    else printf \"%.1fx\", ratio;
  }")
  
  echo -e "$num|$desc|$n|$w|$speedup" >> "$TMP_TABLE"
done

column -t -s "|" "$TMP_TABLE"
rm "$TMP_TABLE"
echo "------------------------------------------------------------------------------------------------------"
