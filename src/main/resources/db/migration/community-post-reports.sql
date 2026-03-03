-- Community Post Reports Migration
-- Creates table for tracking user reports on community posts

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table: community_post_reports
-- --------------------------------------------------------
CREATE TABLE `community_post_reports` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `reporter_user_id` INT NOT NULL,
  `reason` VARCHAR(500) NOT NULL,
  `status` ENUM('pending', 'reviewed', 'dismissed') DEFAULT 'pending',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `reviewed_by` INT NULL,
  `reviewed_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_report` (`post_id`, `reporter_user_id`),
  INDEX `idx_post_reports` (`post_id`),
  INDEX `idx_status` (`status`),
  FOREIGN KEY (`post_id`) REFERENCES `community_posts`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`reporter_user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`reviewed_by`) REFERENCES `users`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

COMMIT;
