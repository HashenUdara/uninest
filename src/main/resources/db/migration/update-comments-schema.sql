-- Add parent_id to post_comments for nested replies
ALTER TABLE `post_comments` 
ADD COLUMN `parent_id` INT DEFAULT NULL AFTER `user_id`,
ADD CONSTRAINT `fk_comment_parent` 
FOREIGN KEY (`parent_id`) REFERENCES `post_comments`(`id`) ON DELETE CASCADE;
