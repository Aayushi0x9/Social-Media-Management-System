-- ============================================================
-- SMMS — Social Media Management System
-- ============================================================

-- PHASE 1 — MASTER DATA MANAGEMENT
-- PHASE 2 — SOCIAL MEDIA PLATFORM MANAGEMENT
-- PHASE 3 — USER MANAGEMENT
-- PHASE 4 — POST MANAGEMENT

-- ============================================================
-- PHASE 1 — MASTER DATA MANAGEMENT
-- ============================================================

CREATE TABLE country (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    iso_code    VARCHAR(3)   NOT NULL UNIQUE,
    phone_code  VARCHAR(10)  NOT NULL,
    status      ENUM('active','inactive') NOT NULL DEFAULT 'active', 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE state (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    country_id  INT UNSIGNED NOT NULL,
    name        VARCHAR(100) NOT NULL,
    status      ENUM('active','inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    CONSTRAINT fk_state_country FOREIGN KEY (country_id) REFERENCES country(id)
);

CREATE TABLE city (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    state_id    INT UNSIGNED NOT NULL,
    name        VARCHAR(100) NOT NULL,
    status      ENUM('active','inactive') NOT NULL DEFAULT 'active',
    CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES state(id)
);

CREATE TABLE role (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,   -- Super Admin,Student, Employee
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE permission (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,   -- posts, users, analytics …
    permission_key  VARCHAR(100) NOT NULL UNIQUE, -- create_post, approve_post …
    description     TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE role_permission (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id         INT UNSIGNED NOT NULL,
    permission_id   INT UNSIGNED NOT NULL,
    CONSTRAINT fk_role_permission_role FOREIGN KEY (role_id) REFERENCES role(id), 
    CONSTRAINT fk_role_permission_permission FOREIGN KEY (permission_id) REFERENCES permission(id)
);

-- ============================================================
-- PHASE 2 — SOCIAL MEDIA PLATFORM MANAGEMENT
-- ============================================================

CREATE TABLE platforms (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    platform_name   VARCHAR(100) NOT NULL,          -- Instagram, Facebook, X, LinkedIn …
    platform_code   VARCHAR(20)  NOT NULL UNIQUE,   -- IG, FB, TW, LI …
    icon            VARCHAR(500),
    status          ENUM('active','inactive') NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE content_type (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    content_type_name   VARCHAR(100) NOT NULL,  -- Image, Video, Text, GIF, Document, Reel, Story, Carousel, Audio
    description         TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- which platform have which content type
CREATE TABLE platform_content_type (
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    platform_id       INT UNSIGNED NOT NULL,
    content_type_id   INT UNSIGNED NOT NULL,
    CONSTRAINT fk_pct_platform FOREIGN KEY (platform_id) REFERENCES platform(id), 
    CONSTRAINT fk_pct_content_type FOREIGN KEY (content_type_id) REFERENCES content_type(id)
);


-- which user have which playform's content type
CREATE TABLE user_platform_content_type (
    id                        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id                   INT UNSIGNED NOT NULL,
    platform_content_type_id  INT UNSIGNED NOT NULL,
    status                    ENUM('active','inactive') NOT NULL DEFAULT 'active',
    assigned_by               INT UNSIGNED NOT NULL,
    assigned_at               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

 -- which platform apply content limits
CREATE TABLE platform_content_rule (
    id                      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    platform_id             INT UNSIGNED NOT NULL,
    content_type_id         INT UNSIGNED NOT NULL,    -- which media type does this rule apply to

    -- Text / Caption limits
    caption_max_chars       INT UNSIGNED NULL,        -- e.g. 2200 IG, 3000 FB, 280 X

    -- Hashtag limits
    hashtag_max_count       TINYINT UNSIGNED NULL,    -- e.g. 30 IG, 10 recommended TW

    -- Tag / mention limits
    mention_max_count       TINYINT UNSIGNED NULL,    -- @mention limit per post

    -- Image limits
    image_max_size_mb       DECIMAL(5,2) NULL,        -- max file size in MB
    image_min_width_px      SMALLINT UNSIGNED NULL,
    image_max_width_px      SMALLINT UNSIGNED NULL,
    image_min_height_px     SMALLINT UNSIGNED NULL,
    image_max_height_px     SMALLINT UNSIGNED NULL,
    image_allowed_formats   VARCHAR(200) NULL,        -- JSON array: ["jpg","png","webp"]
    image_aspect_ratio      VARCHAR(50) NULL,         -- e.g. "4:5 to 1.91:1"

    -- Video / Reels limits
    video_max_size_mb       DECIMAL(7,2) NULL,
    video_max_duration_sec  INT UNSIGNED NULL,        -- e.g. 60 for Reels, 3600 for FB
    video_max_width_px      SMALLINT UNSIGNED NULL,
    video_max_height_px     SMALLINT UNSIGNED NULL,
    video_allowed_formats   VARCHAR(200) NULL,        -- ["mp4","mov"]

    -- Carousel limits
    carousel_min_cards      TINYINT UNSIGNED NULL,    -- e.g. 2
    carousel_max_cards      TINYINT UNSIGNED NULL,    -- e.g. 10

    -- Article / Document limits (LinkedIn Article, FB Note)
    article_max_chars       INT UNSIGNED NULL,        -- total article body chars
    article_title_max_chars SMALLINT UNSIGNED NULL,

    -- PDF / Document limits
    document_max_size_mb    DECIMAL(5,2) NULL,
    document_max_pages      SMALLINT UNSIGNED NULL,
    notes                   TEXT NULL,              -- human-readable rule notes
    CONSTRAINT fk_pcr_platform FOREIGN KEY (platform_id) REFERENCES platform(id), 
    CONSTRAINT fk_pcr_content_type FOREIGN KEY (content_type_id) REFERENCES content_type(id)
);

-- ============================================================
-- PHASE 3 — USER MANAGEMENT
-- ============================================================

CREATE TABLE user (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_type_id    INT UNSIGNED NOT NULL,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    username        VARCHAR(100) NOT NULL UNIQUE,
    email           VARCHAR(255) NOT NULL UNIQUE,
    phone           VARCHAR(30),
    password_hash   VARCHAR(255) NOT NULL,   -- bcrypt / Argon2id
    profile_image   VARCHAR(500),
    department      VARCHAR(100),
    last_login      TIMESTAMP NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_by      INT UNSIGNED NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_city FOREIGN KEY (city_id) REFERENCES city(id)
);

CREATE TABLE user_role (
    id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id  INT UNSIGNED NOT NULL,
    role_id  INT UNSIGNED NOT NULL,

    CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES user(id), 
    CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES role(id)
);

-- ============================================================
-- PHASE 4 — POST MANAGEMENT
-- ============================================================

-- Social accounts connected per user
CREATE TABLE social_account (
    id                  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    platform_id         INT UNSIGNED NOT NULL,
    user_id             INT UNSIGNED NOT NULL,
    account_name        VARCHAR(200) NOT NULL,
    account_handle      VARCHAR(200),
    profile_url         VARCHAR(500),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_social_platform FOREIGN KEY (platform_id) REFERENCES platform(id), 
    CONSTRAINT fk_social_user FOREIGN KEY (user_id) REFERENCES user(id)
);

-- topic content for post 
CREATE TABLE topic ( 
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    topic_name      VARCHAR(255) NOT NULL, 
    description     TEXT, 
    status          ENUM('active','inactive') 
                    DEFAULT 'active', 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

--all post media
CREATE TABLE post_media ( 
    id                      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    post_id                 INT UNSIGNED NOT NULL, 
    media_type              ENUM('image','video','audio','document') NOT NULL, 
    file_name               VARCHAR(255), 
    file_url                VARCHAR(1000) NOT NULL, 
    thumbnail_url           VARCHAR(1000), 
    mime_type               VARCHAR(100), 
    file_size_mb            DECIMAL(8,2), 
    duration_sec            INT UNSIGNED, 
    width_px                INT UNSIGNED, 
    height_px               INT UNSIGNED, 
    sort_order              INT UNSIGNED DEFAULT 1, 
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    CONSTRAINT fk_post_media_post FOREIGN KEY (post_id) REFERENCES post(id) 
);

--which post have which platform
CREATE TABLE post_platform (
    id                          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    post_id                     INT UNSIGNED NOT NULL,
    social_account_id           INT UNSIGNED NOT NULL,
    content_type_id             INT UNSIGNED NOT NULL,
    platform_specific_caption   TEXT,
    cta                         TEXT,
    hashtags                    TEXT,               -- platform-specific hashtags
    hashtag_count               TINYINT UNSIGNED GENERATED ALWAYS AS
                                (CHAR_LENGTH(hashtags) - CHAR_LENGTH(REPLACE(hashtags,'#','')) + IF(hashtags IS NULL,0,0))
                                VIRTUAL,            -- auto-counted, validated against platform_content_rule
    scheduled_time              TIMESTAMP NULL,
    publish_status              ENUM('pending','published','failed','cancelled')
                                NOT NULL DEFAULT 'pending',
    platform_post_id            VARCHAR(200) NULL  -- live post ID returned by platform API

    CONSTRAINT fk_pp_post FOREIGN KEY (post_id) REFERENCES post(id), 
    CONSTRAINT fk_pp_social_account FOREIGN KEY (social_account_id) REFERENCES social_account(id), 
    CONSTRAINT fk_pp_content_type FOREIGN KEY (content_type_id) REFERENCES content_type(id)
);

--post media
CREATE TABLE post (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    platform_content_type_id INT UNSIGNED NOT NULL,
    created_by      INT UNSIGNED NOT NULL,
    topic_id        INT UNSIGNED NULL,
    title           VARCHAR(500),
    caption         TEXT,                           -- master caption (overridable per platform)
    Cta             TEXT,
    status          ENUM('draft','pending_review','approved','rejected','scheduled','published','failed')
                    NOT NULL DEFAULT 'draft',
    is_ai_generated BOOLEAN NOT NULL DEFAULT FALSE,
    scheduled_at    TIMESTAMP NULL,
    published_at    TIMESTAMP NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    CONSTRAINT fk_post_pct FOREIGN KEY (platform_content_type_id) REFERENCES platform_content_type(id), 
    CONSTRAINT fk_post_user FOREIGN KEY (created_by) REFERENCES user(id), 
    CONSTRAINT fk_post_topic FOREIGN KEY (topic_id) REFERENCES topic(id)
);
