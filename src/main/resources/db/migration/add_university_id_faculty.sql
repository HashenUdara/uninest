-- Migration: Add University ID Number and Faculty fields to users table
-- Date: 2026-01-19
-- Description: Adds two new columns to store student/staff university ID number and faculty affiliation

ALTER TABLE users 
ADD COLUMN university_id_number VARCHAR(50) COMMENT 'University student/staff ID (e.g., 2013/CS/025)';

ALTER TABLE users 
ADD COLUMN faculty VARCHAR(100) COMMENT 'Faculty name (e.g., Faculty of Arts)';
