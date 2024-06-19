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

-- need
CREATE TABLE need (
    need_id INT PRIMARY KEY AUTO_INCREMENT,
    need_name VARCHAR(50) NOT NULL UNIQUE
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
    specialty_name VARCHAR(50) NOT NULL
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
    incident_date DATE NOT NULL,
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
('Athabaskan'),       
('Korean'),          
('Iranian');        

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
('Dene', 8),        
('Korean', 9),
('Farsi', 10);      

-- Insert Values for residency_status
INSERT INTO residency_status (residency_status_category) VALUES 
('Non-immigrant citizen”'), 
('Immigrant citizen or permanent resident'), 
('Other temporary resident permit');

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


-- Insert Values for need
INSERT INTO need (need_name) VALUES 
('Shelter'), 
('Food'), 
('Medical Care'), 
('Legal Assistance'), 
('Psychological Support'), 
('Financial Assistance'), 
('Counseling'), 
('Housing'),
('Employment');

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
INSERT INTO specialty (specialty_name) VALUES 
('Psychologist'),
('Lawyer'),
('Medical Doctor'),
('Social Worker'),
('Counselor'),
('Language');

-- Insert Values for violence_category
INSERT INTO violence_category (violence_category_name) VALUES
('Domestic Violence'),
('Intimate Partner Violence'),
('Bullying'),
('Workplace Violence');

-- Insert Values for help_seeker
INSERT INTO help_seeker (help_seeker_name, residency_status_id, gender_id, age, email, phone) VALUES
('Alice', 3, 2, 30, 'alice@example.com', '123-456-7890'),
('Bob', 3, 1, 25, 'bob@example.com', '234-567-8901'),
('Charlie', 3, 3, 35, 'charlie@example.com', '345-678-9012'),
('Diana', 2, 2, 28, 'diana@example.com', '456-789-0123'),
('Eve', 1, 4, 32, 'eve@example.com', '567-890-1234'),
('Frank', 3, 1, 40, 'frank@example.com', '678-901-2345');

-- Insert Values for incident
INSERT INTO incident (help_seeker_id, violence_category_id, location_id, incident_date, incident_description) VALUES
(1, 1, 14, '2024-01-01', 'Incident of domestic violence reported by Alice in Vancouver.'),
(2, 2, 13, '2024-02-01', 'Bob reported an intimate partner violence incident in Surrey.'),
(3, 3, 2, '2024-03-05', 'Charlie experienced a hate-crime incident in Burnaby.'),
(4, 4, 12, '2024-04-10', 'Diana reported workplace violence in Richmond.'),
(5, 2, 15, '2024-05-12', 'Eve experienced intimate partner violence in West Vancouver.'),
(6, 3, 7, '2024-06-15', 'Frank was a victim of a hate-crime in New Westminster.'),
(1, 4, 8, '2024-07-20',  'Alice reported ongoing workplace violence in North Vancouver.'),
(2, 1, 4, '2024-08-25',  'Bob experienced domestic violence in Delta.');

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

-- more additional data Jun 17 as placeholders
INSERT INTO help_seeker_functional_need (help_seeker_id, functional_need_id) VALUES
(1, 2), -- Alice needs hearing aid
(1, 3), -- Alice needs visual aid
(2, 1), -- Bob needs walking assistance
(2, 5), -- Bob needs self-care assistance
(3, 4), -- Charlie needs cognitive functioning assistance
(3, 7), -- Charlie needs mobility assistance
(4, 6), -- Diana needs communication assistance
(5, 3), -- Eve needs visual aid
(6, 2), -- Frank needs hearing aid
(6, 7); -- Frank needs mobility assistance

INSERT INTO help_seeker_language (help_seeker_id, language_id) VALUES
-- Alice speaks English and Mandarin Chinese
(1, 3),
(1, 1),

-- Bob speaks English and French
(2, 3),
(2, 4),

-- Charlie speaks Punjabi and Hindi
(3, 5),
(3, 6),

-- Diana speaks English and Spanish
(4, 3),
(4, 8),

-- Eve speaks Tamil and Arabic
(5, 11),
(5, 12),

-- Frank speaks English and Russian
(6, 3),
(6, 9);

    
