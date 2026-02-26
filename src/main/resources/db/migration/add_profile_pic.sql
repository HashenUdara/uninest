ALTER TABLE users ADD COLUMN profile_picture VARCHAR(255) AFTER phone_number;
ALTER TABLE users ADD COLUMN profile_picture_blob LONGBLOB;

