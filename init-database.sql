-- Create studyplanner database
CREATE DATABASE IF NOT EXISTS studyplanner;

-- Use the studyplanner database
USE studyplanner;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Create tasks table
CREATE TABLE IF NOT EXISTS tasks (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     user_id INT,
                                     title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'PENDING',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );

-- Insert sample data
INSERT IGNORE INTO users (username, password, email) VALUES
('test', 'test', 'test@example.com'),
('admin', 'admin123', 'admin@example.com');