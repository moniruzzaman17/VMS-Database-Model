
-- MySQL Queries for building a database model for Vehicles Managment System (VMS)

CREATE DATABASE IF NOT EXISTS vms_db;
USE vms_db;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    entity_name VARCHAR(255) NOT NULL,
    can_view BOOLEAN DEFAULT FALSE,
    can_edit BOOLEAN DEFAULT FALSE,
    can_add BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE vehicle_groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    registration_number VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    model VARCHAR(255),
    chassis_no VARCHAR(255),
    engine_no VARCHAR(255),
    manufacturer VARCHAR(255),
    vehicle_type VARCHAR(100) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    registration_expiry_date DATE,
    vehicle_group_id INT,
    vehicle_image VARCHAR(255),
    mileage_per_litre DECIMAL(5,2),
    gps_api_username VARCHAR(255),
    gps_api_password VARCHAR(255),
    api_url VARCHAR(255),
    FOREIGN KEY (vehicle_group_id) REFERENCES vehicle_groups(group_id) ON DELETE SET NULL
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    address TEXT
);

CREATE TABLE drivers (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mobile VARCHAR(20),
    age INT,
    license_no VARCHAR(255) UNIQUE NOT NULL,
    license_expiry_date DATE,
    experience_years INT,
    joining_date DATE,
    address TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    driver_photo VARCHAR(255),
    driver_document VARCHAR(255)
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    vehicle_id INT,
    driver_id INT,
    trip_type VARCHAR(100),
    trip_start_location VARCHAR(255),
    trip_end_location VARCHAR(255),
    trip_start_date DATE,
    trip_end_date DATE,
    approx_total_km DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    trip_status ENUM('completed', 'ongoing', 'cancelled') DEFAULT 'ongoing',
    email_sent BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

CREATE TABLE geofence_events (
    geofence_event_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    geo_name VARCHAR(255),
    geo_event ENUM('inside', 'outside'),
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);

CREATE TABLE income_expense (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    type ENUM('income', 'expense') NOT NULL,
    date DATE NOT NULL,
    description TEXT,
    amount DECIMAL(10,2),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);


CREATE TABLE parts_inventory (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    part_name VARCHAR(255) NOT NULL,
    description TEXT,
    stock INT NOT NULL DEFAULT 0,
    status ENUM('in stock', 'out of stock') DEFAULT 'in stock'
);

CREATE TABLE maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    start_date DATE,
    end_date DATE,
    service_details TEXT,
    vendor_name VARCHAR(255),
    total_cost DECIMAL(10,2),
    maintenance_status ENUM('completed', 'pending') DEFAULT 'pending',
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);

CREATE TABLE maintenance_parts (
    maintenance_part_id INT AUTO_INCREMENT PRIMARY KEY,
    maintenance_id INT,
    part_id INT,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (maintenance_id) REFERENCES maintenance(maintenance_id) ON DELETE CASCADE,
    FOREIGN KEY (part_id) REFERENCES parts_inventory(part_id) ON DELETE CASCADE
);

CREATE TABLE fuel (
    fuel_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    driver_id INT,
    fill_date DATE NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    odometer_reading DECIMAL(10,2),
    amount DECIMAL(10,2) NOT NULL,
    comments TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

CREATE TABLE reminders (
    reminder_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    reminder_date DATE NOT NULL,
    message TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);

CREATE TABLE tracking (
    tracking_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    history_tracking JSON,
    live_location TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);

CREATE TABLE email_templates (
    template_id INT AUTO_INCREMENT PRIMARY KEY,
    template_name VARCHAR(255) NOT NULL UNIQUE,
    template_content TEXT
);

CREATE TABLE settings (
    setting_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    address TEXT,
    invoice_prefix VARCHAR(50),
    currency_prefix VARCHAR(10),
    api_key VARCHAR(255),
    service_name VARCHAR(255),
    date_format VARCHAR(50),
    logo VARCHAR(255),
    invoice_terms TEXT
);

CREATE TABLE smtp_configuration (
    smtp_id INT AUTO_INCREMENT PRIMARY KEY,
    host VARCHAR(255) NOT NULL,
    auth BOOLEAN DEFAULT TRUE,
    username VARCHAR(255),
    password VARCHAR(255),
    secure_type ENUM('TLS', 'SSL') DEFAULT 'TLS',
    port INT NOT NULL,
    email_from VARCHAR(255),
    reply_to VARCHAR(255)
);
