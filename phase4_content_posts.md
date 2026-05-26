# Phase 4 — Content & Post Management

This phase covers the content library, post creation, media attachment, platform-specific publishing, and AI content generation.

---

## Tables

### content_library

Centralized media storage for a company. Holds all uploaded or AI-generated files used in posts.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| company_id | INT FK | References company.id |
| uploaded_by | INT FK | References user.id |
| content_type_id | INT FK | References content_type.id |
| file_url | VARCHAR | CDN/S3 URL of the file |
| thumbnail_url | VARCHAR | Thumbnail preview URL |
| file_size | BIGINT | File size in bytes |
| duration | INT | Duration in seconds (video/audio only) |
| tags | TEXT | Comma-separated or JSON tag list |
| created_at | TIMESTAMP | Upload timestamp |

---

### post_platform

A single post's configuration for one specific social account. Each row represents one platform publish target.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| post_id | INT FK | References post.id |
| social_account_id | INT FK | References social_account.id |
| post_type_id | INT FK | References post_type.id |
| platform_specific_caption | TEXT | Overrides main caption for this platform |
| CTA | TEXT | main caption for this platform |
| hashtags | TEXT | Platform-specific hashtags |
| scheduled_time | TIMESTAMP | Platform-specific schedule time |
| publish_status | ENUM | pending / published / failed / cancelled |

---

### ai_prompt_history

Tracks all AI content generation requests per user. Useful for quota enforcement and content audit.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| user_id | INT FK | References user.id |
| prompt | TEXT | The user's input prompt |
| generated_content | TEXT | The AI's output |
| tokens_used | INT | Token count for billing/quota |
| generation_type | ENUM | caption / hashtags / image / translation |
| created_at | TIMESTAMP | Generation timestamp |

---

## Relationships

```
company (1) ──< content_library
user (1) ──< content_library
content_type (1) ──< content_library

company (1) ──< post
user (1) ──< post

post (M) ──< post_media >── (M) content_library

post (1) ──< post_platform
social_account (1) ──< post_platform
post_type (1) ──< post_platform

user (1) ──< ai_prompt_history
```

---

## Notes

- `post_platform.platform_specific_caption` allows tailoring the message for each platform (e.g. shorter for X, more detailed for LinkedIn)
- `platform_post_id` is populated after a successful API publish and enables linking back to the live post
- `post_media.sequence_no` drives carousel order — always sort by this field when rendering
- One post can fan out to any number of `post_platform` rows (multi-platform publishing)
