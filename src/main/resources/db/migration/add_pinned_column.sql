-- Migration to add pinned status to community posts
-- Allows moderators to pin important posts to the top of the feed

ALTER TABLE `community_posts` 
ADD COLUMN `is_pinned` BOOLEAN DEFAULT FALSE;

-- Add an index to improve performance for fetching pinned posts
CREATE INDEX `idx_post_pinned` ON `community_posts` (`community_id`, `is_pinned`);
