-- Add new columns
ALTER TABLE users ADD COLUMN first_name VARCHAR(100) AFTER email;
ALTER TABLE users ADD COLUMN last_name VARCHAR(100) AFTER first_name;

-- Migrate existing data (Simple split by first space)
UPDATE users 
SET first_name = SUBSTRING_INDEX(name, ' ', 1), 
    last_name = CASE 
        WHEN name LIKE '% %' THEN SUBSTRING(name, LENGTH(SUBSTRING_INDEX(name, ' ', 1)) + 2)
        ELSE '' 
    END;

-- Drop old column
ALTER TABLE users DROP COLUMN name;
