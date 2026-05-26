# Phase 5 — Scheduling & Calendar

This phase manages timed publishing and user notification reminders.

---

## Tables

### schedule

Scheduling configuration for a specific post-platform publish target.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| post_platform_id | INT FK | References post_platform.id |
| scheduled_time | TIMESTAMP | When to publish (stored in UTC) |
| reminder_enabled | BOOLEAN | Whether to send a pre-publish reminder |
| reminder_before_minutes | INT | Minutes before scheduled_time to send reminder |
| recurring_type | ENUM | none / daily / weekly / monthly |
| schedule_status | ENUM | pending / processing / completed / failed / cancelled |

---

### reminder

A notification record tied to a schedule, sent to a specific user.

| Column | Type | Description |
|---|---|---|
| id | INT PK | Primary key |
| user_id | INT FK | References user.id |
| schedule_id | INT FK | References schedule.id |
| reminder_time | TIMESTAMP | Exact time to deliver the notification |
| notification_type | ENUM | email / push / in_app / sms |
| status | ENUM | pending / sent / failed |

---

## Relationships

```
post_platform (1) ──< schedule
schedule (1) ──< reminder
user (1) ──< reminder
```

---

## Scheduling Logic

### Timezone handling
- All times stored in UTC in the database
- Display times are converted to `company.timezone` or `user` timezone in the application layer
- Scheduled jobs must account for DST transitions

### Recurring posts
- `recurring_type = weekly` creates a new `post_platform` + `schedule` row each cycle
- Original post serves as the template; content is duplicated per occurrence
- Recurring series should have a parent reference for campaign grouping (future feature)

### Queue integration (Redis + BullMQ)
```
schedule_status = pending
    ↓ (job queued at scheduled_time - buffer)
schedule_status = processing
    ↓ (API call to platform)
schedule_status = completed    OR    schedule_status = failed
```

Failed jobs should implement exponential backoff retry (3 attempts) before marking as failed and alerting the user.

---

## Reminder flow

```
1. User enables reminder when scheduling a post
2. reminder_before_minutes determines the trigger offset
3. At (scheduled_time - reminder_before_minutes), reminder job fires
4. Notification delivered via notification_type channel
5. reminder.status updated to sent or failed
```
