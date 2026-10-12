-- MCA105P Database Technologies Lab Sheet 1
-- Solutions for all 50 DDL questions (MySQL syntax)


-- ============ QUESTION 1 ============
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- ============ QUESTION 2 ============
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    salary DECIMAL(10,2)
);

-- ============ QUESTION 3 ============
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE
);

-- ============ QUESTION 4 ============
CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY,
    action TEXT,
    created_at TIMESTAMP
);

-- ============ QUESTION 5 ============
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    is_available BOOLEAN
);

-- ============ QUESTION 6 ============
CREATE TABLE system_settings (
    setting_id SMALLINT PRIMARY KEY,
    setting_key VARCHAR(50),
    setting_value VARCHAR(100)
);

-- ============ QUESTION 7 ============
ALTER TABLE employees ADD COLUMN email VARCHAR(100);

-- ============ QUESTION 8 ============
ALTER TABLE products DROP COLUMN is_available;

-- ============ QUESTION 9 ============
RENAME TABLE departments TO dept_units;

-- ============ QUESTION 10 ============
TRUNCATE TABLE audit_logs;

-- ============ QUESTION 11 ============
CREATE TABLE user_profiles (
    user_id INT PRIMARY KEY,
    bio TEXT,
    profile_pic BLOB
);

-- ============ QUESTION 12 ============
CREATE TABLE ticket_orders (
    ticket_id INT PRIMARY KEY,
    priority_level ENUM('Low', 'Medium', 'High')
);

-- ============ QUESTION 13 ============
DROP TABLE products;

-- ============ QUESTION 14 ============
ALTER TABLE employees MODIFY COLUMN email VARCHAR(150);

-- ============ QUESTION 15 ============
CREATE TABLE sensor_data (
    read_id BIGINT PRIMARY KEY,
    temperature FLOAT
);

-- ============ QUESTION 16 ============
ALTER TABLE student_courses
ADD PRIMARY KEY (student_id, course_id);

-- ============ QUESTION 17 ============
ALTER TABLE employees RENAME COLUMN first_name TO given_name;

-- ============ QUESTION 18 ============
ALTER TABLE system_settings DROP PRIMARY KEY;

-- ============ QUESTION 19 ============
CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    registration_time TIME
);

-- ============ QUESTION 20 ============
ALTER TABLE clients ADD PRIMARY KEY (client_id);

-- ============ QUESTION 21 ============
CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    quantity INT,
    unit_price DECIMAL(8,2),
    PRIMARY KEY (order_id, item_id)
);

-- ============ QUESTION 22 ============
CREATE TABLE event_schedules (
    event_id INT,
    venue_id INT,
    event_date DATE,
    duration_hours TINYINT,
    PRIMARY KEY (event_id, venue_id)
);

-- ============ QUESTION 23 ============
ALTER TABLE employees
ADD COLUMN hire_date DATE,
ADD COLUMN is_active BOOLEAN;

-- ============ QUESTION 24 ============
ALTER TABLE employees
DROP COLUMN email,
MODIFY COLUMN salary DECIMAL(12,2);

-- ============ QUESTION 25 ============
ALTER TABLE inventory ADD PRIMARY KEY (warehouse_id, sku);

-- ============ QUESTION 26 ============
ALTER TABLE user_profiles MODIFY COLUMN bio MEDIUMTEXT;

-- ============ QUESTION 27 ============
ALTER TABLE employees ADD COLUMN middle_name VARCHAR(30) AFTER given_name;

-- ============ QUESTION 28 ============
CREATE TABLE geolocations (
    location_id INT PRIMARY KEY,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

-- ============ QUESTION 29 ============
CREATE TABLE user_accounts (
    user_id BIGINT PRIMARY KEY,
    account_type ENUM('Standard', 'Premium', 'Admin'),
    created_timestamp TIMESTAMP
);

-- ============ QUESTION 30 ============
CREATE TABLE device_logs (
    log_id BIGINT PRIMARY KEY,
    ip_address VARCHAR(45),
    payload LONGBLOB
);

-- ============ QUESTION 31 ============
ALTER TABLE order_items
DROP PRIMARY KEY,
ADD COLUMN order_item_id INT FIRST,
ADD PRIMARY KEY (order_item_id);

-- ============ QUESTION 32 ============
ALTER TABLE projects CHANGE COLUMN start_date project_year YEAR;

-- ============ QUESTION 33 ============
CREATE TABLE document_store (
    doc_id INT PRIMARY KEY,
    doc_title VARCHAR(255),
    content LONGTEXT
);

-- ============ QUESTION 34 ============
ALTER TABLE document_store RENAME COLUMN content TO doc_body;

-- ============ QUESTION 35 ============
CREATE TABLE employees_archive LIKE employees;

-- ============ QUESTION 36 ============
DROP TABLE IF EXISTS employees_archive;

-- ============ QUESTION 37 ============
CREATE TABLE financial_ledger (
    entry_id BIGINT PRIMARY KEY,
    debit DECIMAL(15,4),
    credit DECIMAL(15,4)
);

-- ============ QUESTION 38 ============
ALTER TABLE financial_ledger ADD COLUMN transaction_date DATETIME FIRST;

-- ============ QUESTION 39 ============
CREATE TABLE measurements (
    sample_id INT PRIMARY KEY,
    value DOUBLE
);

-- ============ QUESTION 40 ============
CREATE TABLE app_users (
    user_id INT PRIMARY KEY,
    status_code TINYINT
);

-- ============ QUESTION 41 ============
CREATE TABLE transactions (
    xact_id BIGINT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    channel ENUM('Web', 'Mobile', 'ATM'),
    status VARCHAR(20),
    xact_time TIMESTAMP
);

-- ============ QUESTION 42 ============
CREATE TABLE system_events (
    event_id BIGINT,
    node_id SMALLINT,
    event_payload TEXT,
    logged_time TIMESTAMP,
    PRIMARY KEY (event_id, node_id)
);

-- ============ QUESTION 43 ============
ALTER TABLE clients
DROP PRIMARY KEY,
ADD COLUMN region_code CHAR(3),
ADD PRIMARY KEY (client_id, region_code);

-- ============ QUESTION 44 ============
ALTER TABLE raw_data
CHANGE COLUMN temp_val converted_val DECIMAL(6,3),
ADD COLUMN processed_at TIMESTAMP AFTER converted_val;

-- ============ QUESTION 45 ============
CREATE TABLE student_enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(10),
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id, semester)
);

-- ============ QUESTION 46 ============
ALTER TABLE student_enrollments
DROP PRIMARY KEY,
ADD COLUMN enrollment_id BIGINT FIRST,
ADD PRIMARY KEY (enrollment_id);

-- ============ QUESTION 47 ============
CREATE TABLE file_metadata (
    file_id INT PRIMARY KEY,
    file_path VARCHAR(500),
    file_size_bytes BIGINT,
    checksum CHAR(64)
);

-- ============ QUESTION 48 ============
ALTER TABLE file_metadata
MODIFY COLUMN file_id BIGINT,
MODIFY COLUMN file_path TEXT,
DROP COLUMN checksum;

-- ============ QUESTION 49 ============
CREATE TABLE sensor_readings (
    sensor_id INT,
    recorded_at TIMESTAMP,
    reading FLOAT,
    PRIMARY KEY (sensor_id, recorded_at)
);

RENAME TABLE sensor_readings TO historical_sensor_readings;

-- ============ QUESTION 50 ============
CREATE TABLE application_logs (
    log_id BIGINT PRIMARY KEY,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR'),
    message TEXT,
    execution_time DOUBLE,
    created_at DATETIME
);

ALTER TABLE application_logs MODIFY COLUMN level VARCHAR(10);
