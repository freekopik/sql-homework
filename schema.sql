DROP TABLE IF EXISTS 
    experience_histories, resume_skills, vacancy_skills, vacancy_areas, 
    responses, resume_views, resumes, vacancies, applicants, employers, 
    specializations, industries, areas, education_levels, genders, 
    employment_types, work_modes, work_schedules, work_hours, 
    contract_types, payout_schedules, response_statuses, vacancy_statuses, skills 
CASCADE;

CREATE TABLE genders (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(80) UNIQUE NOT NULL
);

CREATE TABLE education_levels (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE industries (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE areas (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE vacancy_statuses (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE response_statuses (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE skills (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE employment_types (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, title VARCHAR(50) UNIQUE NOT NULL);
CREATE TABLE work_modes (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, title VARCHAR(50) UNIQUE NOT NULL);
CREATE TABLE work_schedules (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, title VARCHAR(20) UNIQUE NOT NULL);
CREATE TABLE work_hours (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, title VARCHAR(20) UNIQUE NOT NULL);
CREATE TABLE contract_types (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, title VARCHAR(30) UNIQUE NOT NULL);
CREATE TABLE payout_schedules (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, title VARCHAR(30) UNIQUE NOT NULL);

CREATE TABLE specializations (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(200) UNIQUE NOT NULL,
    industry_id INTEGER NOT NULL REFERENCES industries(id)
);

CREATE TABLE employers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    is_verified bool NOT NULL DEFAULT false,
    has_it_accreditation bool NOT NULL DEFAULT false,
    rating float,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE applicants (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    firstname VARCHAR(150) NOT NULL,
    lastname VARCHAR(150) NOT NULL,
    surname VARCHAR(150),
    birthday DATE,
    gender_id INTEGER NOT NULL REFERENCES genders(id),
    edu_level_id INTEGER REFERENCES education_levels(id),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE vacancies (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    employer_id INTEGER NOT NULL REFERENCES employers(id),
    status_id INTEGER REFERENCES vacancy_statuses(id),
    specialization_id INTEGER NOT NULL REFERENCES specializations(id),
    is_experience_needed bool NOT NULL DEFAULT false,
    experience_from INTEGER,
    experience_to INTEGER,
    has_compensation bool NOT NULL DEFAULT true,
    is_compensation_fixed bool NOT NULL DEFAULT false,
    compensation_from INTEGER,
    compensation_to INTEGER,
    is_tax_included bool NOT NULL DEFAULT false,
    edu_level_id INTEGER REFERENCES education_levels(id),
    employment_type_id INTEGER REFERENCES employment_types(id),
    work_mode_id INTEGER REFERENCES work_modes(id),
    work_schedule_id INTEGER REFERENCES work_schedules(id),
    work_hours_id INTEGER REFERENCES work_hours(id),
    contract_type_id INTEGER REFERENCES contract_types(id),
    payout_schedule_id INTEGER REFERENCES payout_schedules(id),
    created_at TIMESTAMP NOT NULL DEFAULT (now()),
    CONSTRAINT check_salary_full_logic CHECK (
        (has_compensation = false AND compensation_from IS NULL AND compensation_to IS NULL) 
        OR 
        (has_compensation = true AND compensation_from IS NOT NULL AND (compensation_to IS NULL OR compensation_to >= compensation_from))
    )
);

CREATE TABLE resumes (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    applicant_id INTEGER NOT NULL REFERENCES applicants(id),
    compensation_from INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE experience_histories (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    resume_id INTEGER NOT NULL REFERENCES resumes(id) ON DELETE CASCADE,
    company_title VARCHAR(200) NOT NULL,
    position VARCHAR(150) NOT NULL,
    description text,
    start_date DATE NOT NULL,
    end_date DATE,
    is_current bool DEFAULT false
);

CREATE TABLE responses (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    applicant_id INTEGER NOT NULL REFERENCES applicants(id),
    vacancy_id INTEGER NOT NULL REFERENCES vacancies(id),
    resume_id INTEGER REFERENCES resumes(id),
    response_status_id INTEGER REFERENCES response_statuses(id),
    cover_letter text,
    created_at TIMESTAMP NOT NULL DEFAULT (now()),
    UNIQUE (applicant_id, vacancy_id)
);

CREATE TABLE resume_views (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    resume_id INTEGER NOT NULL REFERENCES resumes(id) ON DELETE CASCADE,
    employer_id INTEGER NOT NULL REFERENCES employers(id) ON DELETE CASCADE,
    viewed_at TIMESTAMP DEFAULT now()
);

CREATE TABLE vacancy_areas (vacancy_id INTEGER NOT NULL REFERENCES vacancies(id), area_id INTEGER NOT NULL REFERENCES areas(id), PRIMARY KEY (vacancy_id, area_id));
CREATE TABLE vacancy_skills (vacancy_id INTEGER NOT NULL REFERENCES vacancies(id), skill_id INTEGER NOT NULL REFERENCES skills(id), PRIMARY KEY (vacancy_id, skill_id));
CREATE TABLE resume_skills (resume_id INTEGER NOT NULL REFERENCES resumes(id), skill_id INTEGER NOT NULL REFERENCES skills(id), PRIMARY KEY (resume_id, skill_id));
