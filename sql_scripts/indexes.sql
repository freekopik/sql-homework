CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Ускоряем фильтрацию вакансий по конкретному работодателю и JOIN-ы для вывода названий компаний
CREATE INDEX vacancies_employer ON vacancies(employer_id);

-- Оптимизируем поиск вакансий по проф. области — это основной фильтр при поиске работы
CREATE INDEX vacancies_specialization ON vacancies(specialization_id);

-- Частичный индекс для поиска по зарплате: исключает пустые значения, экономя место и ускоряя выборку
CREATE INDEX vacancies_salary ON vacancies(compensation_from) WHERE has_compensation = true;

-- Индекс для сортировки выдачи: позволяет мгновенно отдавать самые свежие вакансии (LIMIT 20)
CREATE INDEX vacancies_created_at ON vacancies(created_at DESC);

-- Ускоряет получение списка всех резюме в личном кабинете конкретного соискателя
CREATE INDEX resumes_applicant ON resumes(applicant_id);

-- Оптимизирует поиск соискателей рекрутерами по конкретной специализации
CREATE INDEX resumes_specialization ON resumes(specialization_id);

-- Ускоряет сборку полной страницы резюме (подгрузка блоков истории опыта)
CREATE INDEX exp_hist_resume_id ON experience_histories(resume_id);

/**
 * На практике таблица experience_histories будет чаще читаться, чем обновляться. 
 * Рекрутерам нужно быстро находить соискателей с неким ключевым словом в опыте. 
 * B-Tree подешевле, но он умеет искать только по шаблону 'blockchain%', а мы хотим, 
 * чтобы поиск не зависел от положения ключевого слова. Поэтому без GIN, но с B-Tree 
 * база всё равно будет сканить все 1.5кк записей, чего нам не хочется. 
 * GIN-индекс даёт выигрыш до 1500x.
 */
CREATE INDEX exp_hist_position_gin ON experience_histories USING GIN (position gin_trgm_ops);

-- Гарантирует целостность данных: у соискателя не может быть больше одного «текущего» места работы
CREATE UNIQUE INDEX exp_hist_current_work ON experience_histories(resume_id) WHERE is_current = true;

-- Ускоряет поиск вакансий по требуемому стеку технологий (фильтр по навыкам)
CREATE INDEX vacancy_skills_skill_id ON vacancy_skills(skill_id);

-- Оптимизирует подбор кандидатов с определенными скиллами (например, поиск всех 'PostgreSQL')
CREATE INDEX resume_skills_skill_id ON resume_skills(skill_id);

-- Быстрая фильтрация вакансий по географическому признаку (города/регионы)
CREATE INDEX vacancy_areas_area_id ON vacancy_areas(area_id);

-- Ускоряет работу рекрутера со списком откликов внутри конкретной вакансии
CREATE INDEX responses_vacancy ON responses(vacancy_id);

-- Ускоряет просмотр соискателем истории своих откликов и их статусов
CREATE INDEX responses_resume ON responses(resume_id);

-- Оптимизирует вывод истории просмотров резюме и сбор аналитики посещаемости
CREATE INDEX resume_views_resume_id ON resume_views(resume_id);

ANALYZE;