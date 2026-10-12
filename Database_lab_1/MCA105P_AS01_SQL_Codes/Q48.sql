-- MCA105P Lab Sheet 1 | Question 48
-- MySQL syntax

ALTER TABLE file_metadata
MODIFY COLUMN file_id BIGINT,
MODIFY COLUMN file_path TEXT,
DROP COLUMN checksum;
