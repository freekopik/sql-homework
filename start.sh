#!/bin/bash

echo "🏗️ Пересборка контейнеров..."
docker compose build --no-cache
docker compose up -d

echo -n "⏳ Ожидание готовности PostgreSQL... "
SECONDS=0
while ! docker exec hh_postgres_db pg_isready -U hh_admin > /dev/null 2>&1; do
    printf "\r⏳ Ожидание готовности... (%02d сек)" "$SECONDS"
    sleep 1
    ((SECONDS++))
done
echo -e "\n☕ Даем базе 3 секунды на финальную инициализацию..."
sleep 3

./sync_data.sh
./hashes_comparison.sh

echo -e "\n🚀 Всё готово! Запускаем ./benchmark.sh"

./benchmark.sh
