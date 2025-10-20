
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Use UTF8MB4 for full Unicode support
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------
-- Table: roles
-- --------------------------------------------------------
CREATE TABLE `roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  `description` VARCHAR(255) DEFAULT NULL,
  `inherits_from` INT DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`inherits_from`) REFERENCES `roles`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Default roles
INSERT INTO `roles` (`id`, `name`, `description`, `inherits_from`) VALUES
(1, 'student', 'Basic student privileges for accessing learning content', NULL),
(2, 'subject_coordinator', 'Can manage subjects, resources, and students', 1),
(3, 'moderator', 'Can review and moderate discussions or uploads', 1),
(4, 'admin', 'Full administrative privileges across the system', 1);

-- --------------------------------------------------------
-- Table: users
-- --------------------------------------------------------
CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(120) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: communities
-- --------------------------------------------------------
CREATE TABLE `communities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(150) NOT NULL,
  `description` VARCHAR(1024) DEFAULT NULL,
  `created_by_user_id` INT NOT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
  `approved` TINYINT(1) NOT NULL DEFAULT 0,
  `approved_at` TIMESTAMP NULL DEFAULT NULL,
  `approved_by_user_id` INT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_comm_status` (`status`),
  INDEX `idx_comm_approved` (`approved`),
  FOREIGN KEY (`created_by_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`approved_by_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: universities
-- --------------------------------------------------------
CREATE TABLE `universities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL UNIQUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
('Uva Wellassa University'),
('University of the Visual and Performing Arts'),
('Open University of Sri Lanka'),
('Gampaha Wickramarachchi University of Indigenous Medicine'),
('Ocean University of Sri Lanka'),
('University of Vavuniya'),
('National School of Business Management (NSBM Green University)');

-- --------------------------------------------------------
-- Alter users: community membership + profile fields
-- --------------------------------------------------------
ALTER TABLE `users`
  ADD COLUMN `community_id` INT NULL AFTER `role_id`,
  ADD COLUMN `academic_year` TINYINT NULL AFTER `community_id`,
  ADD COLUMN `university_id` INT NULL AFTER `academic_year`,
  ADD COLUMN `name` VARCHAR(200) NULL AFTER `email`;

ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_community`
    FOREIGN KEY (`community_id`) REFERENCES `communities`(`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_users_university`
    FOREIGN KEY (`university_id`) REFERENCES `universities`(`id`) ON DELETE SET NULL;

-- --------------------------------------------------------
-- Optional: password_reset_tokens (for auth system)
-- --------------------------------------------------------
CREATE TABLE `password_reset_tokens` (
  `token` VARCHAR(64) NOT NULL,
  `user_id` INT NOT NULL,
  `expires_at` TIMESTAMP NOT NULL,
  `used` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `email`, `name`, `password_hash`, `role_id`, `community_id`, `academic_year`, `university_id`, `created_at`) VALUES (NULL, 'a1@abc.com', 'Admin', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', '4', NULL, '1', '19', '2025-10-18 10:01:26');

-- --------------------------------------------------------
-- Demo Data: Communities (5 communities)
-- --------------------------------------------------------
INSERT INTO `communities` (`title`, `description`, `created_by_user_id`, `status`, `approved`) VALUES
('Computer Science Society', 'A community for computer science enthusiasts', 1, 'approved', 1),
('Engineering Students Hub', 'Connect with fellow engineering students', 1, 'approved', 1),
('Medical Students Network', 'For medical students to share knowledge', 1, 'approved', 1),
('Business Students Forum', 'Discussion platform for business majors', 1, 'approved', 1),
('Arts & Humanities Circle', 'Community for arts and humanities students', 1, 'approved', 1);

-- --------------------------------------------------------
-- Demo Data: Moderators (20 moderators with password: password123)
-- Password hash is for 'password123' using BCrypt
-- --------------------------------------------------------
INSERT INTO `users` (`email`, `name`, `password_hash`, `role_id`, `community_id`, `academic_year`, `university_id`) VALUES
('m1@abc.com', 'Moderator 1', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 1, 3, 1),
('m2@abc.com', 'Moderator 2', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 1, 2, 2),
('m3@abc.com', 'Moderator 3', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 2, 4, 3),
('m4@abc.com', 'Moderator 4', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 2, 3, 4),
('m5@abc.com', 'Moderator 5', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 3, 2, 5),
('m6@abc.com', 'Moderator 6', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 3, 1, 1),
('m7@abc.com', 'Moderator 7', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 4, 4, 2),
('m8@abc.com', 'Moderator 8', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 4, 3, 3),
('m9@abc.com', 'Moderator 9', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 5, 2, 4),
('m10@abc.com', 'Moderator 10', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 5, 1, 5),
('m11@abc.com', 'Moderator 11', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 1, 4, 1),
('m12@abc.com', 'Moderator 12', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 2, 3, 2),
('m13@abc.com', 'Moderator 13', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 3, 2, 3),
('m14@abc.com', 'Moderator 14', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 4, 1, 4),
('m15@abc.com', 'Moderator 15', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 5, 4, 5),
('m16@abc.com', 'Moderator 16', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 1, 3, 1),
('m17@abc.com', 'Moderator 17', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 2, 2, 2),
('m18@abc.com', 'Moderator 18', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 3, 1, 3),
('m19@abc.com', 'Moderator 19', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 4, 4, 4),
('m20@abc.com', 'Moderator 20', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 3, 5, 3, 5);

-- --------------------------------------------------------
-- Demo Data: Students (100 students with password: password123)
-- Password hash is for 'password123' using BCrypt
-- --------------------------------------------------------
INSERT INTO `users` (`email`, `name`, `password_hash`, `role_id`, `community_id`, `academic_year`, `university_id`) VALUES
('s1@abc.com', 'Student 1', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 1, 1),
('s2@abc.com', 'Student 2', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 2, 1),
('s3@abc.com', 'Student 3', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 3, 1),
('s4@abc.com', 'Student 4', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 4, 1),
('s5@abc.com', 'Student 5', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 1, 2),
('s6@abc.com', 'Student 6', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 2, 2),
('s7@abc.com', 'Student 7', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 3, 2),
('s8@abc.com', 'Student 8', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 4, 2),
('s9@abc.com', 'Student 9', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 1, 3),
('s10@abc.com', 'Student 10', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 2, 3),
('s11@abc.com', 'Student 11', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 3, 3),
('s12@abc.com', 'Student 12', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 4, 3),
('s13@abc.com', 'Student 13', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 1, 4),
('s14@abc.com', 'Student 14', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 2, 4),
('s15@abc.com', 'Student 15', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 3, 4),
('s16@abc.com', 'Student 16', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 4, 4),
('s17@abc.com', 'Student 17', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 1, 5),
('s18@abc.com', 'Student 18', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 2, 5),
('s19@abc.com', 'Student 19', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 3, 5),
('s20@abc.com', 'Student 20', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 4, 5),
('s21@abc.com', 'Student 21', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 1, 1),
('s22@abc.com', 'Student 22', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 2, 2),
('s23@abc.com', 'Student 23', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 3, 3),
('s24@abc.com', 'Student 24', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 4, 4),
('s25@abc.com', 'Student 25', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 1, 5),
('s26@abc.com', 'Student 26', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 2, 1),
('s27@abc.com', 'Student 27', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 3, 2),
('s28@abc.com', 'Student 28', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 4, 3),
('s29@abc.com', 'Student 29', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 1, 4),
('s30@abc.com', 'Student 30', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 2, 5),
('s31@abc.com', 'Student 31', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 3, 1),
('s32@abc.com', 'Student 32', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 4, 2),
('s33@abc.com', 'Student 33', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 1, 3),
('s34@abc.com', 'Student 34', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 2, 4),
('s35@abc.com', 'Student 35', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 3, 5),
('s36@abc.com', 'Student 36', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 4, 1),
('s37@abc.com', 'Student 37', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 1, 2),
('s38@abc.com', 'Student 38', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 2, 3),
('s39@abc.com', 'Student 39', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 3, 4),
('s40@abc.com', 'Student 40', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 4, 5),
('s41@abc.com', 'Student 41', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 1, 1),
('s42@abc.com', 'Student 42', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 2, 2),
('s43@abc.com', 'Student 43', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 3, 3),
('s44@abc.com', 'Student 44', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 4, 4),
('s45@abc.com', 'Student 45', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 1, 5),
('s46@abc.com', 'Student 46', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 2, 1),
('s47@abc.com', 'Student 47', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 3, 2),
('s48@abc.com', 'Student 48', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 4, 3),
('s49@abc.com', 'Student 49', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 1, 4),
('s50@abc.com', 'Student 50', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 2, 5),
('s51@abc.com', 'Student 51', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 3, 1),
('s52@abc.com', 'Student 52', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 4, 2),
('s53@abc.com', 'Student 53', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 1, 3),
('s54@abc.com', 'Student 54', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 2, 4),
('s55@abc.com', 'Student 55', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 3, 5),
('s56@abc.com', 'Student 56', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 4, 1),
('s57@abc.com', 'Student 57', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 1, 2),
('s58@abc.com', 'Student 58', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 2, 3),
('s59@abc.com', 'Student 59', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 3, 4),
('s60@abc.com', 'Student 60', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 4, 5),
('s61@abc.com', 'Student 61', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 1, 1),
('s62@abc.com', 'Student 62', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 2, 2),
('s63@abc.com', 'Student 63', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 3, 3),
('s64@abc.com', 'Student 64', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 4, 4),
('s65@abc.com', 'Student 65', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 1, 5),
('s66@abc.com', 'Student 66', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 2, 1),
('s67@abc.com', 'Student 67', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 3, 2),
('s68@abc.com', 'Student 68', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 4, 3),
('s69@abc.com', 'Student 69', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 1, 4),
('s70@abc.com', 'Student 70', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 2, 5),
('s71@abc.com', 'Student 71', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 3, 1),
('s72@abc.com', 'Student 72', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 4, 2),
('s73@abc.com', 'Student 73', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 1, 3),
('s74@abc.com', 'Student 74', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 2, 4),
('s75@abc.com', 'Student 75', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 3, 5),
('s76@abc.com', 'Student 76', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 4, 1),
('s77@abc.com', 'Student 77', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 1, 2),
('s78@abc.com', 'Student 78', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 2, 3),
('s79@abc.com', 'Student 79', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 3, 4),
('s80@abc.com', 'Student 80', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 4, 5),
('s81@abc.com', 'Student 81', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 1, 1),
('s82@abc.com', 'Student 82', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 2, 2),
('s83@abc.com', 'Student 83', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 3, 3),
('s84@abc.com', 'Student 84', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 1, 4, 4),
('s85@abc.com', 'Student 85', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 1, 5),
('s86@abc.com', 'Student 86', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 2, 1),
('s87@abc.com', 'Student 87', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 3, 2),
('s88@abc.com', 'Student 88', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 2, 4, 3),
('s89@abc.com', 'Student 89', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 1, 4),
('s90@abc.com', 'Student 90', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 2, 5),
('s91@abc.com', 'Student 91', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 3, 1),
('s92@abc.com', 'Student 92', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 3, 4, 2),
('s93@abc.com', 'Student 93', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 1, 3),
('s94@abc.com', 'Student 94', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 2, 4),
('s95@abc.com', 'Student 95', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 3, 5),
('s96@abc.com', 'Student 96', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 4, 4, 1),
('s97@abc.com', 'Student 97', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 1, 2),
('s98@abc.com', 'Student 98', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 2, 3),
('s99@abc.com', 'Student 99', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 3, 4),
('s100@abc.com', 'Student 100', '$2a$10$9gtBYn1pZB/SbL425T2C9Osm8jUBiZ8Dzw7IFtM1Jq3kws6Ugx1Oy', 1, 5, 4, 5);

-- --------------------------------------------------------
-- Table: community_join_requests
-- --------------------------------------------------------
CREATE TABLE `community_join_requests` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `community_id` INT NOT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
  `requested_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `processed_at` TIMESTAMP NULL DEFAULT NULL,
  `processed_by_user_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_join_req_status` (`status`),
  INDEX `idx_join_req_user` (`user_id`),
  INDEX `idx_join_req_community` (`community_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`community_id`) REFERENCES `communities`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`processed_by_user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: subjects (Belong to a community + academic year + semester + status)
-- --------------------------------------------------------
CREATE TABLE `subjects` (
  `subject_id` INT NOT NULL AUTO_INCREMENT,
  `community_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT,
  `code` VARCHAR(50),
  `academic_year` TINYINT NOT NULL,
  `semester` TINYINT NOT NULL,
  `status` ENUM('upcoming', 'ongoing', 'completed') DEFAULT 'upcoming',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`subject_id`),
  INDEX `idx_subject_community` (`community_id`),
  INDEX `idx_subject_status` (`status`),
  FOREIGN KEY (`community_id`) REFERENCES `communities`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: topics (Each topic belongs to a subject)
-- --------------------------------------------------------
CREATE TABLE `topics` (
  `topic_id` INT NOT NULL AUTO_INCREMENT,
  `subject_id` INT NOT NULL,
  `title` VARCHAR(150) NOT NULL,
  `description` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`topic_id`),
  INDEX `idx_topic_subject` (`subject_id`),
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Demo Data: Subjects for different communities
-- --------------------------------------------------------
INSERT INTO `subjects` (`community_id`, `name`, `description`, `code`, `academic_year`, `semester`, `status`) VALUES
-- Computer Science Society (community 1)
(1, 'Data Structures', 'Core DS concepts and ADTs.', 'CS204', 3, 1, 'ongoing'),
(1, 'Algorithms', 'Algorithm design and analysis.', 'CS205', 3, 2, 'upcoming'),
(1, 'Database Systems', 'Relational databases and SQL.', 'CS301', 3, 1, 'ongoing'),
-- Engineering Students Hub (community 2)
(2, 'Calculus II', 'Integrals, series, and applications.', 'MA201', 2, 2, 'completed'),
(2, 'Physics for Engineers', 'Mechanics, waves, and heat.', 'PH102', 1, 2, 'ongoing'),
(2, 'Circuit Analysis', 'DC/AC circuit fundamentals.', 'EE201', 2, 1, 'ongoing'),
-- Medical Students Network (community 3)
(3, 'Anatomy', 'Human body structure.', 'MED101', 1, 1, 'completed'),
(3, 'Physiology', 'Function of human body systems.', 'MED102', 1, 2, 'ongoing'),
-- Business Students Forum (community 4)
(4, 'Marketing Management', 'Marketing principles and strategy.', 'BUS201', 2, 1, 'ongoing'),
(4, 'Financial Accounting', 'Accounting fundamentals.', 'BUS101', 1, 1, 'completed'),
-- Arts & Humanities Circle (community 5)
(5, 'Technical Writing', 'Clarity and structure in tech docs.', 'LA101', 1, 1, 'completed'),
(5, 'World Literature', 'Global literary traditions.', 'LIT201', 2, 1, 'ongoing');

-- --------------------------------------------------------
-- Demo Data: Topics for subjects
-- --------------------------------------------------------
INSERT INTO `topics` (`subject_id`, `title`, `description`) VALUES
-- Topics for Data Structures (subject_id 1)
(1, 'Arrays and Linked Lists', 'Introduction to basic data structures'),
(1, 'Stacks and Queues', 'LIFO and FIFO data structures'),
(1, 'Trees and Graphs', 'Non-linear data structures'),
(1, 'Hash Tables', 'Hash functions and collision resolution'),
-- Topics for Algorithms (subject_id 2)
(2, 'Sorting Algorithms', 'Bubble, merge, quick, and heap sort'),
(2, 'Searching Algorithms', 'Linear and binary search'),
(2, 'Dynamic Programming', 'Optimization problems'),
-- Topics for Database Systems (subject_id 3)
(3, 'SQL Basics', 'SELECT, INSERT, UPDATE, DELETE'),
(3, 'Database Design', 'Normalization and ER diagrams'),
(3, 'Transactions', 'ACID properties'),
-- Topics for Circuit Analysis (subject_id 6)
(6, 'Ohms Law', 'Voltage, current, and resistance relationships'),
(6, 'Kirchhoffs Laws', 'Circuit analysis fundamentals'),
-- Topics for Physiology (subject_id 8)
(8, 'Cardiovascular System', 'Heart and blood vessels'),
(8, 'Respiratory System', 'Lungs and breathing'),
-- Topics for Marketing Management (subject_id 9)
(9, 'Marketing Mix', 'Product, price, place, promotion'),
(9, 'Consumer Behavior', 'Understanding customer decisions');

-- --------------------------------------------------------
-- Table: subject_coordinators
-- --------------------------------------------------------
CREATE TABLE `subject_coordinators` (
  `coordinator_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `subject_id` INT NOT NULL,
  `assigned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`coordinator_id`),
  UNIQUE KEY `unique_user` (`user_id`),
  INDEX `idx_coordinator_subject` (`subject_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: topic_progress
-- --------------------------------------------------------
CREATE TABLE `topic_progress` (
  `progress_id` INT NOT NULL AUTO_INCREMENT,
  `topic_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `progress_percent` DECIMAL(5,2) DEFAULT 0.00,
  `last_accessed` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`progress_id`),
  UNIQUE KEY `unique_user_topic` (`user_id`, `topic_id`),
  INDEX `idx_progress_topic` (`topic_id`),
  INDEX `idx_progress_user` (`user_id`),
  FOREIGN KEY (`topic_id`) REFERENCES `topics`(`topic_id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Demo Data: Topic Progress for some students
-- --------------------------------------------------------
INSERT INTO `topic_progress` (`topic_id`, `user_id`, `progress_percent`, `last_accessed`) VALUES
-- Student 1 (user_id 22) - Community 1
(1, 22, 75.00, '2025-10-20 10:00:00'),
(2, 22, 50.00, '2025-10-20 09:30:00'),
(3, 22, 25.00, '2025-10-20 08:00:00'),
(4, 22, 100.00, '2025-10-19 14:00:00'),
(5, 22, 0.00, '2025-10-18 16:00:00'),
-- Student 2 (user_id 23)
(1, 23, 60.00, '2025-10-20 11:00:00'),
(2, 23, 80.00, '2025-10-20 10:30:00'),
-- Student 3 (user_id 24)
(1, 24, 90.00, '2025-10-20 12:00:00'),
(3, 24, 45.00, '2025-10-19 15:00:00'),
-- Student 5 (user_id 26) - Community 2
(11, 26, 65.00, '2025-10-20 09:00:00'),
(12, 26, 30.00, '2025-10-19 17:00:00'),
-- Student 9 (user_id 30) - Community 3
(13, 30, 85.00, '2025-10-20 08:30:00'),
(14, 30, 55.00, '2025-10-20 07:00:00'),
-- Student 13 (user_id 34) - Community 4
(15, 34, 70.00, '2025-10-20 13:00:00'),
(16, 34, 40.00, '2025-10-19 16:30:00');

COMMIT;