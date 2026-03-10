#!/bin/bash

DB_NAME="hh_postgres_db"
ANALYTICS_FILES=("get_avgs_for_area.sql" "get_top_months.sql" "get_top_vacancies.sql")

echo "📊 Запуск аналитических отчетов..."
echo "--------------------------------------------------"

for file in "${ANALYTICS_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "📄 Выполнение: $file"
        docker exec -i $DB_NAME psql -U hh_admin -d hh_db -q < "$file"
        echo "--------------------------------------------------"
    else
        echo "⚠️  Файл $file не найден!"
    fi
done

echo "✅ Все отчеты сформированы."
