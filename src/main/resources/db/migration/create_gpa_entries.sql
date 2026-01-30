-- Migration: Create gpa_entries table for storing student grade records
-- This table stores individual grade entries for students by academic year and semester

-- Create gpa_entries table if it doesn't exist
CREATE TABLE IF NOT EXISTS `gpa_entries` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `academic_year` TINYINT NOT NULL COMMENT 'Academic year (1, 2, 3, 4)',
  `semester` TINYINT NOT NULL COMMENT 'Semester (1, 2)',
  `course_name` VARCHAR(50) NOT NULL COMMENT 'Subject code (e.g., CS204)',
  `grade` VARCHAR(5) NOT NULL COMMENT 'Letter grade (A+, A, A-, B+, B, B-, C+, C, C-, D, F)',
  `credits` INT NOT NULL DEFAULT 3 COMMENT 'Credit hours for the course',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_year_sem_course` (`student_id`, `academic_year`, `semester`, `course_name`),
  INDEX `idx_gpa_student` (`student_id`),
  INDEX `idx_gpa_year_sem` (`academic_year`, `semester`),
  FOREIGN KEY (`student_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
COMMENT='Stores student grade entries for GPA calculation';

-- Verify table creation
SELECT 
    'gpa_entries table created/verified successfully' AS status,
    COUNT(*) AS total_entries
FROM gpa_entries;
