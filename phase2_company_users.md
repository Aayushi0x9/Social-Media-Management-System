# Phase 2 — Company & User Management

This phase handles organization registration, user accounts, role assignments, and team structure.

---

## Tables

### company

Represents a registered organization on SMMS.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| company_name | VARCHAR | Organization name |
| company_code | VARCHAR | Unique short code |
| email | VARCHAR | Primary contact email |
| phone | VARCHAR | Contact phone number |
| website | VARCHAR | Company website URL |
| logo | VARCHAR | Logo file URL |
| country_id | INT FK | References country.id |
| state_id | INT FK | References state.id |
| city_id | INT FK | References city.id |
| timezone | VARCHAR | IANA timezone string (e.g. Asia/Kolkata) |
| status | ENUM | active / suspended / inactive |
| created_at | TIMESTAMP | Account creation time |

---

### user

User accounts belonging to a company.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| company_id | INT FK | References company.id |
| user_type_id | INT FK | References user_type.id |
| first_name | VARCHAR | First name |
| last_name | VARCHAR | Last name |
| username | VARCHAR | Unique username |
| email | VARCHAR | Login email (unique) |
| phone | VARCHAR | Contact number |
| password_hash | VARCHAR | Bcrypt/Argon2 hashed password |
| profile_image | VARCHAR | Avatar file URL |
| designation | VARCHAR | Job title |
| department | VARCHAR | Team or department |
| last_login | TIMESTAMP | Last successful login |
| is_active | BOOLEAN | Account enabled flag |
| created_by | INT FK | ID of user who created this account |
| created_at | TIMESTAMP | Record creation time |

---

### user_role

Assigns one or more roles to a user (many-to-many).

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| user_id | INT FK | References user.id |
| role_id | INT FK | References role.id |

---

### team

A named group within a company for collaboration.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| company_id | INT FK | References company.id |
| team_name | VARCHAR | Team display name |
| description | TEXT | Optional description |

---

### team_user

Associates users with teams (many-to-many).

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| team_id | INT FK | References team.id |
| user_id | INT FK | References user.id |

---

## Relationships

```
company (1) ──< user
user (M) ──< user_role >── (M) role
company (1) ──< team
team (M) ──< team_user >── (M) user
```

---

## Notes

- A user belongs to exactly one company (`company_id` is non-nullable)
- A user can have multiple roles via `user_role`
- A user can be a member of multiple teams via `team_user`
- `created_by` enables audit of who added each user to the system
- Passwords must never be stored in plain text; use bcrypt or Argon2id
