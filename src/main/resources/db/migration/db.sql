
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

COMMIT;