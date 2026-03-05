#!/bin/bash
TOTAL_START=$(date +%s)
DB_NO_IDX="hh_postgres_db_no_index"
DB_WITH_IDX="hh_postgres_db"
DATA_FILE="test_data.sql" 

start_timer() {
    T_START=$(date +%s)
    (
        while true; do
            T_NOW=$(date +%s)
            T_DIFF=$((T_NOW - T_START))
            printf "\r⏳ Прошло времени: %02d:%02d" $((T_DIFF/60)) $((T_DIFF%60))
            sleep 0.5 
        done
    ) &
    TIMER_PID=$!
}

stop_timer() {
    T_END=$(date +%s)
    T_DIFF=$((T_END - T_START))
    kill $TIMER_PID 2>/dev/null
    wait $TIMER_PID 2>/dev/null
    printf "\r⏳ Прошло времени: %02d:%02d\n" $((T_DIFF/60)) $((T_DIFF%60))
}

echo "📥 [1/3] Генерация данных в базу без индексов..."
start_timer
docker exec -i $DB_NO_IDX psql -U hh_admin -d hh_db < "$DATA_FILE" > /dev/null 2>&1
stop_timer

echo "📤 [2/3] Синхронизация данных между контейнерами..."
start_timer
docker exec -t $DB_NO_IDX pg_dump -U hh_admin -d hh_db --data-only --disable-triggers | \
docker exec -i $DB_WITH_IDX psql -U hh_admin -d hh_db > /dev/null 2>&1
stop_timer

echo "📊 [3/3] Обновление статистики (ANALYZE)..."
docker exec -i $DB_WITH_IDX psql -U hh_admin -d hh_db -c "ANALYZE;" > /dev/null

TOTAL_END=$(date +%s)
echo -e "🚀 Подготовка завершена за $((TOTAL_END - TOTAL_START)) сек."
