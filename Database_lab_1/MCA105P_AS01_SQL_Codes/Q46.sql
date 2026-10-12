-- MCA105P Lab Sheet 1 | Question 46
-- MySQL syntax

ALTER TABLE student_enrollments
DROP PRIMARY KEY,
ADD COLUMN enrollment_id BIGINT FIRST,
ADD PRIMARY KEY (enrollment_id);
