-- Quiz Feature Migration
-- Creates tables for quizzes, questions, and options

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table: quizzes
-- --------------------------------------------------------
CREATE TABLE `quizzes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `author_id` INT NOT NULL,
  `subject_id` INT DEFAULT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `duration` INT DEFAULT 30, -- in minutes
  `is_published` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_quiz_author` (`author_id`),
  INDEX `idx_quiz_subject` (`subject_id`),
  FOREIGN KEY (`author_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: quiz_questions
-- --------------------------------------------------------
CREATE TABLE `quiz_questions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quiz_id` INT NOT NULL,
  `question_text` TEXT NOT NULL,
  `points` INT DEFAULT 1,
  `order_num` INT DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `idx_question_quiz` (`quiz_id`),
  FOREIGN KEY (`quiz_id`) REFERENCES `quizzes`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Table: quiz_options
-- --------------------------------------------------------
CREATE TABLE `quiz_options` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `question_id` INT NOT NULL,
  `option_text` TEXT NOT NULL,
  `is_correct` BOOLEAN DEFAULT FALSE,
  `order_num` INT DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `idx_option_question` (`question_id`),
  FOREIGN KEY (`question_id`) REFERENCES `quiz_questions`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------
-- Demo Data: Sample Quiz
-- --------------------------------------------------------
INSERT INTO `quizzes` (`author_id`, `subject_id`, `title`, `description`, `duration`, `is_published`) VALUES
(22, 1, 'Data Structures Basics', 'Test your knowledge on basic data structures like Arrays, Lists, and Stacks.', 15, TRUE);

INSERT INTO `quiz_questions` (`quiz_id`, `question_text`, `points`, `order_num`) VALUES
(1, 'What is the time complexity of accessing an element in an array by index?', 1, 1),
(1, 'Which data structure follows the LIFO (Last In First Out) principle?', 1, 2);

INSERT INTO `quiz_options` (`question_id`, `option_text`, `is_correct`, `order_num`) VALUES
(1, 'O(1)', TRUE, 1),
(1, 'O(n)', FALSE, 2),
(1, 'O(log n)', FALSE, 3),
(1, 'O(n^2)', FALSE, 4),
(2, 'Queue', FALSE, 1),
(2, 'Stack', TRUE, 2),
(2, 'Linked List', FALSE, 3),
(2, 'Tree', FALSE, 4);

COMMIT;
