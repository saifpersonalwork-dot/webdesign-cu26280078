-- MCA105P Lab Sheet 1 | Question 30
-- MySQL syntax

CREATE TABLE device_logs (
    log_id BIGINT PRIMARY KEY,
    ip_address VARCHAR(45),
    payload LONGBLOB
);
