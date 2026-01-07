-- Community Posts Migration
-- Creates tables for community posts, likes, and comments

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table: community_posts
-- --------------------------------------------------------
CREATE TABLE `community_posts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `community_id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `content` TEXT NOT NULL,
  `image_url` VARCHAR(500) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_post_user` (`user_id`),
  INDEX `idx_post_community` (`community_id`),
  INDEX `idx_post_created` (`created_at`),
  FULLTEXT INDEX `idx_post_search` (`title`, `content`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`community_id`) REFERENCES `communities`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: post_likes
-- --------------------------------------------------------
CREATE TABLE `post_likes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_post_like` (`post_id`, `user_id`),
  INDEX `idx_like_post` (`post_id`),
  INDEX `idx_like_user` (`user_id`),
  FOREIGN KEY (`post_id`) REFERENCES `community_posts`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: post_comments
-- --------------------------------------------------------
CREATE TABLE `post_comments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `content` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_comment_post` (`post_id`),
  INDEX `idx_comment_user` (`user_id`),
  FOREIGN KEY (`post_id`) REFERENCES `community_posts`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Demo Data: Sample community posts
-- --------------------------------------------------------
-- Users 22-26 belong to community 1 (Computer Science Society)
INSERT INTO `community_posts` (`user_id`, `community_id`, `title`, `content`, `image_url`, `created_at`) VALUES
(22, 1, 'Data Structures Quiz Completed!', 'Just finished the Data Structures quiz! The questions on binary trees were really helpful for understanding the concepts. Thanks to everyone who contributed! 🎉', NULL, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(23, 1, 'Study Group for Database Exam', 'Looking for study partners for the upcoming Database exam. Anyone interested in forming a study group? Let''s ace this together! 📚', NULL, DATE_SUB(NOW(), INTERVAL 5 HOUR)),
(24, 1, 'React Hooks Notes Available', 'Uploaded new notes on React Hooks! Check out the Resources section. Hope it helps with your assignments. Feel free to share your feedback! 💻', NULL, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(25, 2, 'Algorithms Kuppi Session Review', 'Great Kuppi session today on Algorithms! Big thanks to the coordinator for the clear explanations. 🙌', NULL, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(26, 2, 'Midterm Study Tips Needed', 'Anyone have tips for the upcoming midterm? Looking for effective study strategies! 📖', NULL, DATE_SUB(NOW(), INTERVAL 3 DAY));

-- Demo Data: Sample likes
INSERT INTO `post_likes` (`post_id`, `user_id`) VALUES
(1, 23), (1, 24), (1, 25), (1, 26), (1, 27), (1, 28),
(2, 22), (2, 24), (2, 25), (2, 27),
(3, 22), (3, 23), (3, 25), (3, 26), (3, 27), (3, 28), (3, 29),
(4, 22), (4, 23), (4, 24),
(5, 22), (5, 23);

-- Demo Data: Sample comments
INSERT INTO `post_comments` (`post_id`, `user_id`, `content`, `created_at`) VALUES
(1, 23, 'Congrats! Those tree questions were tricky!', DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(1, 24, 'Same here, great quiz!', DATE_SUB(NOW(), INTERVAL 90 MINUTE)),
(2, 22, 'I''m interested! Count me in.', DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(2, 25, 'Me too! Let''s create a group chat.', DATE_SUB(NOW(), INTERVAL 3 HOUR)),
(2, 26, 'What topics should we focus on?', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(3, 24, 'Thanks for sharing! Very helpful.', DATE_SUB(NOW(), INTERVAL 20 HOUR)),
(3, 25, 'Love the examples in the notes!', DATE_SUB(NOW(), INTERVAL 18 HOUR));

COMMIT;
