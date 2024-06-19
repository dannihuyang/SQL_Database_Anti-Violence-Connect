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
('Alice', 1, 2, 30, 'alice@example.com', '123-456-7890'),
('Bob', 2, 3, 25, 'bob@example.com', '234-567-8901'),
('Charlie', 1, 3, 35, 'charlie@example.com', '345-678-9012'),
('Diana', 1, 2, 28, 'diana@example.com', '456-789-0123'),
('Eve', 1, 4, 32, 'eve@example.com', '567-890-1234'),
('Frank', 3, 8, 40, 'frank@example.com', '678-901-2345'),
('Grace', 1, 2, 22, 'grace@example.com', '789-012-3456'),
('Hank', 2, 9, 44, 'hank@example.com', '890-123-4567'),
('Ivy', 2, 3, 55, 'ivy@example.com', '901-234-5678'),
('Sally', 2, 2, 23, 'sally@example.com', '012-345-6789'),
('Kim', 1, 4, 61, 'kim@example.com', '123-678-3450'),
('Liam', 1, 2, 67, 'liam@example.com', '345-678-9012'),
('Mia', 2, 2, 27, 'mia@example.com', '456-789-0123'),
('Noah', 1, 1, 34, 'noah@example.com', '567-890-1234'),
('Olivia', 1, 5, 30, 'olivia@example.com', '678-901-2345'),
('Paul', 1, 3, 45, 'paul@example.com', '789-012-3456'),
('Quinn', 1, 8, 29, 'quinn@example.com', '890-123-4567'),
('Rita', 2, 2, 26, 'rita@example.com', '901-234-5678'),
('Sam', 3, 1, 22, 'sam@example.com', '012-345-6789'),
('Tina', 1, 2, 31, 'tina@example.com', '123-456-7890'),
('Uma', 2, 6, 33, 'uma@example.com', '234-567-8901'),
('Victoria', 1, 2, 14, 'victoria@example.com', '345-678-9012'),
('Wendy', 1, 2, 28, 'wendy@example.com', '456-789-0123'),
('Xander', 2, 3, 41, 'xander@example.com', '567-890-1234'),
('Yara', 1, 7, 36, 'yara@example.com', '678-901-2345'),
('Zack', 1, 6, 24, 'zack@example.com', '789-012-3456'),
('Amy', 1, 2, 27, 'amy@example.com', '890-123-4567'),
('Tracy', 3, 2, 50, 'tracy@example.com', '901-234-5678'),
('Clara', 1, 8, 23, 'clara@example.com', '012-345-6789'),
('Dave', 2, 3, 33, 'dave@example.com', '123-456-7890'),
('Ella', 3, 4, 32, 'ella@example.com', '234-567-8901'),
('Felix', 1, 2, 46, 'felix@example.com', '345-678-9012'),
('Gina', 1, 2, 30, 'gina@example.com', '456-789-0123'),
('Harry', 3, 1, 39, 'harry@example.com', '567-890-1234'),
('Isla', 1, 2, 25, 'isla@example.com', '678-901-2345'),
('Bethany', 2, 2, 59, 'Beth@example.com', '789-012-3456'),
('Kara', 3, 5, 37, 'kara@example.com', '890-123-4567'),
('Lee', 1, 2, 13, 'lee@example.com', '901-234-5678'),
('Mona', 2, 2, 34, 'mona@example.com', '012-345-6789'),
('Nina', 1, 4, 30, 'nina@example.com', '123-456-7890'),
('Omar', 1, 1, 28, 'omar@example.com', '234-567-8901'),
('Pia', 2, 2, 22, 'pia@example.com', '345-678-9012'),
('Rick', 3, 9, 31, 'rick@example.com', '456-789-0123'),
('Sara', 1, 2, 33, 'sara@example.com', '567-890-1234'),
('Tom', 1, 1, 40, 'tom@example.com', '678-901-2345'),
('Ula', 3, 6, 35, 'ula@example.com', '789-012-3456'),
('Vera', 1, 2, 60, 'vera@example.com', '890-123-4567'),
('Will', 2, 1, 60, 'will@example.com', '901-234-5678'),
('Xena', 3, 4, 30, 'xena@example.com', '012-345-6789'),
('Yuri', 1, 1, 29, 'yuri@example.com', '123-456-7890'),
('Zara', 2, 2, 31, 'zara@example.com', '234-567-8901'),
('Alan', 3, 3, 25, 'alan@example.com', '345-678-9012'),
('Beth', 1, 8, 30, 'beth@example.com', '456-789-0123'),
('Carl', 2, 1, 34, 'carl@example.com', '567-890-1234'),
('Dora', 1, 4, 32, 'dora@example.com', '678-901-2345'),
('Evan', 1, 1, 28, 'evan@example.com', '789-012-3456'),
('Fay', 2, 2, 27, 'fay@example.com', '890-123-4567'),
('Glen', 3, 1, 35, 'glen@example.com', '901-234-5678'),
('Hope', 1, 2, 29, 'hope@example.com', '012-345-6789'),
('Ian', 2, 1, 24, 'ian@example.com', '123-456-7890'),
('Jill', 3, 7, 36, 'jill@example.com', '234-567-8901'),
('Kyle', 1, 9, 31, 'kyle@example.com', '345-678-9012'),
('Lana', 2, 2, 30, 'lana@example.com', '456-789-0123'),
('Mark', 3, 1, 37, 'mark@example.com', '567-890-1234'),
('Nora', 1, 2, 25, 'nora@example.com', '678-901-2345'),
('Owen', 2, 1, 39, 'owen@example.com', '789-012-3456'),
('Pam', 3, 5, 30, 'pam@example.com', '890-123-4567'),
('Quinn', 1, 1, 27, 'quinn@example.com', '901-234-5678'),
('Ruth', 2, 8, 22, 'ruth@example.com', '012-345-6789'),
('Steve', 3, 9, 31, 'steve@example.com', '123-456-7890'),
('Tara', 1, 2, 34, 'tara@example.com', '234-567-8901'),
('Uri', 1, 9, 28, 'uri@example.com', '345-678-9012'),
('Vicky', 3, 4, 32, 'vicky@example.com', '456-789-0123'),
('Walt', 1, 1, 25, 'walt@example.com', '567-890-1234'),
('Xia', 2, 2, 70, 'xia@example.com', '678-901-2345'),
('Yvonne', 1, 6, 33, 'yvonne@example.com', '789-012-3456'),
('Zane', 1, 1, 27, 'zane@example.com', '890-123-4567'),
('Anna', 1, 2, 62, 'anna@example.com', '901-234-5678'),
('Blake', 3, 1, 31, 'blake@example.com', '012-345-6789'),
('Cora', 1, 2, 22, 'cora@example.com', '123-456-7890'),
('Dean', 2, 1, 35, 'dean@example.com', '234-567-8901'),
('Ella', 3, 4, 29, 'ella@example.com', '345-678-9012'),
('Finn', 1, 2, 53, 'finn@example.com', '456-789-0123'),
('Gail', 1, 2, 28, 'gail@example.com', '567-890-1234'),
('Hank', 3, 1, 40, 'hank@example.com', '678-901-2345'),
('Ivy', 1, 2, 23, 'ivy@example.com', '789-012-3456'),
('Jade', 2, 2, 63, 'Jade@example.com', '890-123-4567'),
('Kara', 1, 5, 36, 'kara@example.com', '901-234-5678'),
('Mona', 2, 2, 25, 'mona@example.com', '123-456-7890'),
('Nina', 3, 4, 34, 'nina@example.com', '234-567-8901'),
('Oasis', 1, 2, 18, 'oasis@example.com', '345-678-9012'),
('Pia', 2, 2, 30, 'pia@example.com', '456-789-0123'),
('Quinn', 1, 4, 32, 'quinn@example.com', '567-890-1234'),
('Rita', 1, 2, 27, 'rita@example.com', '678-901-2345'),
('Taylor', 1, 2, 45, 'taylor@example.com', '789-012-3456'),
('Lia', 1, 9, 68, 'Lia@example.com', '346-676-9062'),
('Felix', 1, 9, 28, 'felix@example.com', '345-678-9012'),
('Loha', 1, 2, 65, 'Loha@example.com', '345-678-9012'),
('Belle', 1, 5, 17, 'Belle@example.com', '345-678-9012'),
('Tina', 3, 7, 13, 'tina@example.com', '890-123-4567');

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

    
