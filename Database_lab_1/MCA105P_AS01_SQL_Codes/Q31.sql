-- MCA105P Lab Sheet 1 | Question 31
-- MySQL syntax

ALTER TABLE order_items
DROP PRIMARY KEY,
ADD COLUMN order_item_id INT FIRST,
ADD PRIMARY KEY (order_item_id);
