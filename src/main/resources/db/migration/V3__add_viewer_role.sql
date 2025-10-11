-- Adds VIEWER role separately for existing environments already on V2
INSERT INTO roles(name, description) VALUES ('VIEWER','Read only user')
  ON DUPLICATE KEY UPDATE description=VALUES(description);
