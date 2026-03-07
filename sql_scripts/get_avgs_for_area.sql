SELECT 
    a.title AS region,
    res.total_vacancies,
    res.avg_from,
    res.avg_to,
    res.avg_market
FROM (
    SELECT 
        va.area_id,
        COUNT(*) AS total_vacancies,
        ROUND(AVG(compensation_from), 0) AS avg_from,
        ROUND(AVG(compensation_to), 0) AS avg_to,
        ROUND(AVG((COALESCE(compensation_from, compensation_to) + COALESCE(compensation_to, compensation_from)) / 2.0), 0) AS avg_market
    FROM vacancies v
    JOIN vacancy_areas va ON v.id = va.vacancy_id
    WHERE v.has_compensation = true AND v.status_id = 2
    GROUP BY va.area_id
) res
JOIN areas a ON res.area_id = a.id
ORDER BY avg_market DESC;
