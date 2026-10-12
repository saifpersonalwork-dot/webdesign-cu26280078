-- MCA105P Lab Sheet 1 | Question 29
-- MySQL syntax

CREATE TABLE user_accounts (
    user_id BIGINT PRIMARY KEY,
    account_type ENUM('Standard', 'Premium', 'Admin'),
    created_timestamp TIMESTAMP
);
