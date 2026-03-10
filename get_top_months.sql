(
    SELECT 
        'Вакансия' AS type,
        to_char(date_trunc('month', created_at), 'Month YYYY') AS month_name,
        COUNT(*) AS items_count
    FROM vacancies
    GROUP BY month_name
    ORDER BY items_count DESC
    LIMIT 1
)

UNION ALL

(
    SELECT 
        'Резюме' AS type,
        to_char(date_trunc('month', created_at), 'Month YYYY') AS month_name,
        COUNT(*) AS items_count
    FROM resumes
    GROUP BY month_name
    ORDER BY items_count DESC
    LIMIT 1
)

