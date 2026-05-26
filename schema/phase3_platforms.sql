-- =========================================
-- PHASE 3 : SOCIAL MEDIA PLATFORM MANAGEMENT
-- =========================================

USE master_data_management;

-- =========================================
-- PLATFORM MASTER
-- =========================================
CREATE TABLE platform_master (
    id INT PRIMARY KEY AUTO_INCREMENT,

    platform_name VARCHAR(100) NOT NULL,
    platform_code VARCHAR(20) NOT NULL UNIQUE,

    icon VARCHAR(255),

    status ENUM('active', 'inactive')
        DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- CONTENT TYPE
-- =========================================
CREATE TABLE content_type (
    id INT PRIMARY KEY AUTO_INCREMENT,

    content_type_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- PLATFORM CONTENT TYPE
-- =========================================
CREATE TABLE platform_content_type (
    id INT PRIMARY KEY AUTO_INCREMENT,

    platform_id INT NOT NULL,
    content_type_id INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_pct_platform
        FOREIGN KEY (platform_id)
        REFERENCES platform_master(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pct_contenttype
        FOREIGN KEY (content_type_id)
        REFERENCES content_type(id)
        ON DELETE CASCADE,

    UNIQUE(platform_id, content_type_id)
);

-- =========================================
-- USER PLATFORM CONTENT TYPE
-- =========================================
CREATE TABLE user_platform_content_type (
    id INT PRIMARY KEY AUTO_INCREMENT,

    user_id INT NOT NULL,

    platform_content_type_id INT NOT NULL,

    status ENUM('active', 'inactive')
        DEFAULT 'active',

    assigned_by INT NULL,

    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_upct_user
        FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_upct_platformcontent
        FOREIGN KEY (platform_content_type_id)
        REFERENCES platform_content_type(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_upct_assignedby
        FOREIGN KEY (assigned_by)
        REFERENCES user(id)
        ON DELETE SET NULL,

    UNIQUE(user_id, platform_content_type_id)
);

-- =========================================
-- INDEXES
-- =========================================

CREATE INDEX idx_pct_platform
ON platform_content_type(platform_id);

CREATE INDEX idx_pct_contenttype
ON platform_content_type(content_type_id);

CREATE INDEX idx_upct_user
ON user_platform_content_type(user_id);

CREATE INDEX idx_upct_platformcontent
ON user_platform_content_type(platform_content_type_id);

CREATE INDEX idx_upct_assignedby
ON user_platform_content_type(assigned_by);

-- =========================================
-- SAMPLE PLATFORM DATA
-- =========================================

INSERT INTO platform_master (
    platform_name,
    platform_code,
    icon,
    status
)
VALUES
(
    'Instagram',
    'IG',
    'https://cdn.icons.com/instagram.png',
    'active'
),
(
    'Facebook',
    'FB',
    'https://cdn.icons.com/facebook.png',
    'active'
),
(
    'LinkedIn',
    'LI',
    'https://cdn.icons.com/linkedin.png',
    'active'
),
(
    'X',
    'TW',
    'https://cdn.icons.com/x.png',
    'active'
);

-- =========================================
-- SAMPLE CONTENT TYPES
-- =========================================

INSERT INTO content_type (
    content_type_name,
    description
)
VALUES
(
    'Image',
    'Image based content'
),
(
    'Video',
    'Video based content'
),
(
    'Text',
    'Plain text content'
),
(
    'GIF',
    'Animated GIF content'
),
(
    'Document',
    'PDF or document uploads'
);

-- =========================================
-- SAMPLE PLATFORM CONTENT TYPE MAPPING
-- =========================================

INSERT INTO platform_content_type (
    platform_id,
    content_type_id
)
VALUES
(1, 1), -- Instagram -> Image
(1, 2), -- Instagram -> Video
(1, 4), -- Instagram -> GIF

(2, 1), -- Facebook -> Image
(2, 2), -- Facebook -> Video
(2, 3), -- Facebook -> Text
(2, 5), -- Facebook -> Document

(3, 1), -- LinkedIn -> Image
(3, 2), -- LinkedIn -> Video
(3, 3), -- LinkedIn -> Text
(3, 5), -- LinkedIn -> Document

(4, 1), -- X -> Image
(4, 3), -- X -> Text
(4, 4); -- X -> GIF

-- =========================================
-- SAMPLE USER PLATFORM CONTENT ACCESS
-- =========================================

INSERT INTO user_platform_content_type (
    user_id,
    platform_content_type_id,
    status,
    assigned_by
)
VALUES
(1, 1, 'active', 1),
(1, 2, 'active', 1),
(2, 5, 'active', 1),
(2, 9, 'active', 1);
