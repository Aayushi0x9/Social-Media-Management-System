-- =========================================
-- PHASE 2 : COMPANY & USER MANAGEMENT
-- =========================================

USE master_data_management;

-- =========================================
-- COMPANY
-- =========================================
CREATE TABLE company (
    id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(150) NOT NULL,
    company_code VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    website VARCHAR(255),
    logo VARCHAR(255),

    country_id INT NOT NULL,
    state_id INT NOT NULL,
    city_id INT NOT NULL,

    timezone VARCHAR(100) DEFAULT 'Asia/Kolkata',

    status ENUM('active', 'suspended', 'inactive')
        DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_company_country
        FOREIGN KEY (country_id)
        REFERENCES country(id),

    CONSTRAINT fk_company_state
        FOREIGN KEY (state_id)
        REFERENCES state(id),

    CONSTRAINT fk_company_city
        FOREIGN KEY (city_id)
        REFERENCES city(id)
);

-- =========================================
-- USER
-- =========================================
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,

    company_id INT NOT NULL,
    user_type_id INT NOT NULL,

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,

    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),

    password_hash VARCHAR(255) NOT NULL,

    profile_image VARCHAR(255),

    designation VARCHAR(150),
    department VARCHAR(150),

    last_login TIMESTAMP NULL,

    is_active BOOLEAN DEFAULT TRUE,

    created_by INT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_user_company
        FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_user_usertype
        FOREIGN KEY (user_type_id)
        REFERENCES user_type(id),

    CONSTRAINT fk_user_createdby
        FOREIGN KEY (created_by)
        REFERENCES user(id)
        ON DELETE SET NULL
);

-- =========================================
-- USER ROLE
-- =========================================
CREATE TABLE user_role (
    id INT PRIMARY KEY AUTO_INCREMENT,

    user_id INT NOT NULL,
    role_id INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_userrole_user
        FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_userrole_role
        FOREIGN KEY (role_id)
        REFERENCES role(id)
        ON DELETE CASCADE,

    UNIQUE(user_id, role_id)
);

-- =========================================
-- TEAM
-- =========================================
CREATE TABLE team (
    id INT PRIMARY KEY AUTO_INCREMENT,

    company_id INT NOT NULL,

    team_name VARCHAR(150) NOT NULL,
    description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_team_company
        FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE
);

-- =========================================
-- TEAM USER
-- =========================================
CREATE TABLE team_user (
    id INT PRIMARY KEY AUTO_INCREMENT,

    team_id INT NOT NULL,
    user_id INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_teamuser_team
        FOREIGN KEY (team_id)
        REFERENCES team(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_teamuser_user
        FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE,

    UNIQUE(team_id, user_id)
);

-- =========================================
-- INDEXES
-- =========================================

CREATE INDEX idx_company_country
ON company(country_id);

CREATE INDEX idx_company_state
ON company(state_id);

CREATE INDEX idx_company_city
ON company(city_id);

CREATE INDEX idx_user_company
ON user(company_id);

CREATE INDEX idx_user_usertype
ON user(user_type_id);

CREATE INDEX idx_user_createdby
ON user(created_by);

CREATE INDEX idx_userrole_user
ON user_role(user_id);

CREATE INDEX idx_userrole_role
ON user_role(role_id);

CREATE INDEX idx_team_company
ON team(company_id);

CREATE INDEX idx_teamuser_team
ON team_user(team_id);

CREATE INDEX idx_teamuser_user
ON team_user(user_id);

-- =========================================
-- SAMPLE COMPANY
-- =========================================

INSERT INTO company (
    company_name,
    company_code,
    email,
    phone,
    website,
    country_id,
    state_id,
    city_id,
    timezone,
    status
)
VALUES (
    'NetMirror Technologies',
    'NMT001',
    'info@netmirror.com',
    '+91-9876543210',
    'https://netmirror.com',
    1,
    1,
    1,
    'Asia/Kolkata',
    'active'
);

-- =========================================
-- SAMPLE USERS
-- =========================================

INSERT INTO user (
    company_id,
    user_type_id,
    first_name,
    last_name,
    username,
    email,
    phone,
    password_hash,
    designation,
    department,
    is_active
)
VALUES
(
    1,
    1,
    'Super',
    'Admin',
    'superadmin',
    'superadmin@netmirror.com',
    '+91-9999999999',
    '$2y$10$hashedpassword',
    'System Administrator',
    'Administration',
    TRUE
),
(
    1,
    2,
    'Aayushi',
    'Patel',
    'aayushi',
    'aayushi@netmirror.com',
    '+91-8888888888',
    '$2y$10$hashedpassword',
    'Project Manager',
    'Management',
    TRUE
);

-- =========================================
-- SAMPLE TEAM
-- =========================================

INSERT INTO team (
    company_id,
    team_name,
    description
)
VALUES (
    1,
    'Development Team',
    'Handles software development tasks'
);

-- =========================================
-- SAMPLE TEAM MEMBERS
-- =========================================

INSERT INTO team_user (
    team_id,
    user_id
)
VALUES
(1, 1),
(1, 2);
