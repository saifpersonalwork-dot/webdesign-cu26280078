-- MCA105P Lab Sheet 1 | Question 47
-- MySQL syntax

CREATE TABLE file_metadata (
    file_id INT PRIMARY KEY,
    file_path VARCHAR(500),
    file_size_bytes BIGINT,
    checksum CHAR(64)
);
