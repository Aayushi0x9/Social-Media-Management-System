-- ============================================================
-- SMMS — Social Media Management System
-- ============================================================

-- PHASE 1 — MASTER DATA MANAGEMENT
    - country
        id
        name
        iso_code
        phone_code
        status -- active, inactive

    - State
        id
        country_id
        name
        status -- active, inactive

    - city
        id
        state_id
        name
        status -- active, inactive

    - role  -- Admin, Student, Employee
        id
        name -- Admin, Student, Employee
        description

    - permission
        id
        name -- posts, users, analytics …
        permission_key -- create_post, approve_post …
        description

    - role permission
        id
        role_id
        permission_id

-- PHASE 2 — SOCIAL MEDIA PLATFORM MANAGEMENT
    - platforms  -- Instagram, Facebook, X, LinkedIn …
        id
        platform_name  -- Instagram, Facebook, X, LinkedIn …
        platform_code  -- IG, FB, TW, LI …
        icon
        status -- active, inactive

    - content_type 
        id
        content_type_name -- Image, Video, Text, GIF, Document, Reel, Story, Carousel, Audio
        description

    - platform_content_type -- which platform have which content type
        id
        platform_id
        content_type_id

    - user_platform_content_type -- which user have which playform's content type
        id
        user_id
        platform_content_type_id
        status -- active, inactive
        assigned_by
        assigned_at

    - platform_content_rule -- which platform apply content limits
        id
        platform_id  
        content_type_id  -- which media type does this rule apply to
        caption_max_chars  -- e.g. 2200 IG, 3000 FB, 280 X
        hashtag_max_count  -- e.g. 5 IG, 10 recommended TW
        mention_max_count 

        -- Image limits
        image_max_size_mb
        image_min_width_px
        image_max_width_px
        image_min_height_px
        image_max_height_px
        image_allowed_formats --jpg, png, webp
        image_aspect_ratio   -- e.g. 4:5 ,1:1
       
        -- Video / Reels limits
        video_max_size_mb 
        video_max_duration_sec  -- e.g. 60 for Reels, 3600 for FB
        video_max_width_px 
        video_max_height_px  
        video_allowed_formats  -- mp4,mov
        
        -- Carousel limits
        

-- PHASE 3 — USER MANAGEMENT
    - user
    - user role

-- PHASE 4 — POST MANAGEMENT
    - social account --all users social account info
    - topic -- topic content for post 
    - post media -all post media
    - post platform --which post have which media
    - post --post media