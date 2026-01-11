-- Community Polls Migration
-- Creates tables for polls attached to community posts

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table: community_post_polls
-- --------------------------------------------------------
CREATE TABLE `community_post_polls` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `question` VARCHAR(255) NOT NULL,
  `allow_multiple_choices` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_post_poll` (`post_id`),
  FOREIGN KEY (`post_id`) REFERENCES `community_posts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: community_poll_options
-- --------------------------------------------------------
CREATE TABLE `community_poll_options` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `poll_id` INT NOT NULL,
  `option_text` VARCHAR(255) NOT NULL,
  `vote_count` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_poll_option` (`poll_id`),
  FOREIGN KEY (`poll_id`) REFERENCES `community_post_polls`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: community_poll_votes
-- --------------------------------------------------------
CREATE TABLE `community_poll_votes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `poll_id` INT NOT NULL,
  `option_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_vote_option` (`user_id`, `option_id`), -- Prevent duplicate votes for same option by same user
  INDEX `idx_vote_poll` (`poll_id`),
  INDEX `idx_vote_user` (`user_id`),
  FOREIGN KEY (`poll_id`) REFERENCES `community_post_polls`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`option_id`) REFERENCES `community_poll_options`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

COMMIT;
