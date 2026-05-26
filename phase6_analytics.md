# Phase 6 — Analytics & Logs

This phase handles engagement data fetched from platform APIs and a full audit trail of user actions.

---

## Tables

### analytics

Stores engagement metrics for each published post per social account. Fetched periodically via platform APIs.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| social_account_id | INT FK | References social_account.id |
| post_platform_id | INT FK | References post_platform.id |
| impressions | BIGINT | Number of times content was displayed |
| likes | INT | Like/reaction count |
| comments | INT | Comment count |
| shares | INT | Share/retweet/repost count |
| clicks | INT | Link click count |
| watch_time | INT | Total watch time in seconds (video only) |
| engagement_rate | DECIMAL(5,2) | (likes + comments + shares) / impressions × 100 |
| fetched_at | TIMESTAMP | When this data snapshot was retrieved |

> Analytics rows are append-only snapshots. Query the latest `fetched_at` per `post_platform_id` for the most recent metrics.

---

### activity_log

Immutable audit trail of every meaningful action performed by any user in the system.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| company_id | INT FK | References company.id |
| user_id | INT FK | References user.id |
| module_name | VARCHAR | e.g. posts, users, platforms, teams |
| action_type | ENUM | create / update / delete / publish / approve / reject / login / logout |
| entity_type | VARCHAR | Table name of the affected record |
| entity_id | INT | ID of the affected record |
| old_value | JSON | State before the action (nullable) |
| new_value | JSON | State after the action (nullable) |
| ip_address | VARCHAR | Client IP address |
| created_at | TIMESTAMP | When the action occurred |

---

## Relationships

```
social_account (1) ──< analytics
post_platform (1) ──< analytics
company (1) ──< activity_log
user (1) ──< activity_log
```

---

## Analytics Fetching Strategy

Platform APIs have rate limits and data freshness windows. Recommended fetch schedule:

| Post age | Fetch frequency |
|---|---|
| 0–24 hours | Every 30 minutes |
| 1–7 days | Every 4 hours |
| 7–30 days | Once daily |
| 30+ days | Once weekly |

Use a background queue job (BullMQ) with priority based on post age.

---

## Activity Log Best Practices

- Log every state-changing action (writes, deletes, approvals, publishes)
- Do not log read-only actions (page views, searches) — use application monitoring for that
- `old_value` and `new_value` should capture the full relevant JSON state, not just changed fields
- This table will grow large — partition by `created_at` month in PostgreSQL for performance
- Retain logs for minimum 12 months for compliance; archive older logs to cold storage

---

## Example Log Entries

| module | action | entity_type | entity_id | summary |
|---|---|---|---|---|
| posts | create | post | 4521 | User drafted a new post |
| posts | approve | post | 4521 | Manager approved post |
| posts | publish | post_platform | 8832 | Post published to Instagram |
| users | update | user | 12 | Email address changed |
| platforms | delete | social_account | 7 | Account disconnected |
