-- MCA105P Lab Sheet 1 | Question 43
-- MySQL syntax

ALTER TABLE clients
DROP PRIMARY KEY,
ADD COLUMN region_code CHAR(3),
ADD PRIMARY KEY (client_id, region_code);
