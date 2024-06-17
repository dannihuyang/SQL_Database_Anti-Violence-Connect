DROP DATABASE IF EXISTS anti_violence;
CREATE DATABASE IF NOT EXISTS anti_violence;
USE anti_violence;

-- Basic Information Part
-- gender
CREATE TABLE gender (
    gender_id INT PRIMARY KEY AUTO_INCREMENT,
    gender_category VARCHAR(50) NOT NULL UNIQUE
);

-- language_family
CREATE TABLE language_family (
    language_family_id INT PRIMARY KEY AUTO_INCREMENT,
    language_family_name VARCHAR(50) NOT NULL UNIQUE
);

-- language
CREATE TABLE language (
    language_id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(50) NOT NULL UNIQUE,
    language_family_id INT,
    FOREIGN KEY (language_family_id) REFERENCES language_family(language_family_id)
);

-- need part
-- need category
CREATE TABLE need_category (
    need_category_id INT PRIMARY KEY AUTO_INCREMENT,
    need_category_name VARCHAR(50) NOT NULL UNIQUE
);
-- need
CREATE TABLE need (
    need_id INT PRIMARY KEY AUTO_INCREMENT,
    need_name VARCHAR(50) NOT NULL UNIQUE,
    need_category_id INT,
    FOREIGN KEY (need_category_id) REFERENCES need_category(need_category_id)
);

-- residency_status
CREATE TABLE residency_status (
    residency_status_id INT PRIMARY KEY AUTO_INCREMENT,
    residency_status_category VARCHAR(50) NOT NULL UNIQUE
);

-- functional_need
CREATE TABLE functional_need (
    functional_need_id INT PRIMARY KEY AUTO_INCREMENT,
    functional_need_name VARCHAR(50) NOT NULL UNIQUE
);

-- location
CREATE TABLE location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(50) NOT NULL
);

-- Specialty and Resource
-- specialty
CREATE TABLE specialty (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(50) NOT NULL,
    certificate BLOB,
    specialty_description VARCHAR(255)
);

-- Help Seeker Part
-- help_seeker
CREATE TABLE help_seeker (
    help_seeker_id INT PRIMARY KEY AUTO_INCREMENT,
    help_seeker_name VARCHAR(50) NOT NULL,
    residency_status_id INT NOT NULL,
    gender_id INT NOT NULL,
    age INT,
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (residency_status_id) REFERENCES residency_status(residency_status_id),
    FOREIGN KEY (gender_id) REFERENCES gender(gender_id)
);

-- help_seeker_language
CREATE TABLE help_seeker_language (
    help_seeker_id INT,
    language_id INT,
    PRIMARY KEY (help_seeker_id, language_id),
    FOREIGN KEY (help_seeker_id) REFERENCES help_seeker(help_seeker_id),
    FOREIGN KEY (language_id) REFERENCES language(language_id)
);

-- help_seeker_functional_need
CREATE TABLE help_seeker_functional_need (
    help_seeker_id INT,
    functional_need_id INT,
    PRIMARY KEY (help_seeker_id, functional_need_id),
    FOREIGN KEY (help_seeker_id) REFERENCES help_seeker(help_seeker_id),
    FOREIGN KEY (functional_need_id) REFERENCES functional_need(functional_need_id)
);

-- Info of Volunteers
-- volunteer
CREATE TABLE volunteer (
    volunteer_id INT PRIMARY KEY AUTO_INCREMENT,
    volunteer_name VARCHAR(50) NOT NULL,
    gender_id INT,
    specialty_id INT,
    age INT,
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    availability TINYINT(1),
    specialty_certificate BLOB,
    specialty_description VARCHAR(255),
    FOREIGN KEY (gender_id) REFERENCES gender(gender_id),
    FOREIGN KEY (specialty_id) REFERENCES specialty(specialty_id)
);

-- volunteer_language
CREATE TABLE volunteer_language (
    volunteer_id INT,
    language_id INT,
    PRIMARY KEY (volunteer_id, language_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id),
    FOREIGN KEY (language_id) REFERENCES language(language_id)
);

-- volunteer_has_resource_list
CREATE TABLE volunteer_has_resource_list (
    volunteer_id INT,
    need_id INT,
    resource_description TEXT NOT NULL,
    PRIMARY KEY (volunteer_id, need_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id),
    FOREIGN KEY (need_id) REFERENCES need(need_id)
);

-- Incident
-- violence_category
CREATE TABLE violence_category (
    violence_category_id INT PRIMARY KEY AUTO_INCREMENT,
    violence_category_name VARCHAR(50) NOT NULL
);

-- incident
CREATE TABLE incident (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    help_seeker_id INT NOT NULL,
    violence_category_id INT NOT NULL,
    location_id INT,
    incident_start_date DATE NOT NULL,
    incident_end_date DATE,
    incident_description TEXT,
    FOREIGN KEY (help_seeker_id) REFERENCES help_seeker(help_seeker_id),
    FOREIGN KEY (violence_category_id) REFERENCES violence_category(violence_category_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

-- incident_need_list
CREATE TABLE incident_need_list (
    incident_need_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_id INT NOT NULL,
    need_id INT NOT NULL,
    need_description TEXT NOT NULL,
    FOREIGN KEY (incident_id) REFERENCES incident(incident_id),
    FOREIGN KEY (need_id) REFERENCES need(need_id)
);

-- intervention_status
CREATE TABLE intervention_status (
    intervention_status_id INT PRIMARY KEY AUTO_INCREMENT,
    intervention_status_name VARCHAR(50) NOT NULL
);

-- intervention
CREATE TABLE intervention (
    intervention_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_need_id INT NOT NULL,
    volunteer_id INT NOT NULL,
    intervention_start_date DATE NOT NULL,
    intervention_end_date DATE,
    intervention_description TEXT,
    intervention_status_id INT NOT NULL,
    FOREIGN KEY (incident_need_id) REFERENCES incident_need_list(incident_need_id),
    FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id),
    FOREIGN KEY (intervention_status_id) REFERENCES intervention_status(intervention_status_id)
);




-- Insert Values

-- Insert Values for gender
INSERT INTO gender (gender_category) VALUES 
('Male'), 
('Female'), 
('Non-Binary'), 
('Genderqueer'), 
('Agender'), 
('Bigender'), 
('Genderfluid'), 
('Other'), 
('Prefer not to say');

-- Insert Values for language_family
INSERT INTO language_family (language_family_name) VALUES 
('Sino-Tibetan'),    
('Indo-European'),   
('Afro-Asiatic'),    
('Austronesian'),    
('Dravidian'),       
('Algonquian'),      
('Salishan'),        
('Athabaskan');      

-- Insert Values for language
INSERT INTO language (language_name, language_family_id) VALUES 
('Mandarin Chinese', 1),
('Cantonese Chinese', 1),
('English', 2),
('French', 2),
('Punjabi', 2),
('Hindi', 2),
('Urdu', 2),
('Spanish', 2),
('Russian', 2),
('Tagalog', 4),      
('Tamil', 5),        
('Arabic', 3),
('Cree', 6),         
('Ojibwe', 6),      
('Salish', 7),       
('Dene', 8);       

-- Insert Values for residency_status
INSERT INTO residency_status (residency_status_category) VALUES 
('Citizen'), 
('Permanent Resident'), 
('Temporary Visa Holder'), 
('Refugee/Asylee'), 
('N/A');

-- Insert Values for location
INSERT INTO location (location_name) VALUES 
('Bowen Island'), 
('Burnaby'), 
('Coquitlam'), 
('Delta'), 
('Langley'), 
('Maple Ridge'), 
('New Westminster'), 
('North Vancouver'), 
('Pitt Meadows'), 
('Port Coquitlam'), 
('Port Moody'), 
('Richmond'), 
('Surrey'), 
('Vancouver'), 
('West Vancouver'), 
('White Rock');

-- Insert Values for need_category
INSERT INTO need_category (need_category_name) VALUES 
('Basic Needs'), 
('Medical Needs'), 
('Legal Needs'), 
('Psychological Needs'), 
('Physical Needs'), 
('Financial Needs'), 
('Counseling Needs'), 
('Accompanying Needs'), 
('Language/Translation Needs'), 
('Functional Needs');

-- Insert Values for need
INSERT INTO need (need_name, need_category_id) VALUES 
('Shelter', 1), 
('Food', 1), 
('Medical Care', 2), 
('Legal Assistance', 3), 
('Psychological Support', 4), 
('Physical Therapy', 5), 
('Financial Assistance', 6), 
('Counseling', 7), 
('Accompanying', 8), 
('Translation Services', 9), 
('French Translation', 9), 
('Chinese Translation', 9), 
('Walking Assistance', 10), 
('Hearing Assistance', 10), 
('Seeing Assistance', 10), 
('Cognitive Functioning Assistance', 10), 
('Self-Care Assistance', 10), 
('Communication Assistance', 10), 
('Mobility Assistance', 10);

-- Insert Values for functional_need
INSERT INTO functional_need (functional_need_name) VALUES 
('Walking'), 
('Hearing'), 
('Seeing'), 
('Cognitive Functioning'), 
('Self-Care'), 
('Communication'), 
('Mobility');

-- Insert Values for specialty
INSERT INTO specialty (specialty_name, certificate, specialty_description) VALUES 
('Psychologist', NULL, 'Provides psychological assessments and therapy'),
('Lawyer', NULL, 'Provides legal advice and representation'),
('Medical Doctor', NULL, 'Provides medical care and treatment'),
('Social Worker', NULL, 'Provides social support and resources'),
('Counselor', NULL, 'Provides counseling and mental health support'),
('Language', NULL, 'Provides translation and interpretation services');

-- Insert Values for violence_category
INSERT INTO violence_category (violence_category_name) VALUES
('Domestic Violence'),
('Intimate Partner Violence'),
('Hate Crime'),
('Workplace Violence');

-- Insert Values for help_seeker
INSERT INTO help_seeker (help_seeker_name, residency_status_id, gender_id, age, email, phone) VALUES
('Alice', 4, 2, 30, 'alice@example.com', '123-456-7890'),
('Bob', 3, 1, 25, 'bob@example.com', '234-567-8901'),
('Charlie', 3, 3, 35, 'charlie@example.com', '345-678-9012'),
('Diana', 2, 2, 28, 'diana@example.com', '456-789-0123'),
('Eve', 1, 4, 32, 'eve@example.com', '567-890-1234'),
('Frank', 5, 1, 40, 'frank@example.com', '678-901-2345');

-- Insert Values for incident
INSERT INTO incident (help_seeker_id, violence_category_id, location_id, incident_start_date, incident_end_date, incident_description) VALUES
(1, 1, 14, '2024-01-01', '2024-01-02', 'Incident of domestic violence reported by Alice in Vancouver.'),
(2, 2, 13, '2024-02-01', '2024-02-03', 'Bob reported an intimate partner violence incident in Surrey.'),
(3, 3, 2, '2024-03-05', '2024-03-07', 'Charlie experienced a hate-crime incident in Burnaby.'),
(4, 4, 12, '2024-04-10', '2024-04-11', 'Diana reported workplace violence in Richmond.'),
(5, 2, 15, '2024-05-12', '2024-05-13', 'Eve experienced intimate partner violence in West Vancouver.'),
(6, 3, 7, '2024-06-15', '2024-06-16', 'Frank was a victim of a hate-crime in New Westminster.'),
(1, 4, 8, '2024-07-20', NULL, 'Alice reported ongoing workplace violence in North Vancouver.'),
(2, 1, 4, '2024-08-25', '2024-08-26', 'Bob experienced domestic violence in Delta.');

-- Insert Values for incident_need_list
INSERT INTO incident_need_list (incident_id, need_id, need_description) VALUES
(1, 1, 'Temporary shelter required for Alice after domestic violence incident.'),
(1, 2, 'Provision of food supplies needed for Alice.'),
(2, 3, 'Counseling services required for Bob after intimate partner violence incident.'),
(3, 4, 'Legal assistance needed for Charlie after hate-crime incident.'),
(4, 5, 'Medical care required for Diana after workplace violence incident.'),
(5, 3, 'Counseling services needed for Eve after intimate partner violence incident.'),
(6, 6, 'Translation services required for Frank during hate-crime reporting.'),
(2, 7, 'Employment assistance needed for Bob.'),
(3, 8, 'Educational support required for Charlie.');

-- Insert Values for volunteer
INSERT INTO volunteer (volunteer_name, gender_id, specialty_id, age, email, phone, availability) VALUES
('John Doe', 1, 1, 45, 'john.doe@example.com', '555-1234', 1),
('Jane Smith', 2, 2, 38, 'jane.smith@example.com', '555-5678', 1),
('Alex Johnson', 3, 3, 50, 'alex.johnson@example.com', '555-9101', 1),
('Maria Garcia', 2, 4, 29, 'maria.garcia@example.com', '555-1122', 0),
('Michael Brown', 1, 5, 35, 'michael.brown@example.com', '555-3344', 1),
('Emily Davis', 2, 6, 42, 'emily.davis@example.com', '555-5566', 1);

-- Insert Values for intervention_status
INSERT INTO intervention_status (intervention_status_name) VALUES
('Pending'),
('In Progress'),
('Effective'),
('Escalated'),
('Closed');

-- Insert Values for intervention
INSERT INTO intervention (incident_need_id, volunteer_id, intervention_start_date, intervention_end_date, intervention_description, intervention_status_id) VALUES
(1, 1, '2024-01-02', '2024-01-05', 'Provided temporary shelter for Alice.', 3),
(2, 2, '2024-02-02', '2024-02-10', 'Provided legal assistance to Bob.', 3),
(3, 3, '2024-03-06', '2024-03-12', 'Offered legal representation for Charlie.', 2),
(4, 4, '2024-04-11', '2024-04-15', 'Arranged medical care for Diana.', 1),
(5, 5, '2024-05-13', '2024-05-20', 'Counseling services for Eve.', 3),
(6, 6, '2024-06-16', '2024-06-20', 'Provided translation services for Frank.', 2),
(7, 1, '2024-07-21', NULL, 'Ongoing workplace violence case for Alice.', 2),
(8, 2, '2024-08-26', NULL, 'Employment assistance for Bob.', 2),
(9, 1, '2024-03-08', '2024-03-15', 'Provided educational support for Charlie.', 3);
