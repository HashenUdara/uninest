-- Creates roles and users tables (normalized roles)
-- If you already have a users table with a 'role' enum, migrate manually instead of running this blindly.

CREATE TABLE IF NOT EXISTS roles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL UNIQUE,
  description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO roles(name, description) VALUES
  ('ADMIN','Administrator'),
  ('MANAGER','Manager'),
  ('STAFF','Staff member')
ON DUPLICATE KEY UPDATE description = VALUES(description);

-- Create users table only if it does not yet exist (normalized with role_id FK)
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Helper (optional) seed admin (replace hash!)
-- Demo users (passwords: admin123, staff123)
INSERT INTO users(email,password_hash,role_id) VALUES
  ('admin@example.com', '$2a$12$Cq7cP5X4gJv/n.vEZIbhB.TY2Ad5nvz2OZGhlyBWco2JmtTAdeq5C', (SELECT id FROM roles WHERE name='ADMIN')),
  ('manager@example.com', '$2a$12$eLugNJPD85Ri.cYxNULn8.nSiBN6/zgG41R2tayK9nH9D4HcQlF7i', (SELECT id FROM roles WHERE name='MANAGER')),
  ('staff1@example.com', '$2a$12$WDTAiumc5c95r/kIvFobJuGc7KzJjz78OQVj8YYZ/.c1kaNO59d9W', (SELECT id FROM roles WHERE name='STAFF'))
ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash);
