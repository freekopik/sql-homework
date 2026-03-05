#!/bin/bash
TABLES="areas applicants employers vacancies resumes experience_histories vacancy_skills resume_skills responses resume_views"
FILE_NO_IDX="hashes_no_indexes.txt"
FILE_WITH_IDX="hashes_with_indexes.txt"

rm -f $FILE_NO_IDX $FILE_WITH_IDX

get_table_hash() {
    local container=$1
    local table=$2
    local order_col="id"
    
    [[ "$table" == "vacancy_skills" ]] && order_col="vacancy_id, skill_id"
    [[ "$table" == "resume_skills" ]] && order_col="resume_id, skill_id"

    docker exec -i "$container" psql -U hh_admin -d hh_db -t -c \
    "SELECT md5(string_agg(h, '')) FROM (SELECT md5(t::text) as h FROM (SELECT * FROM $table ORDER BY $order_col) t) sub;" | xargs
}

echo "=== Сбор хэшей из hh_postgres_db_no_index (Эталон) ==="
for table in $TABLES; do
    hash=$(get_table_hash "hh_postgres_db_no_index" "$table")
    echo "$table:$hash" >> $FILE_NO_IDX
    echo "✅ Снята проба: $table"
done

echo -e "\n=== Сбор хэшей из hh_postgres_db (Оптимизированная) ==="
for table in $TABLES; do
    hash=$(get_table_hash "hh_postgres_db" "$table")
    echo "$table:$hash" >> $FILE_WITH_IDX
    echo "✅ Снята проба: $table"
done

echo -e "\n=== СРАВНЕНИЕ РЕЗУЛЬТАТОВ ==="
echo "Таблица              | Статус"
echo "-----------------------------------"
while IFS=: read -r table ref_hash; do
    current_hash=$(grep "^$table:" $FILE_WITH_IDX | cut -d: -f2)
    
    if [[ "$ref_hash" == "$current_hash" && -n "$ref_hash" ]]; then
        printf "%-20s | ✅ СОВПАДАЕТ\n" "$table"
    else
        printf "%-20s | ❌ ОШИБКА\n" "$table"
    fi
done < $FILE_NO_IDX
