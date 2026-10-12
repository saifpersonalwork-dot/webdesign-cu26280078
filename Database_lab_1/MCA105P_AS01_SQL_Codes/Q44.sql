-- MCA105P Lab Sheet 1 | Question 44
-- MySQL syntax

ALTER TABLE raw_data
CHANGE COLUMN temp_val converted_val DECIMAL(6,3),
ADD COLUMN processed_at TIMESTAMP AFTER converted_val;
