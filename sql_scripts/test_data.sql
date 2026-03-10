DO $$
DECLARE
    v_now timestamp := date_trunc('minute', now());
BEGIN

INSERT INTO genders (title) VALUES ('Неизвестно'), ('Мужской'), ('Женский'), ('Не применимо');
INSERT INTO vacancy_statuses (title) VALUES ('Черновик'), ('Активна'), ('Архив'), ('Заблокирована');
INSERT INTO education_levels (title) VALUES ('Среднее'), ('Среднее специальное'), ('Высшее'), ('Магистр'), ('Кандидат наук');
INSERT INTO employment_types (title) VALUES ('Полная занятость'), ('Частичная'), ('Проектная работа'), ('Стажировка');
INSERT INTO work_modes (title) VALUES ('Офис'), ('Удаленка'), ('Гибрид');
INSERT INTO work_schedules (title) VALUES ('Полный день'), ('Сменный график'), ('Гибкий график');
INSERT INTO work_hours (title) VALUES ('8 часов в день'), ('4 часа в день'), ('12 часов в день'), ('По договоренности');
INSERT INTO contract_types (title) VALUES ('ТК РФ'), ('ГПХ'), ('Самозанятость'), ('ИП');
INSERT INTO payout_schedules (title) VALUES ('2 раза в месяц'), ('Еженельно'), ('Ежедневно');
INSERT INTO response_statuses (title) VALUES ('Новый'), ('Просмотрен'), ('Интервью'), ('Оффер'), ('Отказ');

INSERT INTO areas (title) VALUES ('Москва'), ('Санкт-Петербург'), ('Казань'), ('Екатеринбург'), ('Новосибирск'), ('Краснодар'), ('Нижний Новгород');
INSERT INTO areas (title) 
SELECT 'City_' || i FROM generate_series(1, 100) s(i);

INSERT INTO industries (title) VALUES ('IT'), ('Маркетинг'), ('Продажи'), ('Медицина'), ('Финансы');

INSERT INTO specializations (title, industry_id) 
VALUES ('Backend', 1), ('Frontend', 1), ('Data Science', 1), ('SMM', 2), ('Sales', 3);

INSERT INTO specializations (title, industry_id) 
SELECT 
    'Spec_' || i, 
    floor(random() * 5 + 1) 
FROM (SELECT i FROM generate_series(1, 500) i ORDER BY i OFFSET 0) s;

INSERT INTO skills (title) 
VALUES ('Python'), ('SQL'), ('PostgreSQL'), ('Docker'), ('Git'), ('React'), ('FastAPI'), ('Linux');

INSERT INTO skills (title) 
SELECT 'Skill_' || i FROM generate_series(1, 1000) s(i);

INSERT INTO employers (title, is_verified, rating, email, created_at)
SELECT 
    'Company ' || i, 
    (random() > 0.4), 
    (random() * 5), 
    'hr' || i || '@test.com', 
    v_now 
FROM (SELECT i FROM generate_series(1, 1000) i ORDER BY i OFFSET 0) s;

INSERT INTO vacancies (
    title, 
    employer_id, 
    status_id, 
    specialization_id, 
    is_experience_needed, 
    experience_from, 
    experience_to,
    has_compensation,
    compensation_from, 
    compensation_to,
    created_at
)
SELECT 
    (ARRAY['Разработчик', 'Аналитик', 'Менеджер', 'Тимлид', 'Дизайнер'])[floor(random() * 5 + 1)] || ' #' || s.i,
    floor(random() * 1000 + 1),        
    floor(random() * 4 + 1),           
    floor(random() * 505 + 1),         
    true,
    floor(random() * 3),
    floor(random() * 3 + 4),
    true,
    floor((50000 + random() * 50000) * (1 + (s.i % 10) * 0.1)), 
    floor((110000 + random() * 140000) * (1 + (s.i % 10) * 0.1)),
    now() - (random() * interval '365 days')
FROM generate_series(1, 100000) s(i);

INSERT INTO applicants (firstname, lastname, gender_id, email, created_at)
SELECT 
    'Name_' || i, 
    'Lastname_' || i, 
    floor(random() * 4 + 1), 
    'user' || i || '@mail.ru', 
    v_now 
FROM (SELECT i FROM generate_series(1, 150000) i ORDER BY i OFFSET 0) s;

INSERT INTO resumes (title, specialization_id, applicant_id, compensation_from, created_at)
SELECT 
    'Резюме ' || i, 
    floor(random() * 505 + 1), 
    floor(random() * 150000 + 1), 
    floor(random() * 16 + 4) * 10000, 
    v_now - (random() * interval '365 days') 
FROM (SELECT i FROM generate_series(1, 500000) i ORDER BY i OFFSET 0) s(i);

INSERT INTO experience_histories (resume_id, company_title, position, description, start_date, end_date, is_current)
SELECT 
    base.id, 
    (ARRAY['Сбер', 'Яндекс', 'Т-Банк', 'Озон', 'Хэдхантер', 'ВТБ', 'Газпромбанк'])[floor(random() * 7 + 1)] || ' #' || base.id,
    (ARRAY['Middle ', 'Senior ', 'Lead '])[floor(random() * 3 + 1)] || (ARRAY['Developer', 'Analyst', 'QA'])[floor(random() * 3 + 1)],
    'Описание опыта для резюме ' || base.id,
    v_now - (random() * interval '10 years'), 
    v_now - (random() * interval '4 years'),
    false 
FROM (
    SELECT r.id 
    FROM (SELECT id FROM resumes ORDER BY id OFFSET 0) r 
    CROSS JOIN generate_series(1, 2)
    ORDER BY r.id OFFSET 0
) base;

INSERT INTO experience_histories (resume_id, company_title, position, description, start_date, is_current)
SELECT 
    sub.id, 
    'Current Place #' || sub.id,
    'Senior Specialist',
    'Current responsibilities',
    v_now - (random() * interval '2 years'),
    true
FROM (SELECT id FROM resumes ORDER BY id OFFSET 0) sub 
WHERE (random() > 0.3);

INSERT INTO resume_skills (resume_id, skill_id)
SELECT 
    r.id, 
    s.id 
FROM (SELECT id FROM resumes WHERE id % 10 = 0 ORDER BY id OFFSET 0) r 
CROSS JOIN LATERAL (
    SELECT id FROM (SELECT id FROM skills ORDER BY id OFFSET 0) sk 
    ORDER BY random() 
    LIMIT 5
) s 
ON CONFLICT DO NOTHING;

INSERT INTO resume_views (resume_id, employer_id, viewed_at)
SELECT 
    id, 
    floor(random() * 1000 + 1), 
    created_at + (random() * interval '30 days')
FROM (SELECT id, created_at FROM resumes WHERE id % 50 = 0 ORDER BY id OFFSET 0) r;

INSERT INTO vacancy_areas (vacancy_id, area_id)
SELECT 
    id, 
    floor(random() * 107 + 1) 
FROM (SELECT id FROM vacancies ORDER BY id OFFSET 0) v 
ON CONFLICT DO NOTHING;

INSERT INTO vacancy_skills (vacancy_id, skill_id)
SELECT 
    v.id, 
    s.id 
FROM (SELECT id FROM vacancies WHERE id % 2 = 0 ORDER BY id OFFSET 0) v 
CROSS JOIN LATERAL (
    SELECT id FROM (SELECT id FROM skills ORDER BY id OFFSET 0) sk 
    ORDER BY random() 
    LIMIT 10
) s 
ON CONFLICT DO NOTHING;

INSERT INTO responses (vacancy_id, resume_id, response_status_id, created_at)
SELECT 
    v.id, 
    r.id, 
    floor(random() * 5 + 1), 
    v.created_at + (random() * interval '10 days') 
FROM (SELECT id, created_at FROM vacancies ORDER BY id OFFSET 0) v 
CROSS JOIN LATERAL (
    SELECT id 
    FROM resumes 
    WHERE id > (v.id * 3) % 400000 
    ORDER BY id 
    LIMIT 14 OFFSET 0
) r 
ON CONFLICT (resume_id, vacancy_id) DO NOTHING;

END $$;