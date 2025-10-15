-- Drop old roles table if exists
DROP TABLE IF EXISTS `roles`;

-- Recreate roles table with inheritance support
CREATE TABLE `roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  `description` VARCHAR(255) DEFAULT NULL,
  `inherits_from` INT DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`inherits_from`) REFERENCES `roles`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert new hierarchical roles
INSERT INTO `roles` (`id`, `name`, `description`, `inherits_from`) VALUES
(1, 'student', 'Basic student privileges for accessing platform resources', NULL),
(2, 'subject_coordinator', 'Can manage subjects, topics, and upload resources', 1),
(3, 'moderator', 'Can review, edit, or remove inappropriate resources', 1),
(4, 'admin', 'Full system privileges including user and content management', 1);

-- Ensure AUTO_INCREMENT continues correctly
ALTER TABLE `roles`
  MODIFY `id` INT NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
