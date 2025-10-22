-- Migration script to add resource edit approval workflow support
-- Run this script on existing databases to add the new columns

-- Add parent_resource_id column
ALTER TABLE resources 
    ADD COLUMN parent_resource_id INT DEFAULT NULL AFTER resource_id;

-- Add version column
ALTER TABLE resources 
    ADD COLUMN version INT DEFAULT 1 AFTER parent_resource_id;

-- Add edit_type column
ALTER TABLE resources 
    ADD COLUMN edit_type ENUM('new', 'edit') DEFAULT 'new' AFTER version;

-- Add foreign key constraint for parent_resource_id
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
