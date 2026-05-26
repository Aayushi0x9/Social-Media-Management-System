# Phase 1 — Master Data Management

Master data contains static and global reference data used across the entire system. These tables are managed by the Super Admin and do not belong to any specific company.

---

## Tables

### country

Global list of countries.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| name | VARCHAR | Country name |
| iso_code | VARCHAR(3) | ISO 3166 alpha code |
| phone_code | VARCHAR(10) | International dialing code |
| status | ENUM | active / inactive |

---

### state

States or provinces within a country.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| country_id | INT FK | References country.id |
| name | VARCHAR | State name |
| status | ENUM | active / inactive |

---

### city

Cities within a state.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| state_id | INT FK | References state.id |
| name | VARCHAR | City name |
| status | ENUM | active / inactive |

---

### user_type

Defines the broad category of a user in the system.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| name | VARCHAR | e.g. Super Admin, Company Owner, Manager, Employee, Client |
| description | TEXT | Optional description |

---

### role

Defines functional roles that can be assigned to users. Roles can be global (company_id = NULL) or company-specific.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| company_id | INT FK (nullable) | NULL = global role |
| role_name | VARCHAR | e.g. Admin, Content Creator, Reviewer |
| description | TEXT | Role description |
| status | ENUM | active / inactive |

---

### permission

Individual permission keys that control access to specific actions.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| module_name | VARCHAR | e.g. posts, users, analytics |
| permission_key | VARCHAR | e.g. create_post, approve_post |
| description | TEXT | What this permission allows |

**Example permission keys:**
- `create_post`
- `edit_post`
- `approve_post`
- `delete_post`
- `connect_platform`
- `manage_users`
- `view_analytics`

---

### role_permission

Junction table linking roles to their allowed permissions (many-to-many).

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| role_id | INT FK | References role.id |
| permission_id | INT FK | References permission.id |

---

## Relationships

```
country (1) ──< state (1) ──< city
role (M) ──< role_permission >── (M) permission
```
