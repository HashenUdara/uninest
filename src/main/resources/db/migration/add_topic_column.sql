-- Add topic column to community_posts table
-- This allows posts to be categorized by subject
-- Default value is "Common" for general discussions

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Add topic column with default value "Common"
ALTER TABLE `community_posts` 
ADD COLUMN `topic` VARCHAR(50) DEFAULT 'Common' 
AFTER `community_id`;

-- Add index for filtering by topic
CREATE INDEX `idx_post_topic` ON `community_posts`(`topic`);

-- Update existing posts to have "Common" as topic
UPDATE `community_posts` SET `topic` = 'Common' WHERE `topic` IS NULL;

COMMIT;
