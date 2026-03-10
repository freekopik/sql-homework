#!/bin/bash
DB_NAME="hh_db"
DB_USER="hh_admin"
TARGET_CONTAINER="hh_postgres_db"

echo "📊 Анализ размеров таблиц и индексов в $TARGET_CONTAINER..."
echo "------------------------------------------------------------------"

docker exec -i $TARGET_CONTAINER psql -U $DB_USER -d $DB_NAME -c "
SELECT 
    relname AS table_name, 
    reltuples::bigint AS row_count, 
    pg_size_pretty(pg_table_size(c.oid)) AS data_size, 
    pg_size_pretty(pg_indexes_size(c.oid)) AS index_size, 
    pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size,
    ROUND((100 * pg_indexes_size(c.oid) / NULLIF(pg_total_relation_size(c.oid), 0))::numeric, 1) || '%' AS index_ratio
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public' 
  AND c.relkind = 'r'
ORDER BY pg_total_relation_size(c.oid) DESC;"
