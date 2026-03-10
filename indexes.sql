CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX vacancies_employer ON vacancies(employer_id);
CREATE INDEX vacancies_specialization ON vacancies(specialization_id);
CREATE INDEX vacancies_salary ON vacancies(compensation_from) WHERE has_compensation = true;
CREATE INDEX vacancies_created_at ON vacancies(created_at DESC);
CREATE INDEX resumes_applicant ON resumes(applicant_id);

CREATE INDEX exp_hist_resume_id ON experience_histories(resume_id);
CREATE INDEX exp_hist_position_gin ON experience_histories USING GIN (position gin_trgm_ops);
CREATE UNIQUE INDEX exp_hist_current_work ON experience_histories(resume_id) WHERE is_current = true;

CREATE UNIQUE INDEX vacancy_skills_unique ON vacancy_skills(vacancy_id, skill_id);
CREATE INDEX vacancy_skills_skill_id ON vacancy_skills(skill_id);
CREATE UNIQUE INDEX resume_skills_unique ON resume_skills(resume_id, skill_id);
CREATE INDEX resume_skills_skill_id ON resume_skills(skill_id);
CREATE UNIQUE INDEX vacancy_areas_unique ON vacancy_areas(vacancy_id, area_id);
CREATE INDEX vacancy_areas_area_id ON vacancy_areas(area_id);

CREATE UNIQUE INDEX responses_one_per_candidate ON responses(applicant_id, vacancy_id);
CREATE INDEX responses_vacancy ON responses(vacancy_id);
CREATE INDEX responses_resume ON responses(resume_id);

CREATE INDEX resume_views_resume_id ON resume_views(resume_id);

ANALYZE;
