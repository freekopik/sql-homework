SELECT 
    v.id AS vacancy_id,
    v.title AS vacancy_title,
    COUNT(r.id) AS responses_cnt
FROM vacancies v
JOIN responses r ON r.vacancy_id = v.id
WHERE r.created_at <= v.created_at + interval '7 days'
GROUP BY v.id, v.title
HAVING 
    COUNT(r.id) > 5
ORDER BY responses_cnt DESC
LIMIT 100
