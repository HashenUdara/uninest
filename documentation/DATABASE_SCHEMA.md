# Database Schema Documentation

## Overview

UniNest uses MySQL 8.0+ with InnoDB engine and UTF8MB4 character set for full Unicode support. The database schema follows normalization principles with proper foreign key relationships.

## Entity Relationship Diagram

```
┌─────────────┐     ┌─────────────────┐     ┌───────────────────────┐
│   roles     │     │     users       │     │     communities       │
├─────────────┤     ├─────────────────┤     ├───────────────────────┤
│ id (PK)     │◄────│ role_id (FK)    │     │ id (PK)               │
│ name        │     │ id (PK)         │────►│ created_by_user_id(FK)│
│ description │     │ email           │     │ approved_by_user_id   │
│ inherits_from│    │ name            │     │ title                 │
└─────────────┘     │ password_hash   │     │ description           │
                    │ community_id(FK)│◄────│ status                │
                    │ academic_year   │     │ approved              │
                    │ university_id   │     └───────────────────────┘
                    └─────────────────┘
                            │
                            │ university_id (FK)
                            ▼
                    ┌─────────────────┐
                    │  universities   │
                    ├─────────────────┤
                    │ id (PK)         │
                    │ name            │
                    └─────────────────┘

┌─────────────────────────┐
│ community_join_requests │     ┌─────────────────────────┐
├─────────────────────────┤     │       subjects          │
│ id (PK)                 │     ├─────────────────────────┤
│ user_id (FK)            │     │ subject_id (PK)         │
│ community_id (FK)       │     │ community_id (FK)       │
│ status                  │     │ name                    │
│ requested_at            │     │ description             │
│ processed_at            │     │ code                    │
│ processed_by_user_id    │     │ academic_year           │
└─────────────────────────┘     │ semester                │
                                │ status                  │
                                └─────────────────────────┘
                                            │
                                            │ subject_id (FK)
                                            ▼
                                ┌─────────────────────────┐
                                │        topics           │
                                ├─────────────────────────┤
                                │ topic_id (PK)           │
                                │ subject_id (FK)         │
                                │ title                   │
                                │ description             │
                                └─────────────────────────┘
                                            │
                    ┌───────────────────────┼───────────────────────┐
                    │                       │                       │
                    ▼                       ▼                       ▼
┌─────────────────────────┐  ┌─────────────────────────┐  ┌─────────────────────┐
│     topic_progress      │  │       resources         │  │subject_coordinators │
├─────────────────────────┤  ├─────────────────────────┤  ├─────────────────────┤
│ progress_id (PK)        │  │ resource_id (PK)        │  │ coordinator_id (PK) │
│ topic_id (FK)           │  │ topic_id (FK)           │  │ user_id (FK)        │
│ user_id (FK)            │  │ uploaded_by (FK)        │  │ subject_id (FK)     │
│ progress_percent        │  │ category_id (FK)        │  │ assigned_at         │
│ last_accessed           │  │ title                   │  └─────────────────────┘
└─────────────────────────┘  │ description             │
                             │ file_url                │
                             │ file_type               │
                             │ status                  │
                             │ visibility              │
                             │ parent_resource_id (FK) │
                             │ version                 │
                             │ edit_type               │
                             └─────────────────────────┘
                                            │
                                            │ category_id (FK)
                                            ▼
                             ┌─────────────────────────┐
                             │   resource_categories   │
                             ├─────────────────────────┤
                             │ category_id (PK)        │
                             │ category_name           │
                             │ description             │
                             └─────────────────────────┘
```

## Table Definitions

### 1. roles

Stores user role definitions with optional inheritance.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Unique identifier |
| name | VARCHAR(50) | UNIQUE, NOT NULL | Role name (student, moderator, admin) |
| description | VARCHAR(255) | NULL | Role description |
| inherits_from | INT | FK→roles.id, NULL | Parent role for inheritance |

**Default Data:**
```sql
INSERT INTO roles VALUES
(1, 'student', 'Basic student privileges for accessing learning content', NULL),
(2, 'moderator', 'Can review and moderate discussions or uploads', 1),
(3, 'admin', 'Full administrative privileges across the system', 1);
```

### 2. universities

List of universities supported by the system.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Unique identifier |
| name | VARCHAR(200) | UNIQUE, NOT NULL | University name |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

**Contains 19 Sri Lankan universities by default.**

### 3. users

Core user table storing all user information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Unique identifier |
| email | VARCHAR(120) | UNIQUE, NOT NULL | User email |
| name | VARCHAR(200) | NULL | Full name |
| password_hash | VARCHAR(255) | NOT NULL | BCrypt hashed password |
| role_id | INT | FK→roles.id, NOT NULL | User role |
| community_id | INT | FK→communities.id, NULL | Assigned community |
| academic_year | TINYINT | NULL | Year 1-4 |
| university_id | INT | FK→universities.id, NULL | University reference |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Registration timestamp |

### 4. communities

Academic communities that users can join.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Unique identifier |
| title | VARCHAR(150) | NOT NULL | Community name |
| description | VARCHAR(1024) | NULL | Community description |
| created_by_user_id | INT | FK→users.id, NOT NULL | Creator (moderator) |
| status | VARCHAR(20) | DEFAULT 'pending' | pending/approved/rejected |
| approved | TINYINT(1) | DEFAULT 0 | Boolean approval flag |
| approved_at | TIMESTAMP | NULL | Approval timestamp |
| approved_by_user_id | INT | FK→users.id, NULL | Admin who approved |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

**Indexes:**
- `idx_comm_status` on status
- `idx_comm_approved` on approved

### 5. community_join_requests

Tracks student requests to join communities.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Unique identifier |
| user_id | INT | FK→users.id, NOT NULL | Requesting student |
| community_id | INT | FK→communities.id, NOT NULL | Target community |
| status | VARCHAR(20) | DEFAULT 'pending' | pending/approved/rejected |
| requested_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Request timestamp |
| processed_at | TIMESTAMP | NULL | Processing timestamp |
| processed_by_user_id | INT | FK→users.id, NULL | Moderator who processed |

**Indexes:**
- `idx_join_req_status` on status
- `idx_join_req_user` on user_id
- `idx_join_req_community` on community_id

### 6. subjects

Courses/subjects within communities.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| subject_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| community_id | INT | FK→communities.id, NOT NULL | Parent community |
| name | VARCHAR(100) | NOT NULL | Subject name |
| description | TEXT | NULL | Subject description |
| code | VARCHAR(50) | NULL | Subject code (e.g., CS204) |
| academic_year | TINYINT | NOT NULL | Year 1-4 |
| semester | TINYINT | NOT NULL | Semester 1-2 |
| status | ENUM | DEFAULT 'upcoming' | upcoming/ongoing/completed |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

**Indexes:**
- `idx_subject_community` on community_id
- `idx_subject_status` on status

### 7. topics

Learning units within subjects.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| topic_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| subject_id | INT | FK→subjects.subject_id, NOT NULL | Parent subject |
| title | VARCHAR(150) | NOT NULL | Topic title |
| description | TEXT | NULL | Topic description |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

**Indexes:**
- `idx_topic_subject` on subject_id

### 8. subject_coordinators

Links students as subject coordinators (special privileges).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| coordinator_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| user_id | INT | FK→users.id, UNIQUE, NOT NULL | Student user |
| subject_id | INT | FK→subjects.subject_id, NOT NULL | Assigned subject |
| assigned_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Assignment timestamp |

**Important:** The UNIQUE constraint on user_id means a student can only be coordinator for one subject.

### 9. topic_progress

Tracks student learning progress per topic.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| progress_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| topic_id | INT | FK→topics.topic_id, NOT NULL | Topic reference |
| user_id | INT | FK→users.id, NOT NULL | Student reference |
| progress_percent | DECIMAL(5,2) | DEFAULT 0.00 | Progress 0-100 |
| last_accessed | DATETIME | DEFAULT CURRENT_TIMESTAMP | Last access time |

**Unique Key:** (user_id, topic_id) - One progress record per student per topic

### 10. resource_categories

Categories for educational resources.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| category_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| category_name | VARCHAR(100) | UNIQUE, NOT NULL | Category name |
| description | TEXT | NULL | Category description |

**Default Categories:**
- Lecture Notes
- Short Notes
- Past Papers
- Tutorials
- Assignments
- Lab Sheets
- Video Tutorials
- Project Reports
- Reference Materials
- Model Answers

### 11. resources

Educational materials uploaded by students.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| resource_id | INT | PK, AUTO_INCREMENT | Unique identifier |
| topic_id | INT | FK→topics.topic_id, NOT NULL | Parent topic |
| uploaded_by | INT | FK→users.id, NOT NULL | Uploader |
| category_id | INT | FK→resource_categories.category_id, NOT NULL | Category |
| title | VARCHAR(255) | NOT NULL | Resource title |
| description | TEXT | NULL | Resource description |
| file_url | VARCHAR(500) | NOT NULL | File storage path |
| file_type | VARCHAR(100) | NOT NULL | MIME type |
| upload_date | DATETIME | DEFAULT CURRENT_TIMESTAMP | Upload timestamp |
| status | ENUM | DEFAULT 'pending' | pending/approved/rejected/pending_edit/replaced |
| visibility | ENUM | DEFAULT 'private' | private/public |
| approved_by | INT | FK→users.id, NULL | Approver |
| approval_date | DATETIME | NULL | Approval timestamp |
| parent_resource_id | INT | FK→resources.resource_id, NULL | For versioning |
| version | INT | DEFAULT 1 | Version number |
| edit_type | ENUM | DEFAULT 'new' | new/edit |

### 12. password_reset_tokens

Manages password reset functionality.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| token | VARCHAR(64) | PK | Reset token (UUID) |
| user_id | INT | FK→users.id, NOT NULL | User requesting reset |
| expires_at | TIMESTAMP | NOT NULL | Token expiration |
| used | TINYINT(1) | DEFAULT 0 | Token used flag |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |

## Foreign Key Relationships

```
roles                    ← users.role_id
universities             ← users.university_id
communities              ← users.community_id
users                    ← communities.created_by_user_id
users                    ← communities.approved_by_user_id
users                    ← community_join_requests.user_id
communities              ← community_join_requests.community_id
users                    ← community_join_requests.processed_by_user_id
communities              ← subjects.community_id
subjects                 ← topics.subject_id
topics                   ← topic_progress.topic_id
users                    ← topic_progress.user_id
users                    ← subject_coordinators.user_id
subjects                 ← subject_coordinators.subject_id
topics                   ← resources.topic_id
users                    ← resources.uploaded_by
resource_categories      ← resources.category_id
users                    ← resources.approved_by
resources                ← resources.parent_resource_id (self-reference)
users                    ← password_reset_tokens.user_id
```

## Cascade Rules

| Table | Foreign Key | On Delete | On Update |
|-------|-------------|-----------|-----------|
| users | role_id | RESTRICT | CASCADE |
| users | community_id | SET NULL | CASCADE |
| users | university_id | SET NULL | CASCADE |
| communities | created_by_user_id | CASCADE | CASCADE |
| communities | approved_by_user_id | SET NULL | CASCADE |
| community_join_requests | user_id | CASCADE | CASCADE |
| community_join_requests | community_id | CASCADE | CASCADE |
| subjects | community_id | CASCADE | CASCADE |
| topics | subject_id | CASCADE | CASCADE |
| subject_coordinators | user_id | CASCADE | CASCADE |
| subject_coordinators | subject_id | CASCADE | CASCADE |
| topic_progress | topic_id | CASCADE | CASCADE |
| topic_progress | user_id | CASCADE | CASCADE |
| resources | topic_id | CASCADE | CASCADE |
| resources | parent_resource_id | CASCADE | CASCADE |

## Database Migration

Migration files are located in: `src/main/resources/db/migration/`

- `db.sql` - Main schema and seed data
- `add_resource_versioning.sql` - Adds versioning columns to resources
- `add_resource_versioning_safe.sql` - Safe versioning migration

To apply migrations:
```bash
mysql -u username -p database_name < src/main/resources/db/migration/db.sql
```

## Performance Indexes

| Table | Index Name | Columns | Purpose |
|-------|------------|---------|---------|
| communities | idx_comm_status | status | Filter by status |
| communities | idx_comm_approved | approved | Filter approved |
| community_join_requests | idx_join_req_status | status | Filter by status |
| community_join_requests | idx_join_req_user | user_id | Find user requests |
| community_join_requests | idx_join_req_community | community_id | Find community requests |
| subjects | idx_subject_community | community_id | Find community subjects |
| subjects | idx_subject_status | status | Filter by status |
| topics | idx_topic_subject | subject_id | Find subject topics |
| topic_progress | idx_progress_topic | topic_id | Find topic progress |
| topic_progress | idx_progress_user | user_id | Find user progress |
| subject_coordinators | idx_coordinator_subject | subject_id | Find subject coordinators |
