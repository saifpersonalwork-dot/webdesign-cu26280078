-- MCA105P Lab Sheet 1 | Question 12
-- MySQL syntax

CREATE TABLE ticket_orders (
    ticket_id INT PRIMARY KEY,
    priority_level ENUM('Low', 'Medium', 'High')
);
