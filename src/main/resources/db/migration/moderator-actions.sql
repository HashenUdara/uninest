-- Migration to create moderator_actions table
CREATE TABLE IF NOT EXISTS moderator_actions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    moderator_id INT NOT NULL,
    post_id INT DEFAULT NULL, -- Nullable in case the post is already gone, or for other types of actions
    action_type VARCHAR(50) NOT NULL, -- e.g., 'POST_DELETE'
    reason TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (moderator_id) REFERENCES users(id) ON DELETE CASCADE
);
