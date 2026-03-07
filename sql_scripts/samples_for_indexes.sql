EXPLAIN ANALYZE SELECT * FROM vacancies WHERE employer_id = 50;

EXPLAIN ANALYZE SELECT * FROM vacancies WHERE specialization_id = 10;

EXPLAIN ANALYZE SELECT * FROM vacancies WHERE has_compensation = true AND compensation_from > 100000;

EXPLAIN ANALYZE SELECT * FROM vacancies ORDER BY created_at DESC LIMIT 10;

EXPLAIN ANALYZE SELECT * FROM resumes WHERE applicant_id = 500;

EXPLAIN ANALYZE SELECT * FROM resumes WHERE specialization_id = 5;

EXPLAIN ANALYZE SELECT * FROM experience_histories WHERE resume_id = 1000;

EXPLAIN ANALYZE SELECT * FROM experience_histories WHERE position ILIKE '%blockchain%';

EXPLAIN ANALYZE SELECT * FROM experience_histories WHERE resume_id = 1000 AND is_current = true;

EXPLAIN ANALYZE SELECT * FROM vacancy_skills WHERE skill_id = 25;

EXPLAIN ANALYZE SELECT * FROM resume_skills WHERE skill_id = 25;

EXPLAIN ANALYZE SELECT * FROM vacancy_areas WHERE area_id = 1;

EXPLAIN ANALYZE SELECT * FROM responses WHERE vacancy_id = 123;

EXPLAIN ANALYZE SELECT * FROM responses WHERE resume_id = 300;

EXPLAIN ANALYZE SELECT * FROM resume_views WHERE resume_id = 300;