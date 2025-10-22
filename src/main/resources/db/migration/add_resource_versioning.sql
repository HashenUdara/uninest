-- Migration script to add resource edit approval workflow support
-- Run this script on existing databases to add the new columns

-- Add new columns to resources table if they don't exist
ALTER TABLE resources 
    ADD COLUMN IF NOT EXISTS parent_resource_id INT DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS version INT DEFAULT 1,
    ADD COLUMN IF NOT EXISTS edit_type ENUM('new', 'edit') DEFAULT 'new';

-- Add foreign key constraint for parent_resource_id if it doesn't exist
ALTER TABLE resources 
    ADD CONSTRAINT fk_resources_parent 
    FOREIGN KEY (parent_resource_id) REFERENCES resources(resource_id) ON DELETE CASCADE;

-- Modify status enum to include new statuses
ALTER TABLE resources 
    MODIFY COLUMN status ENUM('pending', 'approved', 'rejected', 'pending_edit', 'replaced') DEFAULT 'pending';

-- Set default values for existing records
UPDATE resources 
SET 
    version = 1,
    edit_type = 'new'
WHERE 
    version IS NULL OR edit_type IS NULL;

-- Verify migration
SELECT 
    'Migration completed successfully' AS status,
    COUNT(*) AS total_resources,
    SUM(CASE WHEN edit_type = 'new' THEN 1 ELSE 0 END) AS new_resources,
    SUM(CASE WHEN edit_type = 'edit' THEN 1 ELSE 0 END) AS edited_resources
FROM resources;
