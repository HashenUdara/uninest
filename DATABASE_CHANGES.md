# Database Changes for Moderator Approval and Signup Enhancements

## Overview
This document describes the database changes made to support moderator approval workflow and enhanced signup fields.

## Schema Changes

### 1. New Table: `universities`
A new table to store Sri Lankan universities.

```sql
CREATE TABLE `universities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**Pre-populated Data:**
- University of Colombo
- University of Peradeniya
- University of Sri Jayewardenepura
- University of Kelaniya
- University of Moratuwa
- University of Jaffna
- University of Ruhuna
- Eastern University, Sri Lanka
- South Eastern University of Sri Lanka
- Rajarata University of Sri Lanka
- Sabaragamuwa University of Sri Lanka
- Wayamba University of Sri Lanka
- University of the Visual & Performing Arts
- University of Vocational Technology
- Open University of Sri Lanka

### 2. Updated Table: `users`
Three new columns added to the `users` table:

```sql
ALTER TABLE `users` ADD COLUMN `is_approved` TINYINT(1) DEFAULT 1;
ALTER TABLE `users` ADD COLUMN `academic_year` INT DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN `university_id` INT DEFAULT NULL;
ALTER TABLE `users` ADD FOREIGN KEY (`university_id`) REFERENCES `universities`(`id`) ON DELETE SET NULL;
```

**Column Details:**
- `is_approved` (TINYINT(1), DEFAULT 1): 
  - Controls whether a moderator account is approved by admin
  - 1 = approved (default for students)
  - 0 = pending approval (set for moderators on signup)
  
- `academic_year` (INT, DEFAULT NULL):
  - Stores the student's academic year (1-4)
  - Required field during signup
  
- `university_id` (INT, DEFAULT NULL):
  - Foreign key reference to the `universities` table
  - Required field during signup

## Migration Instructions

### For Fresh Database Setup:
Simply run the updated `src/main/resources/db/migration/db.sql` file which includes all the changes.

### For Existing Database:
If you already have data in your database, run the following migration script:

```sql
-- Create universities table
CREATE TABLE `universities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert Sri Lankan universities
INSERT INTO `universities` (`name`) VALUES
('University of Colombo'),
('University of Peradeniya'),
('University of Sri Jayewardenepura'),
('University of Kelaniya'),
('University of Moratuwa'),
('University of Jaffna'),
('University of Ruhuna'),
('Eastern University, Sri Lanka'),
('South Eastern University of Sri Lanka'),
('Rajarata University of Sri Lanka'),
('Sabaragamuwa University of Sri Lanka'),
('Wayamba University of Sri Lanka'),
('University of the Visual & Performing Arts'),
('University of Vocational Technology'),
('Open University of Sri Lanka');

-- Add new columns to users table
ALTER TABLE `users` ADD COLUMN `is_approved` TINYINT(1) DEFAULT 1;
ALTER TABLE `users` ADD COLUMN `academic_year` INT DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN `university_id` INT DEFAULT NULL;
ALTER TABLE `users` ADD FOREIGN KEY (`university_id`) REFERENCES `universities`(`id`) ON DELETE SET NULL;

-- Update existing users to be approved (optional, only if you have existing data)
UPDATE `users` SET `is_approved` = 1 WHERE `is_approved` IS NULL;
```

## Application Logic Changes

### Signup Process:
1. **Students**: Automatically approved (`is_approved` = 1) and can login immediately
2. **Moderators**: Set to pending approval (`is_approved` = 0) and redirected to a waiting page

### Login Process:
- Moderators with `is_approved` = 0 cannot login and receive an error message
- Admins need to manually approve moderator accounts by updating `is_approved` to 1

### Admin Approval (Future Enhancement):
Admins will need an interface to:
- View pending moderator accounts
- Approve/reject moderator applications
- Update the `is_approved` field

Example SQL for admin to approve a moderator:
```sql
UPDATE `users` SET `is_approved` = 1 WHERE `id` = <user_id> AND role_id = (SELECT id FROM roles WHERE name = 'moderator');
```

## Data Relationships

```
users (user table)
  ├── university_id → universities.id (foreign key)
  ├── role_id → roles.id (foreign key)
  └── is_approved (boolean flag for moderators)
```

## Notes
- The `is_approved` field is mainly for moderator accounts. Students are auto-approved.
- `academic_year` and `university_id` are required during signup but nullable in the database for flexibility.
- Future enhancement: Admin dashboard to manage pending moderator approvals.
