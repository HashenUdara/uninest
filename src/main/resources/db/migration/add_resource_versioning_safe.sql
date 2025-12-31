-- Migration script to add resource edit approval workflow support (SAFE VERSION)
-- This version checks if columns exist before adding them
-- Run this script on existing databases to add the new columns

-- Add parent_resource_id column if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'resources'
     AND COLUMN_NAME = 'parent_resource_id') = 0,
    'ALTER TABLE resources ADD COLUMN parent_resource_id INT DEFAULT NULL AFTER resource_id;',
    'SELECT "Column parent_resource_id already exists" AS message;'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add version column if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'resources'
     AND COLUMN_NAME = 'version') = 0,
    'ALTER TABLE resources ADD COLUMN version INT DEFAULT 1 AFTER parent_resource_id;',
    'SELECT "Column version already exists" AS message;'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add edit_type column if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'resources'
     AND COLUMN_NAME = 'edit_type') = 0,
    'ALTER TABLE resources ADD COLUMN edit_type ENUM(\'new\', \'edit\') DEFAULT \'new\' AFTER version;',
    'SELECT "Column edit_type already exists" AS message;'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add foreign key constraint if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
     WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'resources'
     AND CONSTRAINT_NAME = 'fk_resources_parent') = 0,
    'ALTER TABLE resources ADD CONSTRAINT fk_resources_parent FOREIGN KEY (parent_resource_id) REFERENCES resources(resource_id) ON DELETE CASCADE;',
    'SELECT "Foreign key fk_resources_parent already exists" AS message;'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

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
