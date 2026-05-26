-- =========================================
-- PHASE 1 : MASTER DATA MANAGEMENT SCHEMA
-- =========================================

CREATE DATABASE IF NOT EXISTS master_data_management;
USE master_data_management;

-- =========================================
-- COUNTRY
-- =========================================
CREATE TABLE country (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    iso_code VARCHAR(3) NOT NULL UNIQUE,
    phone_code VARCHAR(10),
    status ENUM('active', 'inactive') DEFAULT 'active',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- STATE
-- =========================================
CREATE TABLE state (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_state_country
        FOREIGN KEY (country_id)
        REFERENCES country(id)
        ON DELETE CASCADE
);

-- =========================================
-- CITY
-- =========================================
CREATE TABLE city (
    id INT PRIMARY KEY AUTO_INCREMENT,
    state_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_city_state
        FOREIGN KEY (state_id)
        REFERENCES state(id)
        ON DELETE CASCADE
);

-- =========================================
-- USER TYPE
-- =========================================
CREATE TABLE user_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- ROLE
-- =========================================
CREATE TABLE role (
    id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NULL,
    role_name VARCHAR(100) NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- PERMISSION
-- =========================================
CREATE TABLE permission (
    id INT PRIMARY KEY AUTO_INCREMENT,
    module_name VARCHAR(100) NOT NULL,
    permission_key VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- ROLE PERMISSION
-- =========================================
CREATE TABLE role_permission (
    id INT PRIMARY KEY AUTO_INCREMENT,
    role_id INT NOT NULL,
    permission_id INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_rolepermission_role
        FOREIGN KEY (role_id)
        REFERENCES role(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_rolepermission_permission
        FOREIGN KEY (permission_id)
        REFERENCES permission(id)
        ON DELETE CASCADE,

    UNIQUE(role_id, permission_id)
);

-- =========================================
-- INDEXES
-- =========================================

CREATE INDEX idx_state_country_id
ON state(country_id);

CREATE INDEX idx_city_state_id
ON city(state_id);

CREATE INDEX idx_role_company_id
ON role(company_id);

CREATE INDEX idx_permission_module
ON permission(module_name);

CREATE INDEX idx_role_permission_role
ON role_permission(role_id);

CREATE INDEX idx_role_permission_permission
ON role_permission(permission_id);

-- =========================================
-- SAMPLE PERMISSIONS
-- =========================================

INSERT INTO permission (module_name, permission_key, description)
VALUES
('posts', 'create_post', 'Create new posts'),
('posts', 'edit_post', 'Edit existing posts'),
('posts', 'approve_post', 'Approve posts'),
('posts', 'delete_post', 'Delete posts'),
('platform', 'connect_platform', 'Connect social platforms'),
('users', 'manage_users', 'Manage system users'),
('analytics', 'view_analytics', 'View analytics dashboard');

-- =========================================
-- SAMPLE USER TYPES
-- =========================================

INSERT INTO user_type (name, description)
VALUES
('Super Admin', 'System level administrator'),
('Company Owner', 'Owner of company account'),
('Manager', 'Company manager'),
('Employee', 'Regular employee'),
('Client', 'Client user');
