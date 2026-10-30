-- Database Schema for Online Complaint Management System
CREATE DATABASE IF NOT EXISTS cms_db;
USE cms_db;

-- Admin Users Table
CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

-- Complaints Table (CRUD operations)
CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id VARCHAR(20) UNIQUE NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending', -- Pending, In Progress, Resolved, Rejected
    admin_remark TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Seed Administrator Account
INSERT INTO admin_users (username, password, full_name) 
VALUES ('admin', 'admin123', 'System Administrator')
ON DUPLICATE KEY UPDATE id=id;

-- Seed Sample Grievances
INSERT INTO complaints (complaint_id, student_name, student_email, category, title, description, status, admin_remark)
VALUES 
('CMP-1001', 'Aditya Verma', 'aditya@university.edu', 'Infrastructure', 'Projector flickering in Lecture Hall B', 'Bulb is dim and HDMI connection disconnects repeatedly.', 'In Progress', 'Electrician assigned. Replacement bulb requisitioned.'),
('CMP-1002', 'Sneha Nair', 'sneha@university.edu', 'Hostel', 'Geyser water heater issue Block C', 'Hot water geyser tripped on the 3rd floor.', 'Resolved', 'Heating element replaced by maintenance at 2 PM.'),
('CMP-1003', 'Rohit Kumar', 'rohit@university.edu', 'Academic', 'DBMS Lab Exam Marks Missing', 'Lab grade recorded as absent despite submitting assignment.', 'Pending', 'Awaiting verification from course coordinator.')
ON DUPLICATE KEY UPDATE id=id;
