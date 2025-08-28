-- Migration: create student table and seed existing in-memory data
CREATE TABLE IF NOT EXISTS student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO student(name, email) VALUES
 ('Alice', 'alice@example.com'),
 ('Bob', 'bob@example.com')
ON DUPLICATE KEY UPDATE name = VALUES(name), email = VALUES(email);
