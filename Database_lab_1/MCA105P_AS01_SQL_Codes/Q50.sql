-- MCA105P Lab Sheet 1 | Question 50
-- MySQL syntax

CREATE TABLE application_logs (
    log_id BIGINT PRIMARY KEY,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR'),
    message TEXT,
    execution_time DOUBLE,
    created_at DATETIME
);

ALTER TABLE application_logs MODIFY COLUMN level VARCHAR(10);
