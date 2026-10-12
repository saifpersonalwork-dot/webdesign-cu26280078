-- MCA105P Lab Sheet 1 | Question 22
-- MySQL syntax

CREATE TABLE event_schedules (
    event_id INT,
    venue_id INT,
    event_date DATE,
    duration_hours TINYINT,
    PRIMARY KEY (event_id, venue_id)
);
