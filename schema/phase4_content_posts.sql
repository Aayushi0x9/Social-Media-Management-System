-- =========================================
-- PHASE 4 : CONTENT & POST MANAGEMENT
-- =========================================

USE master_data_management;

-- =========================================
-- CONTENT LIBRARY
-- =========================================
CREATE TABLE content_library (
    id INT PRIMARY KEY AUTO_INCREMENT,

    company_id INT NOT NULL,
    uploaded_by INT NOT NULL,
    content_type_id INT NOT NULL,

    file_url VARCHAR(500) NOT NULL,
    thumbnail_url VARCHAR(500),

    file_size BIGINT,
    duration INT,

    tags TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_contentlibrary_company
        FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_contentlibrary_uploadedby
        FOREIGN KEY (uploaded_by)
        REFERENCES user(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_contentlibrary_contenttype
        FOREIGN KEY (content_type_id)
        REFERENCES content_type(id)
        ON DELETE CASCADE
);

-- =========================================
-- POST
-- =========================================
CREATE TABLE post (
    id INT PRIMARY KEY AUTO_INCREMENT,

    company_id INT NOT NULL,
    created_by INT NOT NULL,

    title VARCHAR(255),

    main_caption TEXT,

    status ENUM(
        'draft',
        'scheduled',
        'published',
        'failed',
        'cancelled'
    ) DEFAULT 'draft',

    visibility ENUM(
        'public',
        'private',
        'team_only'
    ) DEFAULT 'public',

    scheduled_at TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_post_company
        FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_post_createdby
        FOREIGN KEY (created_by)
        REFERENCES user(id)
        ON DELETE CASCADE
);

-- =========================================
-- POST MEDIA
-- =========================================
CREATE TABLE post_media (
    id INT PRIMARY KEY AUTO_INCREMENT,

    post_id INT NOT NULL,
    content_library_id INT NOT NULL,

    sequence_no INT DEFAULT 1,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_postmedia_post
        FOREIGN KEY (post_id)
        REFERENCES post(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_postmedia_content
        FOREIGN KEY (content_library_id)
        REFERENCES content_library(id)
        ON DELETE CASCADE,

    UNIQUE(post_id, content_library_id)
);

-- =========================================
-- POST TYPE
-- =========================================
CREATE TABLE post_type (
    id INT PRIMARY KEY AUTO_INCREMENT,

    post_type_name VARCHAR(100) NOT NULL UNIQUE,

    description TEXT,

    status ENUM('active', 'inactive')
        DEFAULT 'active',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- =========================================
-- SOCIAL ACCOUNT
-- =========================================
CREATE TABLE social_account (
    id INT PRIMARY KEY AUTO_INCREMENT,

    company_id INT NOT NULL,
    platform_id INT NOT NULL,

    account_name VARCHAR(255) NOT NULL,
    account_username VARCHAR(255),

    account_email VARCHAR(255),

    access_token TEXT,
    refresh_token TEXT,

    token_expiry DATETIME,

    account_profile_url VARCHAR(500),

    status ENUM(
        'connected',
        'disconnected',
        'expired'
    ) DEFAULT 'connected',

    connected_by INT NOT NULL,

    connected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_socialaccount_company
        FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_socialaccount_platform
        FOREIGN KEY (platform_id)
        REFERENCES platform_master(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_socialaccount_connectedby
        FOREIGN KEY (connected_by)
        REFERENCES user(id)
        ON DELETE CASCADE
);

-- =========================================
-- POST PLATFORM
-- =========================================
CREATE TABLE post_platform (
    id INT PRIMARY KEY AUTO_INCREMENT,

    post_id INT NOT NULL,

    social_account_id INT NOT NULL,

    post_type_id INT NOT NULL,

    platform_specific_caption TEXT,

    CTA TEXT,

    hashtags TEXT,

    scheduled_time TIMESTAMP NULL,

    platform_post_id VARCHAR(255),

    publish_status ENUM(
        'pending',
        'published',
        'failed',
        'cancelled'
    ) DEFAULT 'pending',

    error_message TEXT,

    published_at TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_postplatform_post
        FOREIGN KEY (post_id)
        REFERENCES post(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_postplatform_socialaccount
        FOREIGN KEY (social_account_id)
        REFERENCES social_account(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_postplatform_posttype
        FOREIGN KEY (post_type_id)
        REFERENCES post_type(id)
        ON DELETE CASCADE
);

-- =========================================
-- AI PROMPT HISTORY
-- =========================================
CREATE TABLE ai_prompt_history (
    id INT PRIMARY KEY AUTO_INCREMENT,

    user_id INT NOT NULL,

    prompt TEXT NOT NULL,

    generated_content LONGTEXT,

    tokens_used INT DEFAULT 0,

    generation_type ENUM(
        'caption',
        'hashtags',
        'image',
        'translation'
    ) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_aiprompt_user
        FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE
);

-- =========================================
-- INDEXES
-- =========================================

CREATE INDEX idx_contentlibrary_company
ON content_library(company_id);

CREATE INDEX idx_contentlibrary_uploadedby
ON content_library(uploaded_by);

CREATE INDEX idx_contentlibrary_contenttype
ON content_library(content_type_id);

CREATE INDEX idx_post_company
ON post(company_id);

CREATE INDEX idx_post_createdby
ON post(created_by);

CREATE INDEX idx_post_status
ON post(status);

CREATE INDEX idx_postmedia_post
ON post_media(post_id);

CREATE INDEX idx_postmedia_content
ON post_media(content_library_id);

CREATE INDEX idx_socialaccount_company
ON social_account(company_id);

CREATE INDEX idx_socialaccount_platform
ON social_account(platform_id);

CREATE INDEX idx_postplatform_post
ON post_platform(post_id);

CREATE INDEX idx_postplatform_socialaccount
ON post_platform(social_account_id);

CREATE INDEX idx_postplatform_status
ON post_platform(publish_status);

CREATE INDEX idx_aiprompt_user
ON ai_prompt_history(user_id);

CREATE INDEX idx_aiprompt_generationtype
ON ai_prompt_history(generation_type);

-- =========================================
-- SAMPLE POST TYPES
-- =========================================

INSERT INTO post_type (
    post_type_name,
    description,
    status
)
VALUES
(
    'Feed Post',
    'Standard social media feed post',
    'active'
),
(
    'Story',
    'Temporary story content',
    'active'
),
(
    'Reel',
    'Short video reel content',
    'active'
),
(
    'Carousel',
    'Multi-image carousel post',
    'active'
),
(
    'Article',
    'Long-form article content',
    'active'
);

-- =========================================
-- SAMPLE CONTENT LIBRARY DATA
-- =========================================

INSERT INTO content_library (
    company_id,
    uploaded_by,
    content_type_id,
    file_url,
    thumbnail_url,
    file_size,
    duration,
    tags
)
VALUES
(
    1,
    1,
    1,
    'https://cdn.netmirror.com/uploads/image1.jpg',
    'https://cdn.netmirror.com/uploads/thumb_image1.jpg',
    204800,
    NULL,
    'marketing,social,branding'
),
(
    1,
    2,
    2,
    'https://cdn.netmirror.com/uploads/video1.mp4',
    'https://cdn.netmirror.com/uploads/thumb_video1.jpg',
    10485760,
    120,
    'promo,launch,video'
);

-- =========================================
-- SAMPLE POST
-- =========================================

INSERT INTO post (
    company_id,
    created_by,
    title,
    main_caption,
    status,
    visibility,
    scheduled_at
)
VALUES
(
    1,
    1,
    'New Product Launch',
    'We are excited to launch our new product today!',
    'scheduled',
    'public',
    NOW() + INTERVAL 1 DAY
);

-- =========================================
-- SAMPLE POST MEDIA
-- =========================================

INSERT INTO post_media (
    post_id,
    content_library_id,
    sequence_no
)
VALUES
(1, 1, 1),
(1, 2, 2);

-- =========================================
-- SAMPLE SOCIAL ACCOUNT
-- =========================================

INSERT INTO social_account (
    company_id,
    platform_id,
    account_name,
    account_username,
    account_email,
    access_token,
    refresh_token,
    token_expiry,
    account_profile_url,
    status,
    connected_by
)
VALUES
(
    1,
    1,
    'NetMirror Official',
    '@netmirror',
    'social@netmirror.com',
    'encrypted_access_token',
    'encrypted_refresh_token',
    NOW() + INTERVAL 30 DAY,
    'https://instagram.com/netmirror',
    'connected',
    1
);

-- =========================================
-- SAMPLE POST PLATFORM
-- =========================================

INSERT INTO post_platform (
    post_id,
    social_account_id,
    post_type_id,
    platform_specific_caption,
    CTA,
    hashtags,
    scheduled_time,
    publish_status
)
VALUES
(
    1,
    1,
    1,
    'Check out our amazing new launch on Instagram!',
    'Visit our website today!',
    '#launch #product #netmirror',
    NOW() + INTERVAL 1 DAY,
    'pending'
);

-- =========================================
-- SAMPLE AI PROMPT HISTORY
-- =========================================

INSERT INTO ai_prompt_history (
    user_id,
    prompt,
    generated_content,
    tokens_used,
    generation_type
)
VALUES
(
    1,
    'Generate Instagram caption for product launch',
    'Excited to unveil our latest innovation! Stay tuned.',
    120,
    'caption'
);
