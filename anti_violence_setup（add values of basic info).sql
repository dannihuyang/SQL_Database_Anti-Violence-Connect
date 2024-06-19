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
(1, 1, 14, '2023-01-01', 'Incident of domestic violence reported by Alice in Vancouver.'),
(2, 2, 13, '2023-02-01', 'Bob reported an intimate partner violence incident in Surrey.'),
(3, 3, 2, '2023-03-05', 'Charlie experienced bullying in Burnaby.'),
(4, 4, 12, '2023-04-10', 'Diana reported workplace violence in Richmond.'),
(5, 2, 15, '2023-05-12', 'Eve experienced intimate partner violence in West Vancouver.'),
(6, 1, 7, '2023-06-15', 'Frank was a victim of domestic violence in New Westminster.'),
(7, 4, 8, '2023-07-20', 'Grace reported workplace violence in North Vancouver.'),
(8, 3, 4, '2023-08-25', 'Hank experienced bullying in Delta.'),
(9, 2, 9, '2023-09-01', 'Ivy reported an intimate partner violence incident in Pitt Meadows.'),
(10, 3, 6, '2023-10-05', 'Sally experienced bullying in Maple Ridge.'),
(11, 4, 11, '2023-11-10', 'Kim reported workplace violence in Port Coquitlam.'),
(12, 1, 14, '2023-12-15', 'Liam experienced domestic violence in Vancouver.'),
(13, 2, 13, '2024-01-20', 'Mia reported an intimate partner violence incident in Surrey.'),
(14, 3, 10, '2024-02-25', 'Noah experienced bullying in Port Moody.'),
(15, 4, 8, '2024-03-01', 'Olivia reported workplace violence in North Vancouver.'),
(16, 2, 5, '2024-04-05', 'Paul experienced intimate partner violence in Langley.'),
(17, 3, 3, '2024-05-10', 'Quinn was a victim of bullying in Coquitlam.'),
(18, 4, 1, '2024-06-15', 'Rita reported workplace violence in Bowen Island.'),
(19, 1, 4, '2024-07-20', 'Sam experienced domestic violence in Delta.'),
(20, 2, 2, '2024-08-25', 'Tina reported an intimate partner violence incident in Burnaby.'),
(21, 3, 4, '2024-09-01', 'Uma experienced bullying in Vancouver.'),
(22, 1, 5, '2024-10-05', 'Victoria experienced domestic violence in Langley.'),
(23, 2, 6, '2024-11-10', 'Wendy reported an intimate partner violence incident in Maple Ridge.'),
(24, 3, 7, '2024-12-15', 'Xander experienced bullying in New Westminster.'),
(25, 4, 8, '2025-01-20', 'Yara reported workplace violence in North Vancouver.'),
(26, 2, 9, '2025-02-25', 'Zack reported an intimate partner violence incident in Pitt Meadows.'),
(27, 1, 10, '2025-03-01', 'Amy experienced domestic violence in Port Moody.'),
(28, 3, 11, '2025-04-05', 'Tracy experienced bullying in Port Coquitlam.'),
(29, 2, 12, '2025-05-10', 'Clara reported an intimate partner violence incident in Richmond.'),
(30, 4, 13, '2025-06-15', 'Dave reported workplace violence in Surrey.'),
(31, 1, 14, '2025-07-20', 'Ella experienced domestic violence in Vancouver.'),
(32, 3, 15, '2025-08-25', 'Felix experienced bullying in West Vancouver.'),
(33, 2, 1, '2025-09-01', 'Gina reported an intimate partner violence incident in Bowen Island.'),
(34, 1, 2, '2025-10-05', 'Harry experienced domestic violence in Burnaby.'),
(35, 4, 3, '2025-11-10', 'Isla reported workplace violence in Coquitlam.'),
(36, 2, 4, '2025-12-15', 'Bethany reported an intimate partner violence incident in Delta.'),
(37, 3, 5, '2026-01-20', 'Kara experienced bullying in Langley.'),
(38, 4, 6, '2026-02-25', 'Lee reported workplace violence in Maple Ridge.'),
(39, 1, 7, '2026-03-01', 'Mona experienced domestic violence in New Westminster.'),
(40, 3, 8, '2026-04-05', 'Nina experienced bullying in North Vancouver.'),
(41, 2, 9, '2026-05-10', 'Omar reported an intimate partner violence incident in Pitt Meadows.'),
(42, 1, 10, '2026-06-15', 'Pia experienced domestic violence in Port Moody.'),
(43, 4, 11, '2026-07-20', 'Rick reported workplace violence in Port Coquitlam.'),
(44, 3, 12, '2026-08-25', 'Sara experienced bullying in Richmond.'),
(45, 1, 13, '2026-09-01', 'Tom experienced domestic violence in Surrey.'),
(46, 4, 14, '2026-10-05', 'Ula reported workplace violence in Vancouver.'),
(47, 2, 15, '2026-11-10', 'Vera reported an intimate partner violence incident in West Vancouver.'),
(48, 3, 1, '2026-12-15', 'Will experienced bullying in Bowen Island.'),
(49, 4, 2, '2027-01-20', 'Xena reported workplace violence in Burnaby.'),
(50, 2, 3, '2027-02-25', 'Yuri reported an intimate partner violence incident in Coquitlam.'),
(51, 1, 4, '2027-03-01', 'Zara experienced domestic violence in Delta.'),
(52, 3, 5, '2027-04-05', 'Alan experienced bullying in Langley.'),
(53, 2, 6, '2027-05-10', 'Beth reported an intimate partner violence incident in Maple Ridge.'),
(54, 1, 7, '2027-06-15', 'Carl experienced domestic violence in New Westminster.'),
(55, 3, 8, '2027-07-20', 'Dora experienced bullying in North Vancouver.'),
(56, 4, 9, '2027-08-25', 'Evan reported workplace violence in Pitt Meadows.'),
(57, 2, 10, '2027-09-01', 'Fay reported an intimate partner violence incident in Port Moody.'),
(58, 1, 11, '2027-10-05', 'Glen experienced domestic violence in Port Coquitlam.'),
(59, 3, 12, '2027-11-10', 'Hope experienced bullying in Richmond.'),
(60, 4, 13, '2027-12-15', 'Ian reported workplace violence in Surrey.'),
(61, 2, 14, '2028-01-20', 'Jill reported an intimate partner violence incident in Vancouver.'),
(62, 1, 15, '2028-02-25', 'Kyle experienced domestic violence in West Vancouver.'),
(63, 3, 1, '2028-03-01', 'Lana experienced bullying in Bowen Island.'),
(64, 4, 2, '2028-04-05', 'Mark reported workplace violence in Burnaby.'),
(65, 2, 3, '2028-05-10', 'Nora reported an intimate partner violence incident in Coquitlam.'),
(66, 1, 4, '2028-06-15', 'Owen experienced domestic violence in Delta.'),
(67, 3, 5, '2028-07-20', 'Pam experienced bullying in Langley.'),
(68, 4, 6, '2028-08-25', 'Quinn reported workplace violence in Maple Ridge.'),
(69, 2, 7, '2028-09-01', 'Ruth reported an intimate partner violence incident in New Westminster.'),
(70, 1, 8, '2028-10-05', 'Steve experienced domestic violence in North Vancouver.'),
(71, 3, 9, '2028-11-10', 'Tara experienced bullying in Pitt Meadows.'),
(72, 4, 10, '2028-12-15', 'Uri reported workplace violence in Port Moody.'),
(73, 2, 11, '2029-01-20', 'Vicky reported an intimate partner violence incident in Port Coquitlam.'),
(74, 1, 12, '2029-02-25', 'Walt experienced domestic violence in Richmond.'),
(75, 3, 13, '2029-03-01', 'Xia experienced bullying in Surrey.'),
(76, 4, 14, '2029-04-05', 'Yvonne reported workplace violence in Vancouver.'),
(77, 2, 15, '2029-05-10', 'Zane reported an intimate partner violence incident in West Vancouver.'),
(78, 1, 1, '2029-06-15', 'Anna experienced domestic violence in Bowen Island.'),
(79, 3, 2, '2029-07-20', 'Blake experienced bullying in Burnaby.'),
(80, 4, 3, '2029-08-25', 'Cora reported workplace violence in Coquitlam.'),
(81, 2, 4, '2029-09-01', 'Dean reported an intimate partner violence incident in Delta.'),
(82, 1, 5, '2029-10-05', 'Ella experienced domestic violence in Langley.'),
(83, 3, 6, '2029-11-10', 'Finn experienced bullying in Maple Ridge.'),
(84, 4, 7, '2029-12-15', 'Gail reported workplace violence in New Westminster.'),
(85, 2, 8, '2030-01-20', 'Hank reported an intimate partner violence incident in North Vancouver.'),
(86, 1, 9, '2030-02-25', 'Ivy experienced domestic violence in Pitt Meadows.'),
(87, 3, 10, '2030-03-01', 'Jade experienced bullying in Port Moody.'),
(88, 4, 11, '2030-04-05', 'Kara reported workplace violence in Port Coquitlam.'),
(89, 2, 12, '2030-05-10', 'Mona reported an intimate partner violence incident in Richmond.'),
(90, 1, 13, '2030-06-15', 'Nina experienced domestic violence in Surrey.'),
(91, 3, 14, '2030-07-20', 'Oasis experienced bullying in Vancouver.'),
(92, 4, 15, '2030-08-25', 'Pia reported workplace violence in West Vancouver.'),
(93, 2, 1, '2030-09-01', 'Quinn reported an intimate partner violence incident in Bowen Island.'),
(94, 1, 2, '2030-10-05', 'Rita experienced domestic violence in Burnaby.'),
(95, 3, 3, '2030-11-10', 'Taylor experienced bullying in Coquitlam.'),
(96, 4, 4, '2030-12-15', 'Lia reported workplace violence in Delta.'),
(97, 2, 5, '2031-01-20', 'Felix reported an intimate partner violence incident in Langley.'),
(98, 1, 6, '2031-02-25', 'Loha experienced domestic violence in Maple Ridge.'),
(99, 3, 7, '2031-03-01', 'Belle experienced bullying in New Westminster.'),
(100, 4, 8, '2031-04-05', 'Tina reported workplace violence in North Vancouver.');


-- Insert Values for incident_need_list
INSERT INTO incident_need_list (incident_id, need_id, need_description) VALUES
(1, 1, 'Shelter needed for Alice after domestic violence.'),
(1, 2, 'Food supplies required for Alice.'),
(1, 3, 'Medical care required for Alice after domestic violence.'),
(2, 3, 'Medical care required for Bob.'),
(2, 5, 'Psychological support needed for Bob after intimate partner violence.'),
(2, 6, 'Financial assistance needed for Bob after intimate partner violence.'),
(3, 4, 'Legal assistance needed for Charlie after bullying.'),
(3, 7, 'Counseling required for Charlie after bullying.'),
(4, 7, 'Counseling required for Diana after workplace violence.'),
(4, 8, 'Housing support needed for Diana after workplace violence.'),
(4, 8, 'Housing support needed for Diana.'),
(5, 1, 'Shelter needed for Eve after intimate partner violence.'),
(5, 6, 'Financial assistance needed for Eve.'),
(5, 9, 'Employment support needed for Eve.'),
(6, 1, 'Shelter needed for Frank after domestic violence.'),
(6, 2, 'Food supplies required for Frank after domestic violence.'),
(6, 3, 'Medical care required for Frank after domestic violence.'),
(7, 2, 'Food supplies needed for Grace.'),
(7, 3, 'Medical care required for Grace after workplace violence.'),
(7, 7, 'Counseling required for Grace after workplace violence.'),
(8, 4, 'Legal assistance needed for Hank after bullying.'),
(8, 5, 'Psychological support needed for Hank after bullying.'),
(9, 4, 'Legal assistance needed for Ivy after intimate partner violence.'),
(9, 5, 'Psychological support needed for Ivy after intimate partner violence.'),
(9, 6, 'Financial assistance needed for Ivy.'),
(10, 3, 'Medical care required for Sally after bullying.'),
(10, 6, 'Financial assistance needed for Sally after bullying.'),
(11, 7, 'Counseling required for Kim after workplace violence.'),
(11, 7, 'Counseling required for Kim.'),
(11, 8, 'Housing support needed for Kim after workplace violence.'),
(12, 1, 'Shelter needed for Liam after domestic violence.'),
(12, 7, 'Counseling required for Liam after domestic violence.'),
(12, 8, 'Housing support needed for Liam after domestic violence.'),
(13, 1, 'Shelter needed for Mia after intimate partner violence.'),
(13, 5, 'Psychological support needed for Mia after intimate partner violence.'),
(13, 9, 'Employment support needed for Mia.'),
(14, 2, 'Food supplies required for Noah after bullying.'),
(14, 4, 'Legal assistance needed for Noah after bullying.'),
(15, 3, 'Medical care required for Olivia after workplace violence.'),
(15, 4, 'Legal assistance needed for Olivia after workplace violence.'),
(15, 7, 'Counseling required for Olivia after workplace violence.'),
(16, 2, 'Food supplies needed for Paul.'),
(16, 4, 'Legal assistance needed for Paul after intimate partner violence.'),
(16, 5, 'Psychological support needed for Paul after intimate partner violence.'),
(17, 4, 'Legal assistance needed for Quinn after bullying.'),
(17, 5, 'Psychological support needed for Quinn after bullying.'),
(17, 9, 'Employment support needed for Quinn.'),
(18, 6, 'Financial assistance needed for Rita after workplace violence.'),
(18, 7, 'Counseling required for Rita after workplace violence.'),
(18, 8, 'Housing support needed for Rita after workplace violence.'),
(19, 1, 'Shelter needed for Sam after domestic violence.'),
(19, 2, 'Food supplies needed for Sam.'),
(19, 7, 'Counseling required for Sam after domestic violence.'),
(20, 5, 'Psychological support needed for Tina after intimate partner violence.'),
(20, 8, 'Housing support needed for Tina after intimate partner violence.'),
(21, 1, 'Shelter needed for Uma after bullying.'),
(21, 4, 'Legal assistance needed for Uma after bullying.'),
(22, 2, 'Food supplies required for Victoria after domestic violence.'),
(22, 7, 'Counseling required for Victoria after domestic violence.'),
(22, 8, 'Housing support needed for Victoria.'),
(23, 3, 'Medical care required for Wendy after intimate partner violence.'),
(23, 5, 'Psychological support needed for Wendy after intimate partner violence.'),
(23, 6, 'Financial assistance needed for Wendy after intimate partner violence.'),
(23, 6, 'Financial assistance needed for Wendy.'),
(24, 3, 'Medical care required for Xander after bullying.'),
(24, 4, 'Legal assistance needed for Xander after bullying.'),
(25, 5, 'Psychological support needed for Yara after workplace violence.'),
(25, 7, 'Counseling required for Yara.'),
(25, 8, 'Housing support needed for Yara after workplace violence.'),
(26, 4, 'Legal assistance needed for Zack after intimate partner violence.'),
(26, 6, 'Financial assistance needed for Zack after intimate partner violence.'),
(26, 9, 'Employment support needed for Zack.'),
(27, 1, 'Shelter needed for Amy after domestic violence.'),
(27, 2, 'Food supplies needed for Amy.'),
(27, 5, 'Psychological support needed for Amy after domestic violence.'),
(27, 7, 'Counseling required for Amy after domestic violence.'),
(28, 5, 'Psychological support needed for Tracy after bullying.'),
(28, 8, 'Housing support needed for Tracy after bullying.'),
(29, 1, 'Shelter needed for Clara after intimate partner violence.'),
(29, 4, 'Legal assistance needed for Clara after intimate partner violence.'),
(29, 4, 'Legal assistance needed for Clara after intimate partner violence.'),
(29, 6, 'Financial assistance needed for Clara.'),
(30, 2, 'Food supplies required for Dave after workplace violence.'),
(30, 7, 'Counseling required for Dave after workplace violence.'),
(30, 8, 'Housing support needed for Dave.'),
(31, 1, 'Shelter needed for Ella after domestic violence.'),
(31, 3, 'Medical care required for Ella after domestic violence.'),
(32, 2, 'Food supplies needed for Felix after bullying.'),
(32, 3, 'Medical care required for Felix after bullying.'),
(32, 4, 'Legal assistance needed for Felix after bullying.'),
(33, 1, 'Shelter needed for Gina after intimate partner violence.'),
(33, 4, 'Legal assistance needed for Gina after intimate partner violence.'),
(33, 5, 'Psychological support needed for Gina after intimate partner violence.'),
(33, 5, 'Psychological support needed for Gina.'),
(34, 1, 'Shelter needed for Harry after domestic violence.'),
(34, 2, 'Food supplies needed for Harry.'),
(34, 6, 'Financial assistance needed for Harry after domestic violence.'),
(35, 7, 'Counseling required for Isla after workplace violence.'),
(35, 7, 'Counseling required for Isla after workplace violence.'),
(36, 5, 'Psychological support needed for Bethany after intimate partner violence.'),
(36, 8, 'Housing support needed for Bethany after intimate partner violence.'),
(37, 1, 'Shelter needed for Kara after bullying.'),
(37, 3, 'Medical care required for Kara after bullying.'),
(37, 6, 'Financial assistance needed for Kara.'),
(38, 2, 'Food supplies required for Lee after workplace violence.'),
(38, 8, 'Housing support needed for Lee after workplace violence.'),
(38, 8, 'Housing support needed for Lee after workplace violence.'),
(39, 1, 'Shelter needed for Mona after domestic violence.'),
(39, 3, 'Medical care required for Mona after domestic violence.'),
(40, 4, 'Legal assistance needed for Nina after bullying.'),
(40, 4, 'Legal assistance needed for Nina after bullying.'),
(40, 9, 'Employment support needed for Nina.'),
(41, 3, 'Medical care required for Omar after intimate partner violence.'),
(41, 5, 'Psychological support needed for Omar after intimate partner violence.'),
(41, 5, 'Psychological support needed for Omar after intimate partner violence.'),
(42, 1, 'Shelter needed for Pia after domestic violence.'),
(42, 6, 'Financial assistance needed for Pia after domestic violence.'),
(43, 7, 'Counseling required for Rick after workplace violence.'),
(43, 7, 'Counseling required for Rick after workplace violence.'),
(44, 3, 'Medical care required for Sara after bullying.'),
(44, 8, 'Housing support needed for Sara after bullying.'),
(45, 1, 'Shelter needed for Tom after domestic violence.'),
(45, 1, 'Shelter needed for Tom after intimate partner violence.'),
(45, 6, 'Financial assistance needed for Tom after domestic violence.'),
(46, 2, 'Food supplies required for Ula after workplace violence.'),
(46, 8, 'Housing support needed for Ula after workplace violence.'),
(47, 3, 'Medical care required for Vera after domestic violence.'),
(47, 5, 'Psychological support needed for Vera after intimate partner violence.'),
(48, 2, 'Food supplies needed for Will after bullying.'),
(48, 3, 'Medical care required for Will after bullying.'),
(48, 4, 'Legal assistance needed for Will after bullying.'),
(48, 7, 'Counseling required for Will.'),
(49, 5, 'Psychological support needed for Xena after workplace violence.'),
(49, 8, 'Housing support needed for Xena after workplace violence.'),
(50, 4, 'Legal assistance needed for Yuri after intimate partner violence.'),
(50, 6, 'Financial assistance needed for Yuri after intimate partner violence.'),
(51, 1, 'Shelter needed for Zara after domestic violence.'),
(52, 5, 'Psychological support needed for Alan after bullying.'),
(52, 6, 'Financial assistance needed for Alan after bullying.'),
(52, 6, 'Financial assistance needed for Alan.'),
(53, 7, 'Counseling required for Beth after intimate partner violence.'),
(54, 1, 'Shelter needed for Carl after domestic violence.'),
(55, 3, 'Medical care required for Dora after bullying.'),
(56, 5, 'Psychological support needed for Evan after workplace violence.'),
(56, 8, 'Housing support needed for Evan after workplace violence.'),
(57, 5, 'Psychological support needed for Fay after intimate partner violence.'),
(58, 1, 'Shelter needed for Glen after domestic violence.'),
(59, 1, 'Shelter needed for Hope after bullying.'),
(59, 7, 'Counseling required for Hope after bullying.'),
(60, 8, 'Housing support needed for Ian after workplace violence.'),
(61, 5, 'Psychological support needed for Jill after intimate partner violence.'),
(62, 1, 'Shelter needed for Kyle after domestic violence.'),
(63, 3, 'Medical care required for Lana after bullying.'),
(64, 8, 'Housing support needed for Mark after workplace violence.'),
(65, 4, 'Legal assistance needed for Nora after intimate partner violence.'),
(66, 1, 'Shelter needed for Owen after domestic violence.'),
(66, 5, 'Psychological support needed for Owen after domestic violence.'),
(67, 3, 'Medical care required for Pam after bullying.'),
(67, 5, 'Psychological support needed for Pam after bullying.'),
(68, 8, 'Housing support needed for Quinn after workplace violence.'),
(69, 4, 'Legal assistance needed for Ruth after intimate partner violence.'),
(70, 1, 'Shelter needed for Steve after domestic violence.'),
(71, 3, 'Medical care required for Tara after bullying.'),
(72, 8, 'Housing support needed for Uri after workplace violence.'),
(73, 5, 'Psychological support needed for Vicky after intimate partner violence.'),
(74, 1, 'Shelter needed for Walt after domestic violence.'),
(74, 2, 'Food supplies needed for Walt after domestic violence.'),
(75, 7, 'Counseling required for Xia after bullying.'),
(76, 8, 'Housing support needed for Yvonne after workplace violence.'),
(77, 4, 'Legal assistance needed for Zane after intimate partner violence.'),
(77, 7, 'Counseling required for Zane after intimate partner violence.'),
(78, 1, 'Shelter needed for Anna after domestic violence.'),
(78, 4, 'Legal assistance needed for Anna after domestic violence.'),
(79, 3, 'Medical care required for Blake after bullying.'),
(80, 8, 'Housing support needed for Cora after workplace violence.'),
(81, 4, 'Legal assistance needed for Dean after intimate partner violence.'),
(81, 5, 'Psychological support needed for Dean after intimate partner violence.'),
(82, 1, 'Shelter needed for Ella after domestic violence.'),
(83, 3, 'Medical care required for Finn after bullying.'),
(84, 8, 'Housing support needed for Gail after workplace violence.'),
(85, 5, 'Psychological support needed for Hank after intimate partner violence.'),
(86, 1, 'Shelter needed for Ivy after domestic violence.'),
(87, 7, 'Counseling required for Jade after bullying.'),
(88, 3, 'Medical care required for Kara after workplace violence.'),
(88, 8, 'Housing support needed for Kara after workplace violence.'),
(89, 4, 'Legal assistance needed for Mona after intimate partner violence.'),
(90, 1, 'Shelter needed for Nina after domestic violence.'),
(90, 5, 'Psychological support needed for Nina after domestic violence.'),
(91, 3, 'Medical care required for Oasis after bullying.'),
(92, 8, 'Housing support needed for Pia after workplace violence.'),
(92, 8, 'Housing support needed for Pia after workplace violence.'),
(93, 5, 'Psychological support needed for Quinn after intimate partner violence.'),
(94, 1, 'Shelter needed for Rita after domestic violence.'),
(95, 7, 'Counseling required for Taylor after bullying.'),
(96, 8, 'Housing support needed for Lia after workplace violence.'),
(97, 4, 'Legal assistance needed for Felix after intimate partner violence.'),
(98, 1, 'Shelter needed for Loha after domestic violence.'),
(99, 7, 'Counseling required for Belle after bullying.'),
(99, 7, 'Counseling required for Belle after bullying.'),
(100, 8, 'Housing support needed for Tina after workplace violence.')

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

    
