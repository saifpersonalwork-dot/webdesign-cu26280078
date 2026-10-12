-- MCA105P Lab Sheet 1 | Question 4
-- MySQL syntax

CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY,
    action TEXT,
    created_at TIMESTAMP
);
