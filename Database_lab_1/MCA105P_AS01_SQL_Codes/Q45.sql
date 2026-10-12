-- MCA105P Lab Sheet 1 | Question 45
-- MySQL syntax

CREATE TABLE student_enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(10),
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id, semester)
);
