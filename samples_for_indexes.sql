-- 1. Просмотр списка вакансий работодателя
EXPLAIN ANALYZE 
SELECT v.title, e.title
FROM vacancies v
JOIN employers e ON e.id = v.employer_id
WHERE v.employer_id = 500;

-- 2. Поиск вакансий по конкретной специализации (фильтр в поиске)
EXPLAIN ANALYZE
SELECT v.title, e.title
FROM vacancies v
JOIN employers e ON v.employer_id = e.id
WHERE v.specialization_id = 1; 

-- 3. Поиск вакансий с указанной зарплатой в заданном диапазоне
EXPLAIN ANALYZE
SELECT title, compensation_from, compensation_to
FROM vacancies
WHERE has_compensation = true
    AND compensation_from BETWEEN 50000 AND 53000;

-- 4. Вывод ленты самых свежих вакансий на главной странице
EXPLAIN ANALYZE
SELECT title, created_at 
FROM vacancies 
ORDER BY created_at DESC 
LIMIT 20;

-- 5. Просмотр соискателем списка всех своих созданных резюме
EXPLAIN ANALYZE
SELECT title, created_at 
FROM resumes 
WHERE applicant_id = 777 
ORDER BY created_at DESC;

-- 6. Отображение подробного опыта работы при открытии конкретного резюме
EXPLAIN ANALYZE
SELECT eh.*, r.title AS resume_title
FROM experience_histories eh
JOIN resumes r ON r.id = eh.resume_id
WHERE eh.resume_id = 100;  

-- 7. Поиск кандидатов по ключевым словам в названии должности 
EXPLAIN ANALYZE
SELECT resume_id, position 
FROM experience_histories 
WHERE position ILIKE '%Blockchain%';

-- 8. Быстрое получение текущего места работы соискателя
EXPLAIN ANALYZE
SELECT * FROM experience_histories 
WHERE resume_id = 500 AND is_current = true;

-- 9. Проверка, нужен ли данный навык в данной вакансии
EXPLAIN ANALYZE
SELECT * FROM vacancy_skills 
WHERE vacancy_id = 100 AND skill_id = 5;

-- 10. Поиск всех вакансий, где требуется определенный навык (например, Python)
EXPLAIN ANALYZE
SELECT v.title 
FROM vacancies v
JOIN vacancy_skills vs ON v.id = vs.vacancy_id
WHERE vs.skill_id = 10;

-- 11. Проверка наличия конкретного навыка в резюме соискателя
EXPLAIN ANALYZE
SELECT * FROM resume_skills 
WHERE resume_id = 100 AND skill_id = 5;

-- 12. Поиск всех резюме, в которых указан конкретный навык
EXPLAIN ANALYZE
SELECT r.title 
FROM resumes r
JOIN resume_skills rs ON r.id = rs.resume_id
WHERE rs.skill_id = 10;

-- 13. Проверка, относится ли вакансия к конкретному городу/региону
EXPLAIN ANALYZE
SELECT vacancy_id, area_id 
FROM vacancy_areas 
WHERE vacancy_id = 500 AND area_id = 1;

-- 14. Подсчет количества вакансий в конкретном городе для аналитики
EXPLAIN ANALYZE
SELECT COUNT(*) 
FROM vacancy_areas 
WHERE area_id = 1;

-- 15. Проверка, оставлял ли уже этот соискатель отклик на эту вакансию
EXPLAIN ANALYZE
SELECT id, created_at 
FROM responses 
WHERE applicant_id = 500 AND vacancy_id = 123;

-- 16. Получение списка всех откликов для рекрутера внутри конкретной вакансии
EXPLAIN ANALYZE
SELECT
    r.id AS response_id,
    a.firstname,
    a.lastname,
    r.created_at AS response_date,
    res.title AS resume_title
FROM responses r
JOIN applicants a ON r.applicant_id = a.id
JOIN resumes res ON r.resume_id = res.id
WHERE r.vacancy_id = 123; 

-- 17. Просмотр соискателем истории своих откликов и их статусов
EXPLAIN ANALYZE
SELECT
    v.title AS vacancy_title,
    rs.title AS response_status,
    r.created_at AS response_date
FROM responses r
JOIN vacancies v ON r.vacancy_id = v.id
JOIN response_statuses rs ON r.response_status_id = rs.id
WHERE r.resume_id = 777;

-- 18. Отображение соискателю истории просмотров его резюме компаниями
EXPLAIN ANALYZE
SELECT 
    e.title, 
    rv.viewed_at
FROM resume_views rv
JOIN employers e ON rv.employer_id = e.id
WHERE rv.resume_id = 777
ORDER BY rv.viewed_at DESC;
