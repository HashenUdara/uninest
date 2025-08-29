-- Schema for users and roles
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(100) NOT NULL,
  enabled TINYINT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS user_roles (
  user_id INT NOT NULL,
  role VARCHAR(40) NOT NULL,
  PRIMARY KEY(user_id, role),
  CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Seed admin user (password: admin123) hashed via BCrypt example hash below; replace in prod.
INSERT INTO users(email, password_hash, enabled)
VALUES ('admin@example.com', '$2a$10$7yD1V0Y6lJHjvQxgXOx6n.6qQhB7dX8wS7Lk6q9lYJcLz7x1E3Q.q', 1)
ON DUPLICATE KEY UPDATE email = email;

INSERT IGNORE INTO user_roles(user_id, role)
SELECT id, 'ADMIN' FROM users WHERE email='admin@example.com';
