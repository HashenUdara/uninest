-- ================================================
-- Clean SQL Schema for Auth & Roles
-- ================================================
-- Database: uninest_auth
-- Date: Oct 15, 2025
-- ================================================

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
-- Table: organizations
-- --------------------------------------------------------
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

-- --------------------------------------------------------
-- Table: users
-- --------------------------------------------------------
CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(120) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL,
  `organization_id` INT DEFAULT NULL,
  `academic_year` INT DEFAULT NULL,
  `university` VARCHAR(255) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE RESTRICT,
  FOREIGN KEY (`organization_id`) REFERENCES `organizations`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Add foreign key for organization moderator
ALTER TABLE `organizations`
  ADD FOREIGN KEY (`moderator_id`) REFERENCES `users`(`id`) ON DELETE CASCADE;

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