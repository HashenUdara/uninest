-- ==============================
-- RESOURCES TABLE (private by default)
-- ==============================
CREATE TABLE resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    topic_id INT NOT NULL,
    uploaded_by INT NOT NULL, -- references user_id (student or coordinator)
    category_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(100) NOT NULL,
    upload_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    visibility ENUM('private','public') DEFAULT 'private',
    approved_by INT DEFAULT NULL, -- subject coordinator who approved
    FOREIGN KEY (topic_id) REFERENCES topics(topic_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES resource_categories(category_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id),
    FOREIGN KEY (approved_by) REFERENCES users(user_id)
);

CREATE TABLE resource_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Seed data
INSERT INTO resource_categories (category_name, description) VALUES
('Lecture Notes', 'Notes or slides provided during lectures'),
('Short Notes', 'Concise summaries or quick revision materials'),
('Past Papers', 'Previous exam or test question papers'),
('Tutorials', 'Step-by-step exercises or practical lessons'),
('Assignments', 'Coursework or take-home exercises'),
('Lab Sheets', 'Experiment or practical lab instructions'),
('Video Tutorials', 'Recorded videos explaining course topics'),
('Project Reports', 'Example or reference project documentation'),
('Reference Materials', 'Books, articles, or external reading materials'),
('Model Answers', 'Example or solution sets for past papers or exercises');

