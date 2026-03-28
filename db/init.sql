-- =============================================================
-- Collective National Budget – Schema & Seed Data
-- Idempotent: safe to run multiple times
-- =============================================================

CREATE TABLE IF NOT EXISTS org_tree (
    dept_id        SERIAL PRIMARY KEY,
    parent_dept_id INTEGER REFERENCES org_tree(dept_id),
    dept_name      VARCHAR(255) NOT NULL,
    description    TEXT,
    depth          INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS user_allocation (
    id          SERIAL PRIMARY KEY,
    dept_id     INTEGER NOT NULL REFERENCES org_tree(dept_id),
    user_id     INTEGER NOT NULL,
    allocation  NUMERIC(6,2) NOT NULL CHECK (allocation >= 0 AND allocation <= 100),
    updated_at  TIMESTAMP DEFAULT NOW(),
    UNIQUE (dept_id, user_id)
);

CREATE TABLE IF NOT EXISTS users (
    user_id    SERIAL PRIMARY KEY,
    username   VARCHAR(100) UNIQUE NOT NULL,
    password   VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_org_tree_parent ON org_tree(parent_dept_id);
CREATE INDEX IF NOT EXISTS idx_user_alloc_user ON user_allocation(user_id);
CREATE INDEX IF NOT EXISTS idx_user_alloc_dept ON user_allocation(dept_id);

-- =============================================================
-- Seed: Root
-- =============================================================
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (1, NULL, 'National Budget', 'Total government expenditure', 0)
ON CONFLICT DO NOTHING;

-- =============================================================
-- Seed: Top-Level Departments (depth 1)
-- =============================================================
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (2,  1, 'Defense',                 'Military and national security',          1),
    (3,  1, 'Healthcare',              'Public health services and insurance',    1),
    (4,  1, 'Education',               'Public education at all levels',          1),
    (5,  1, 'Infrastructure',          'Transportation, utilities, public works', 1),
    (6,  1, 'Social Security',         'Retirement and disability benefits',      1),
    (7,  1, 'Science & Technology',    'Research funding and space exploration',  1),
    (8,  1, 'Environment',             'Environmental protection and climate',    1),
    (9,  1, 'Foreign Affairs',         'Diplomacy and foreign aid',              1),
    (10, 1, 'Justice & Public Safety', 'Courts, law enforcement, corrections',   1),
    (11, 1, 'Debt Service',            'Interest on national debt',              1)
ON CONFLICT DO NOTHING;

-- =============================================================
-- Seed: Sub-departments (depth 2)
-- =============================================================

-- Defense
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (20, 2, 'Army',            'Ground forces',                    2),
    (21, 2, 'Navy',            'Naval forces',                     2),
    (22, 2, 'Air Force',       'Aerial and space forces',          2),
    (23, 2, 'Veterans Affairs','Services for military veterans',   2),
    (24, 2, 'Cybersecurity',   'Digital defense and intelligence', 2)
ON CONFLICT DO NOTHING;

-- Healthcare
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (30, 3, 'Hospitals & Clinics', 'Public hospital funding',         2),
    (31, 3, 'Insurance Programs',  'Medicare, Medicaid equivalents',  2),
    (32, 3, 'Disease Prevention',  'CDC-style programs and vaccines', 2),
    (33, 3, 'Mental Health',       'Mental health services',          2),
    (34, 3, 'Drug Regulation',     'Pharmaceutical oversight',        2)
ON CONFLICT DO NOTHING;

-- Education
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (40, 4, 'Primary Education',   'K-8 public schooling',            2),
    (41, 4, 'Secondary Education', 'High school programs',            2),
    (42, 4, 'Higher Education',    'University grants and loans',     2),
    (43, 4, 'Vocational Training', 'Trade schools and certifications', 2)
ON CONFLICT DO NOTHING;

-- Infrastructure
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (50, 5, 'Roads & Highways', 'Federal highway system',            2),
    (51, 5, 'Public Transit',   'Buses, rail, metro systems',        2),
    (52, 5, 'Water & Sewage',   'Clean water infrastructure',        2),
    (53, 5, 'Energy Grid',      'Power generation and distribution', 2),
    (54, 5, 'Broadband',        'Internet infrastructure',           2)
ON CONFLICT DO NOTHING;

-- Science & Technology
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (70, 7, 'Space Exploration', 'NASA-style programs',          2),
    (71, 7, 'Basic Research',    'NSF-style grants',             2),
    (72, 7, 'Applied Technology','Tech transfer and innovation',  2),
    (73, 7, 'AI & Computing',    'National AI strategy',         2)
ON CONFLICT DO NOTHING;

-- Environment
INSERT INTO org_tree (dept_id, parent_dept_id, dept_name, description, depth) VALUES
    (80, 8, 'Climate Action',   'Emissions reduction programs',  2),
    (81, 8, 'Conservation',     'National parks and wildlife',   2),
    (82, 8, 'Pollution Control','Air and water quality',         2),
    (83, 8, 'Renewable Energy', 'Solar, wind, hydro incentives', 2)
ON CONFLICT DO NOTHING;

-- =============================================================
-- Seed: Demo user
-- =============================================================
INSERT INTO users (user_id, username, password) VALUES
    (1, 'demo', 'demo123')
ON CONFLICT DO NOTHING;

-- Reset sequences to max values
SELECT setval('org_tree_dept_id_seq', (SELECT MAX(dept_id) FROM org_tree));
SELECT setval('users_user_id_seq', (SELECT MAX(user_id) FROM users));
