-- Migration to add soft-delete columns to community_posts
ALTER TABLE community_posts 
ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE,
ADD COLUMN deleted_at TIMESTAMP NULL DEFAULT NULL;
