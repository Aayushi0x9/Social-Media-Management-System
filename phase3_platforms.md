# Phase 3 — Social Media Platform Management

This phase manages the global platform catalog, per-platform rules, company connections, social accounts, and user-level access.

---

## Tables

### platform_master

Global catalog of supported social media platforms.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| platform_name | VARCHAR | e.g. Instagram, Facebook, X, LinkedIn |
| platform_code | VARCHAR | Short code e.g. IG, FB, TW, LI |+
| icon | VARCHAR | Icon asset URL |
| status | ENUM | active / inactive |

---

### content_type

Types of media content that can be used in posts.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| content_type_name | VARCHAR | e.g. Image, Video, Text, GIF, Document |
| description | TEXT | Optional description |

---

### platform_content_type

Maps which content types each platform supports (many-to-many).

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| platform_id | INT FK | References platform_master.id |
| content_type_id | INT FK | References content_type.id |

---

### user_platform_content_type
| Column                   | Type     | Description                         |
| ------------------------ | -------- | ----------------------------------- |
| id                       | INT PK   | Primary key                         |
| user_id                  | INT FK   | References users.id                 |
| platform_content_type_id | INT FK   | References platform_content_type.id |
| status                   | ENUM     | active / inactive                   |
| assigned_by              | INT FK   | References users.id                 |
| assigned_at              | DATETIME | Access assignment date & time       |
| updated_at               | DATETIME | Last updated timestamp              |
---

## Relationships

```
platform_master (M) ──< platform_content_type >── (M) content_type
platform_master (M) ──< platform_post_type >── (M) post_type
platform_master (1) ──< platform_rules
company (1) ──< company_platform_connection
platform_master (1) ──< company_platform_connection
company_platform_connection (1) ──< social_account
social_account (M) ──< user_platform_access >── (M) user
```
