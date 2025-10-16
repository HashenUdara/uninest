# Database Changes for Organization Management

## Overview
This document describes the database schema changes made to support the organization management functionality.

## New Tables

### 1. organizations
Stores information about organizations created by moderators.

```sql
CREATE TABLE `organizations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `moderator_id` INT NOT NULL,
  `status` ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`moderator_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**Fields:**
- `id`: Auto-incremented primary key
- `title`: Organization name (max 255 characters)
- `description`: Text description of the organization
- `moderator_id`: Foreign key to the user who created the organization
- `status`: Organization approval status (pending/approved/rejected)
- `created_at`: Timestamp when organization was created
- `updated_at`: Timestamp when organization was last updated

## Modified Tables

### 1. users
Added new fields to support organization membership and student details.

**New fields:**
```sql
`organization_id` INT DEFAULT NULL,
`academic_year` INT DEFAULT NULL,
`university` VARCHAR(255) DEFAULT NULL,
FOREIGN KEY (`organization_id`) REFERENCES `organizations`(`id`) ON DELETE SET NULL
```

**Field descriptions:**
- `organization_id`: Foreign key to the organization the user belongs to (NULL if not joined)
- `academic_year`: Student's academic year (1, 2, 3, or 4) - only for students
- `university`: Student's university name - only for students

## Supported Universities

The system supports the following 15 Sri Lankan universities:
1. University of Colombo
2. University of Peradeniya
3. University of Sri Jayewardenepura
4. University of Kelaniya
5. University of Moratuwa
6. University of Jaffna
7. University of Ruhuna
8. Eastern University, Sri Lanka
9. South Eastern University of Sri Lanka
10. Rajarata University of Sri Lanka
11. Sabaragamuwa University of Sri Lanka
12. Wayamba University of Sri Lanka
13. Uva Wellassa University
14. Open University of Sri Lanka
15. Buddhist and Pali University of Sri Lanka

## Relationships

```
users
  |-- role_id --> roles
  |-- organization_id --> organizations

organizations
  |-- moderator_id --> users
```

## Database Migration Instructions

To apply these changes to an existing database:

1. **Backup your database first!**

2. Run the following SQL commands in order:

```sql
-- Step 1: Create organizations table
CREATE TABLE `organizations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `moderator_id` INT NOT NULL,
  `status` ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Step 2: Add new columns to users table
ALTER TABLE `users`
  ADD COLUMN `organization_id` INT DEFAULT NULL AFTER `role_id`,
  ADD COLUMN `academic_year` INT DEFAULT NULL AFTER `organization_id`,
  ADD COLUMN `university` VARCHAR(255) DEFAULT NULL AFTER `academic_year`;

-- Step 3: Add foreign key constraints
ALTER TABLE `users`
  ADD FOREIGN KEY (`organization_id`) REFERENCES `organizations`(`id`) ON DELETE SET NULL;

ALTER TABLE `organizations`
  ADD FOREIGN KEY (`moderator_id`) REFERENCES `users`(`id`) ON DELETE CASCADE;
```

## Workflow

### For Moderators:
1. Sign up with moderator role
2. Create organization (stored in `organizations` table with status='pending')
3. Wait for admin approval
4. Once approved (status='approved'), can access dashboard
5. Share organization ID with students

### For Students:
1. Sign up with student role (must provide academic_year and university)
2. Enter organization ID
3. System validates organization exists and is approved
4. User's organization_id field is updated
5. Can access dashboard

### For Admins:
1. View all organizations
2. Approve or reject pending organizations
3. Updates organization status accordingly

## Notes

- Organization ID must be shared manually by moderator to students
- Students cannot join organizations that are pending or rejected
- Moderators can only have one organization
- Students can only join one organization
- Organization deletion will set users' organization_id to NULL (CASCADE behavior)
