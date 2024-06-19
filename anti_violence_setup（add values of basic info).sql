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
(100, 8, 'Housing support needed for Tina after workplace violence.');

-- Insert Values for volunteer
INSERT INTO volunteer (volunteer_name, gender_id, specialty_id, age, email, phone, availability) VALUES
('John Doe', 1, 1, 45, 'john.doe@example.com', '555-1234', 1),
('Jane Smith', 2, 2, 38, 'jane.smith@example.com', '555-5678', 1),
('Alex Johnson', 3, 3, 50, 'alex.johnson@example.com', '555-9101', 1),
('Maria Garcia', 2, 4, 29, 'maria.garcia@example.com', '555-1122', 0),
('Michael Brown', 1, 5, 35, 'michael.brown@example.com', '555-3344', 1),
('Emily Davis', 2, 6, 42, 'emily.davis@example.com', '555-5566', 1),
('Olivia Taylor', 1, 1, 30, 'olivia.taylor@example.com', '555-7788', 1),
('Daniel Harris', 3, 2, 48, 'daniel.harris@example.com', '555-8899', 1),
('Sophia Martinez', 2, 3, 27, 'sophia.martinez@example.com', '555-9900', 0),
('Lucas White', 1, 4, 37, 'lucas.white@example.com', '555-1010', 1),
('Mia Lee', 2, 5, 33, 'mia.lee@example.com', '555-1111', 1),
('Ethan Clark', 1, 6, 41, 'ethan.clark@example.com', '555-1212', 1),
('Isabella Wright', 2, 1, 26, 'isabella.wright@example.com', '555-1313', 1),
('Jack Hall', 1, 2, 39, 'jack.hall@example.com', '555-1414', 1),
('Ava Young', 2, 3, 28, 'ava.young@example.com', '555-1515', 1),
('Liam King', 1, 4, 44, 'liam.king@example.com', '555-1616', 1),
('Ella Scott', 2, 5, 32, 'ella.scott@example.com', '555-1717', 1),
('James Adams', 1, 6, 36, 'james.adams@example.com', '555-1818', 1),
('Charlotte Baker', 2, 1, 31, 'charlotte.baker@example.com', '555-1919', 1),
('Henry Green', 1, 2, 47, 'henry.green@example.com', '555-2020', 1),
('Grace Hill', 2, 3, 29, 'grace.hill@example.com', '555-2121', 1),
('Mason Walker', 1, 4, 38, 'mason.walker@example.com', '555-2222', 1),
('Sophia Nelson', 2, 5, 34, 'sophia.nelson@example.com', '555-2323', 1),
('Benjamin Carter', 1, 6, 46, 'benjamin.carter@example.com', '555-2424', 1),
('Chloe Mitchell', 2, 1, 25, 'chloe.mitchell@example.com', '555-2525', 1),
('David Perez', 1, 2, 49, 'david.perez@example.com', '555-2626', 1),
('Mia Roberts', 2, 3, 30, 'mia.roberts@example.com', '555-2727', 1),
('Daniel Turner', 1, 4, 43, 'daniel.turner@example.com', '555-2828', 1),
('Ava Phillips', 2, 5, 27, 'ava.phillips@example.com', '555-2929', 1),
('Noah Campbell', 1, 6, 40, 'noah.campbell@example.com', '555-3030', 1),
('Lily Edwards', 2, 1, 33, 'lily.edwards@example.com', '555-3131', 1),
('Logan Collins', 1, 2, 37, 'logan.collins@example.com', '555-3232', 1),
('Zoe Stewart', 2, 3, 28, 'zoe.stewart@example.com', '555-3333', 1),
('Michael Sanchez', 1, 4, 45, 'michael.sanchez@example.com', '555-3434', 1),
('Emily Morris', 2, 5, 35, 'emily.morris@example.com', '555-3535', 1),
('William Hughes', 1, 6, 42, 'william.hughes@example.com', '555-3636', 1),
('Olivia Price', 2, 1, 31, 'olivia.price@example.com', '555-3737', 1),
('Jayden Ross', 1, 2, 39, 'jayden.ross@example.com', '555-3838', 1),
('Harper Jenkins', 2, 3, 26, 'harper.jenkins@example.com', '555-3939', 1),
('Elijah Kelly', 1, 4, 36, 'elijah.kelly@example.com', '555-4040', 1),
('Amelia Long', 2, 5, 44, 'amelia.long@example.com', '555-4141', 1),
('Oliver Bailey', 1, 6, 47, 'oliver.bailey@example.com', '555-4242', 1),
('Sofia Patterson', 2, 1, 32, 'sofia.patterson@example.com', '555-4343', 1),
('Lucas Richardson', 1, 2, 41, 'lucas.richardson@example.com', '555-4444', 1),
('Mia Cox', 2, 3, 29, 'mia.cox@example.com', '555-4545', 1),
('Aiden Ramirez', 1, 4, 35, 'aiden.ramirez@example.com', '555-4646', 1),
('Emma Wood', 2, 5, 33, 'emma.wood@example.com', '555-4747', 1),
('Jacob Brooks', 1, 1, 46, 'jacob.brooks@example.com', '555-4848', 1),
('Hannah Bryant', 2, 2, 38, 'hannah.bryant@example.com', '555-4949', 1),
('Matthew Rivera', 1, 3, 41, 'matthew.rivera@example.com', '555-5050', 1),
('Abigail Evans', 2, 4, 30, 'abigail.evans@example.com', '555-5151', 1);

-- Insert Values for volunteer_has_resource_list
INSERT INTO volunteer_has_resource_list (volunteer_id, need_id, resource_description) VALUES
(1, 1, 'Temporary shelter arrangements available.'),
(1, 2, 'Can provide food supplies.'),
(1, 3, 'Medical care expertise.'),
(1, 4, 'Legal assistance available.'),
(2, 5, 'Psychological support services.'),
(2, 6, 'Financial assistance guidance.'),
(2, 7, 'Experienced in counseling services.'),
(3, 8, 'Housing arrangements available.'),
(3, 9, 'Employment assistance available.'),
(4, 1, 'Temporary shelter arrangements available.'),
(4, 3, 'Medical care expertise.'),
(5, 3, 'Counseling services available.'),
(5, 4, 'Legal assistance available.'),
(6, 6, 'Translation services expertise.'),
(7, 7, 'Employment assistance available.'),
(8, 8, 'Housing arrangements available.'),
(8, 2, 'Can provide food supplies.'),
(9, 3, 'Counseling services available.'),
(9, 4, 'Legal assistance available.'),
(10, 1, 'Temporary shelter arrangements available.'),
(10, 5, 'Medical care expertise.'),
(11, 6, 'Translation services expertise.'),
(11, 7, 'Employment assistance available.'),
(12, 8, 'Housing arrangements available.'),
(12, 2, 'Can provide food supplies.'),
(13, 3, 'Counseling services available.'),
(13, 4, 'Legal assistance available.'),
(14, 1, 'Temporary shelter arrangements available.'),
(14, 5, 'Medical care expertise.'),
(15, 6, 'Translation services expertise.'),
(15, 7, 'Employment assistance available.'),
(16, 8, 'Housing arrangements available.'),
(16, 2, 'Can provide food supplies.'),
(17, 3, 'Counseling services available.'),
(17, 4, 'Legal assistance available.'),
(18, 1, 'Temporary shelter arrangements available.'),
(18, 5, 'Medical care expertise.'),
(19, 6, 'Translation services expertise.'),
(19, 7, 'Employment assistance available.'),
(20, 8, 'Housing arrangements available.'),
(20, 2, 'Can provide food supplies.'),
(21, 3, 'Counseling services available.'),
(21, 4, 'Legal assistance available.'),
(22, 1, 'Temporary shelter arrangements available.'),
(22, 5, 'Medical care expertise.'),
(23, 6, 'Translation services expertise.'),
(23, 7, 'Employment assistance available.'),
(24, 8, 'Housing arrangements available.'),
(24, 2, 'Can provide food supplies.'),
(25, 3, 'Counseling services available.'),
(25, 4, 'Legal assistance available.'),
(26, 1, 'Temporary shelter arrangements available.'),
(26, 5, 'Medical care expertise.'),
(27, 6, 'Translation services expertise.'),
(27, 7, 'Employment assistance available.'),
(28, 8, 'Housing arrangements available.'),
(28, 2, 'Can provide food supplies.'),
(29, 3, 'Counseling services available.'),
(29, 4, 'Legal assistance available.'),
(30, 1, 'Temporary shelter arrangements available.'),
(30, 5, 'Medical care expertise.'),
(31, 6, 'Translation services expertise.'),
(31, 7, 'Employment assistance available.'),
(32, 8, 'Housing arrangements available.'),
(32, 2, 'Can provide food supplies.'),
(33, 3, 'Counseling services available.'),
(33, 4, 'Legal assistance available.'),
(34, 1, 'Temporary shelter arrangements available.'),
(34, 5, 'Medical care expertise.'),
(35, 6, 'Translation services expertise.'),
(35, 7, 'Employment assistance available.'),
(36, 8, 'Housing arrangements available.'),
(36, 2, 'Can provide food supplies.'),
(37, 3, 'Counseling services available.'),
(37, 4, 'Legal assistance available.'),
(38, 1, 'Temporary shelter arrangements available.'),
(38, 5, 'Medical care expertise.'),
(39, 6, 'Translation services expertise.'),
(39, 7, 'Employment assistance available.'),
(40, 8, 'Housing arrangements available.'),
(40, 2, 'Can provide food supplies.'),
(41, 3, 'Counseling services available.'),
(41, 4, 'Legal assistance available.'),
(42, 1, 'Temporary shelter arrangements available.'),
(42, 5, 'Medical care expertise.'),
(43, 6, 'Translation services expertise.'),
(43, 7, 'Employment assistance available.'),
(44, 8, 'Housing arrangements available.'),
(44, 2, 'Can provide food supplies.'),
(45, 3, 'Counseling services available.'),
(45, 4, 'Legal assistance available.'),
(46, 1, 'Temporary shelter arrangements available.'),
(46, 5, 'Medical care expertise.'),
(47, 6, 'Translation services expertise.'),
(47, 7, 'Employment assistance available.'),
(48, 8, 'Housing arrangements available.'),
(48, 2, 'Can provide food supplies.'),
(49, 3, 'Counseling services available.'),
(49, 4, 'Legal assistance available.'),
(50, 1, 'Temporary shelter arrangements available.'),
(50, 5, 'Medical care expertise.');


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
(2, 2, '2024-02-02', '2024-02-10', 'Provided food supplies for Alice.', 3),
(3, 3, '2024-03-06', '2024-03-12', 'Offered medical care for Alice.', 2),
(4, 4, '2024-04-11', '2024-04-15', 'Arranged medical care for Bob.', 1),
(5, 5, '2024-05-13', '2024-05-20', 'Psychological support for Bob.', 3),
(6, 6, '2024-06-16', '2024-06-20', 'Provided financial assistance for Bob.', 2),
(7, 7, '2024-07-21', '2024-07-25', 'Legal assistance for Charlie.', 2),
(8, 8, '2024-08-26', '2024-08-30', 'Counseling for Charlie.', 2),
(9, 9, '2024-09-01', '2024-09-05', 'Counseling for Diana.', 3),
(10, 10, '2024-10-05', '2024-10-10', 'Housing support for Diana.', 2),
(11, 11, '2024-11-10', '2024-11-15', 'Housing support for Diana.', 3),
(12, 12, '2024-12-15', '2024-12-20', 'Provided temporary shelter for Eve.', 3),
(13, 13, '2025-01-02', '2025-01-10', 'Provided financial assistance for Eve.', 3),
(14, 14, '2025-02-02', '2025-02-10', 'Employment support for Eve.', 2),
(15, 15, '2025-03-06', '2025-03-12', 'Provided temporary shelter for Frank.', 3),
(16, 16, '2025-04-11', '2025-04-15', 'Provided food supplies for Frank.', 2),
(17, 17, '2025-05-13', '2025-05-20', 'Medical care for Frank.', 1),
(18, 18, '2025-06-16', '2025-06-20', 'Food supplies for Grace.', 2),
(19, 19, '2025-07-21', '2025-07-25', 'Medical care for Grace.', 1),
(20, 20, '2025-08-26', '2025-08-30', 'Counseling for Grace.', 3),
(21, 21, '2025-09-01', '2025-09-05', 'Legal assistance for Hank.', 3),
(22, 22, '2025-10-05', '2025-10-10', 'Psychological support for Hank.', 3),
(23, 23, '2025-11-10', '2025-11-15', 'Legal assistance for Ivy.', 2),
(24, 24, '2025-12-15', '2025-12-20', 'Psychological support for Ivy.', 3),
(25, 25, '2026-01-02', '2026-01-10', 'Financial assistance for Ivy.', 3),
(26, 26, '2026-02-02', '2026-02-10', 'Medical care for Sally.', 2),
(27, 27, '2026-03-06', '2026-03-12', 'Financial assistance for Sally.', 2),
(28, 28, '2026-04-11', '2026-04-15', 'Counseling for Kim.', 1),
(29, 29, '2026-05-13', '2026-05-20', 'Counseling for Kim.', 1),
(30, 30, '2026-06-16', '2026-06-20', 'Housing support for Kim.', 3),
(31, 31, '2026-07-21', '2026-07-25', 'Temporary shelter for Liam.', 2),
(32, 32, '2026-08-26', '2026-08-30', 'Counseling for Liam.', 2),
(33, 33, '2026-09-01', '2026-09-05', 'Housing support for Liam.', 3),
(34, 34, '2026-10-05', '2026-10-10', 'Temporary shelter for Mia.', 3),
(35, 35, '2026-11-10', '2026-11-15', 'Psychological support for Mia.', 3),
(36, 36, '2026-12-15', '2026-12-20', 'Employment support for Mia.', 2),
(37, 37, '2027-01-02', '2027-01-10', 'Food supplies for Noah.', 3),
(38, 38, '2027-02-02', '2027-02-10', 'Legal assistance for Noah.', 2),
(39, 39, '2027-03-06', '2027-03-12', 'Medical care for Olivia.', 1),
(40, 40, '2027-04-11', '2027-04-15', 'Legal assistance for Olivia.', 3),
(41, 41, '2027-05-13', '2027-05-20', 'Counseling for Olivia.', 3),
(42, 42, '2027-06-16', '2027-06-20', 'Food supplies for Paul.', 2),
(43, 43, '2027-07-21', '2027-07-25', 'Legal assistance for Paul.', 1),
(44, 44, '2027-08-26', '2027-08-30', 'Psychological support for Paul.', 3),
(45, 45, '2027-09-01', '2027-09-05', 'Legal assistance for Quinn.', 3),
(46, 46, '2027-10-05', '2027-10-10', 'Psychological support for Quinn.', 2),
(47, 47, '2027-11-10', '2027-11-15', 'Employment support for Quinn.', 3),
(48, 48, '2027-12-15', '2027-12-20', 'Financial assistance for Rita.', 3),
(49, 49, '2028-01-02', '2028-01-10', 'Counseling for Rita.', 3),
(50, 50, '2028-02-02', '2028-02-10', 'Housing support for Rita.', 2),
(51, 51, '2028-03-06', '2028-03-12', 'Temporary shelter for Sam.', 3),
(52, 52, '2028-04-11', '2028-04-15', 'Food supplies for Sam.', 2),
(53, 53, '2028-05-13', '2028-05-20', 'Counseling for Sam.', 1),
(54, 54, '2028-06-16', '2028-06-20', 'Psychological support for Tina.', 2),
(55, 55, '2028-07-21', '2028-07-25', 'Housing support for Tina.', 3),
(56, 56, '2028-08-26', '2028-08-30', 'Temporary shelter for Uma.', 3),
(57, 57, '2028-09-01', '2028-09-05', 'Legal assistance for Uma.', 3),
(58, 58, '2028-10-05', '2028-10-10', 'Food supplies for Victoria.', 2),
(59, 59, '2028-11-10', '2028-11-15', 'Counseling for Victoria.', 3),
(60, 60, '2028-12-15', '2028-12-20', 'Housing support for Victoria.', 3),
(61, 61, '2029-01-02', '2029-01-10', 'Medical care for Wendy.', 2),
(62, 62, '2029-02-02', '2029-02-10', 'Psychological support for Wendy.', 3),
(63, 63, '2029-03-06', '2029-03-12', 'Financial assistance for Wendy.', 2),
(64, 64, '2029-04-11', '2029-04-15', 'Financial assistance for Wendy.', 1),
(65, 65, '2029-05-13', '2029-05-20', 'Medical care for Xander.', 2),
(66, 66, '2029-06-16', '2029-06-20', 'Legal assistance for Xander.', 3),
(67, 67, '2029-07-21', '2029-07-25', 'Psychological support for Yara.', 2),
(68, 68, '2029-08-26', '2029-08-30', 'Counseling for Yara.', 3),
(69, 69, '2029-09-01', '2029-09-05', 'Housing support for Yara.', 3),
(70, 70, '2029-10-05', '2029-10-10', 'Legal assistance for Zack.', 3),
(71, 71, '2029-11-10', '2029-11-15', 'Financial assistance for Zack.', 2),
(72, 72, '2029-12-15', '2029-12-20', 'Employment support for Zack.', 3),
(73, 73, '2030-01-02', '2030-01-10', 'Temporary shelter for Amy.', 3),
(74, 74, '2030-02-02', '2030-02-10', 'Food supplies for Amy.', 2),
(75, 75, '2030-03-06', '2030-03-12', 'Psychological support for Amy.', 3),
(76, 76, '2030-04-11', '2030-04-15', 'Counseling for Amy.', 3),
(77, 77, '2030-05-13', '2030-05-20', 'Psychological support for Tracy.', 2),
(78, 78, '2030-06-16', '2030-06-20', 'Housing support for Tracy.', 2),
(79, 79, '2030-07-21', '2030-07-25', 'Temporary shelter for Clara.', 3),
(80, 80, '2030-08-26', '2030-08-30', 'Legal assistance for Clara.', 3),
(81, 81, '2030-09-01', '2030-09-05', 'Legal assistance for Clara.', 2),
(82, 82, '2030-10-05', '2030-10-10', 'Financial assistance for Clara.', 3),
(83, 83, '2030-11-10', '2030-11-15', 'Food supplies for Dave.', 2),
(84, 84, '2030-12-15', '2030-12-20', 'Counseling for Dave.', 3),
(85, 85, '2031-01-02', '2031-01-10', 'Housing support for Dave.', 3),
(86, 86, '2031-02-02', '2031-02-10', 'Temporary shelter for Ella.', 3),
(87, 87, '2031-03-06', '2031-03-12', 'Medical care for Ella.', 2),
(88, 88, '2031-04-11', '2031-04-15', 'Food supplies for Felix.', 3),
(89, 89, '2031-05-13', '2031-05-20', 'Medical care for Felix.', 1),
(90, 90, '2031-06-16', '2031-06-20', 'Legal assistance for Felix.', 3),
(91, 91, '2031-07-21', '2031-07-25', 'Temporary shelter for Gina.', 3),
(92, 92, '2031-08-26', '2031-08-30', 'Legal assistance for Gina.', 3),
(93, 93, '2031-09-01', '2031-09-05', 'Psychological support for Gina.', 2),
(94, 94, '2031-10-05', '2031-10-10', 'Psychological support for Gina.', 3),
(95, 95, '2031-11-10', '2031-11-15', 'Temporary shelter for Harry.', 3),
(96, 96, '2031-12-15', '2031-12-20', 'Food supplies for Harry.', 2),
(97, 97, '2032-01-02', '2032-01-10', 'Financial assistance for Harry.', 1),
(98, 98, '2032-02-02', '2032-02-10', 'Counseling for Isla.', 3),
(99, 99, '2032-03-06', '2032-03-12', 'Counseling for Isla.', 3),
(100, 100, '2032-04-11', '2032-04-15', 'Psychological support for Bethany.', 2),
(101, 101, '2032-05-13', '2032-05-20', 'Housing support for Bethany.', 3),
(102, 102, '2032-06-16', '2032-06-20', 'Temporary shelter for Kara.', 3),
(103, 103, '2032-07-21', '2032-07-25', 'Medical care for Kara.', 1),
(104, 104, '2032-08-26', '2032-08-30', 'Financial assistance for Kara.', 3),
(105, 105, '2032-09-01', '2032-09-05', 'Food supplies for Lee.', 2),
(106, 106, '2032-10-05', '2032-10-10', 'Housing support for Lee.', 3),
(107, 107, '2032-11-10', '2032-11-15', 'Housing support for Lee.', 2),
(108, 108, '2032-12-15', '2032-12-20', 'Temporary shelter for Mona.', 3),
(109, 109, '2033-01-02', '2033-01-10', 'Medical care for Mona.', 2),
(110, 110, '2033-02-02', '2033-02-10', 'Legal assistance for Nina.', 3),
(111, 111, '2033-03-06', '2033-03-12', 'Legal assistance for Nina.', 2),
(112, 112, '2033-04-11', '2033-04-15', 'Employment support for Nina.', 3),
(113, 113, '2033-05-13', '2033-05-20', 'Medical care for Omar.', 3),
(114, 114, '2033-06-16', '2033-06-20', 'Psychological support for Omar.', 2),
(115, 115, '2033-07-21', '2033-07-25', 'Psychological support for Omar.', 3),
(116, 116, '2033-08-26', '2033-08-30', 'Temporary shelter for Pia.', 3),
(117, 117, '2033-09-01', '2033-09-05', 'Financial assistance for Pia.', 2),
(118, 118, '2033-10-05', '2033-10-10', 'Counseling for Rick.', 3),
(119, 119, '2033-11-10', '2033-11-15', 'Counseling for Rick.', 2),
(120, 120, '2033-12-15', '2033-12-20', 'Medical care for Sara.', 1),
(121, 121, '2034-01-02', '2034-01-10', 'Housing support for Sara.', 3),
(122, 122, '2034-02-02', '2034-02-10', 'Temporary shelter for Tom.', 3),
(123, 123, '2034-03-06', '2034-03-12', 'Temporary shelter for Tom.', 3),
(124, 124, '2034-04-11', '2034-04-15', 'Financial assistance for Tom.', 2),
(125, 125, '2034-05-13', '2034-05-20', 'Food supplies for Ula.', 1),
(126, 126, '2034-06-16', '2034-06-20', 'Housing support for Ula.', 3),
(127, 127, '2034-07-21', '2034-07-25', 'Medical care for Vera.', 3),
(128, 128, '2034-08-26', '2034-08-30', 'Psychological support for Vera.', 2),
(129, 129, '2034-09-01', '2034-09-05', 'Food supplies for Will.', 2),
(130, 130, '2034-10-05', '2034-10-10', 'Medical care for Will.', 3),
(131, 131, '2034-11-10', '2034-11-15', 'Legal assistance for Will.', 1),
(132, 132, '2034-12-15', '2034-12-20', 'Counseling for Will.', 3),
(133, 133, '2035-01-02', '2035-01-10', 'Psychological support for Xena.', 3),
(134, 134, '2035-02-02', '2035-02-10', 'Housing support for Xena.', 2),
(135, 135, '2035-03-06', '2035-03-12', 'Legal assistance for Yuri.', 3),
(136, 136, '2035-04-11', '2035-04-15', 'Financial assistance for Yuri.', 2),
(137, 137, '2035-05-13', '2035-05-20', 'Temporary shelter for Zara.', 3),
(138, 138, '2035-06-16', '2035-06-20', 'Psychological support for Alan.', 3),
(139, 139, '2035-07-21', '2035-07-25', 'Financial assistance for Alan.', 2),
(140, 140, '2035-08-26', '2035-08-30', 'Financial assistance for Alan.', 3),
(141, 141, '2035-09-01', '2035-09-05', 'Counseling for Beth.', 3),
(142, 142, '2035-10-05', '2035-10-10', 'Temporary shelter for Carl.', 2),
(143, 143, '2035-11-10', '2035-11-15', 'Medical care for Dora.', 1),
(144, 144, '2035-12-15', '2035-12-20', 'Psychological support for Evan.', 3),
(145, 145, '2036-01-02', '2036-01-10', 'Housing support for Evan.', 3),
(146, 146, '2036-02-02', '2036-02-10', 'Psychological support for Fay.', 2),
(147, 147, '2036-03-06', '2036-03-12', 'Temporary shelter for Glen.', 3),
(148, 148, '2036-04-11', '2036-04-15', 'Temporary shelter for Hope.', 2),
(149, 149, '2036-05-13', '2036-05-20', 'Counseling for Hope.', 1),
(150, 150, '2036-06-16', '2036-06-20', 'Housing support for Ian.', 3),
(151, 151, '2036-07-21', '2036-07-25', 'Psychological support for Jill.', 3),
(152, 152, '2036-08-26', '2036-08-30', 'Temporary shelter for Kyle.', 2),
(153, 153, '2036-09-01', '2036-09-05', 'Medical care for Lana.', 1),
(154, 154, '2036-10-05', '2036-10-10', 'Housing support for Mark.', 3),
(155, 155, '2036-11-10', '2036-11-15', 'Legal assistance for Nora.', 2),
(156, 156, '2036-12-15', '2036-12-20', 'Temporary shelter for Owen.', 3),
(157, 157, '2037-01-02', '2037-01-10', 'Psychological support for Owen.', 2),
(158, 158, '2037-02-02', '2037-02-10', 'Medical care for Pam.', 3),
(159, 159, '2037-03-06', '2037-03-12', 'Psychological support for Pam.', 3),
(160, 160, '2037-04-11', '2037-04-15', 'Housing support for Quinn.', 2),
(161, 161, '2037-05-13', '2037-05-20', 'Legal assistance for Ruth.', 3),
(162, 162, '2037-06-16', '2037-06-20', 'Temporary shelter for Steve.', 3),
(163, 163, '2037-07-21', '2037-07-25', 'Medical care for Tara.', 2),
(164, 164, '2037-08-26', '2037-08-30', 'Housing support for Uri.', 3),
(165, 165, '2037-09-01', '2037-09-05', 'Psychological support for Vicky.', 3),
(166, 166, '2037-10-05', '2037-10-10', 'Temporary shelter for Walt.', 2),
(167, 167, '2037-11-10', '2037-11-15', 'Food supplies for Walt.', 3),
(168, 168, '2037-12-15', '2037-12-20', 'Counseling for Xia.', 3),
(169, 169, '2038-01-02', '2038-01-10', 'Housing support for Yvonne.', 2),
(170, 170, '2038-02-02', '2038-02-10', 'Legal assistance for Zane.', 3),
(171, 171, '2038-03-06', '2038-03-12', 'Counseling for Zane.', 3),
(172, 172, '2038-04-11', '2038-04-15', 'Temporary shelter for Anna.', 2),
(173, 173, '2038-05-13', '2038-05-20', 'Legal assistance for Anna.', 1),
(174, 174, '2038-06-16', '2038-06-20', 'Medical care for Blake.', 3),
(175, 175, '2038-07-21', '2038-07-25', 'Housing support for Cora.', 3),
(176, 176, '2038-08-26', '2038-08-30', 'Legal assistance for Dean.', 2),
(177, 177, '2038-09-01', '2038-09-05', 'Psychological support for Dean.', 3),
(178, 178, '2038-10-05', '2038-10-10', 'Temporary shelter for Ella.', 3),
(179, 179, '2038-11-10', '2038-11-15', 'Medical care for Finn.', 3),
(180, 180, '2038-12-15', '2038-12-20', 'Housing support for Gail.', 2),
(181, 181, '2039-01-02', '2039-01-10', 'Psychological support for Hank.', 1),
(182, 182, '2039-02-02', '2039-02-10', 'Temporary shelter for Ivy.', 3),
(183, 183, '2039-03-06', '2039-03-12', 'Counseling for Jade.', 3),
(184, 184, '2039-04-11', '2039-04-15', 'Medical care for Kara.', 2),
(185, 185, '2039-05-13', '2039-05-20', 'Housing support for Kara.', 3),
(186, 186, '2039-06-16', '2039-06-20', 'Legal assistance for Mona.', 3),
(187, 187, '2039-07-21', '2039-07-25', 'Temporary shelter for Nina.', 2),
(188, 188, '2039-08-26', '2039-08-30', 'Psychological support for Nina.', 1),
(189, 189, '2039-09-01', '2039-09-05', 'Medical care for Oasis.', 3),
(190, 190, '2039-10-05', '2039-10-10', 'Housing support for Pia.', 2),
(191, 191, '2039-11-10', '2039-11-15', 'Housing support for Pia.', 2),
(192, 192, '2039-12-15', '2039-12-20', 'Psychological support for Quinn.', 3),
(193, 193, '2040-01-02', '2040-01-10', 'Temporary shelter for Rita.', 3),
(194, 194, '2040-02-02', '2040-02-10', 'Counseling for Taylor.', 2),
(195, 195, '2040-03-06', '2040-03-12', 'Housing support for Lia.', 1),
(196, 196, '2040-04-11', '2040-04-15', 'Legal assistance for Felix.', 3),
(197, 197, '2040-05-13', '2040-05-20', 'Temporary shelter for Loha.', 3),
(198, 198, '2040-06-16', '2040-06-20', 'Counseling for Belle.', 2),
(199, 199, '2040-07-21', '2040-07-25', 'Counseling for Belle.', 3),
(200, 200, '2040-08-26', '2040-08-30', 'Housing support for Tina.', 3);


-- Insert Values for help_seeker_functional_need
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
(6, 7), -- Frank needs mobility assistance
(7, 2), -- Grace needs hearing aid
(8, 1), -- Hank needs walking assistance
(9, 4), -- Ivy needs cognitive functioning assistance
(10, 6), -- Jack needs communication assistance
(11, 2), -- Kim needs hearing aid
(11, 3), -- Kim needs visual aid
(12, 1), -- Liam needs walking assistance
(12, 5), -- Liam needs self-care assistance
(13, 3), -- Mia needs visual aid
(14, 4), -- Noah needs cognitive functioning assistance
(14, 7), -- Noah needs mobility assistance
(15, 1), -- Olivia needs walking assistance
(15, 6), -- Olivia needs communication assistance
(16, 5), -- Paul needs self-care assistance
(17, 3), -- Quinn needs visual aid
(17, 7), -- Quinn needs mobility assistance
(18, 2), -- Rita needs hearing aid
(19, 4), -- Sam needs cognitive functioning assistance
(20, 6), -- Tina needs communication assistance
(21, 1), -- Uma needs walking assistance
(21,5),  -- Uma needs self-care assistance
(22, 2), -- Victoria needs hearing aid
(23, 3), -- Wendy needs visual aid
(24, 4), -- Xander needs cognitive functioning assistance
(24, 6), -- Xander needs communication assistance
(25, 1), -- Yara needs walking assistance
(26, 7), -- Zack needs mobility assistance
(27, 2), -- Amy needs hearing aid
(27, 3), -- Amy needs visual aid
(28, 5), -- Tracy needs self-care assistance
(29, 6), -- Clara needs communication assistance
(30, 1), -- Dave needs walking assistance
(31, 7), -- Ella needs mobility assistance
(32, 2), -- Felix needs hearing aid
(32, 4), -- Felix needs cognitive functioning assistance
(33, 5), -- Gina needs self-care assistance
(34, 3), -- Harry needs visual aid
(35, 6), -- Isla needs communication assistance
(36, 1), -- Bethany needs walking assistance
(36, 3), -- Bethany needs visual aid
(37, 7), -- Kara needs mobility assistance
(38, 2), -- Lee needs hearing aid
(38, 4), -- Lee needs cognitive functioning assistance
(39, 5), -- Mona needs self-care assistance
(40, 6), -- Nina needs communication assistance
(41, 1), -- Omar needs walking assistance
(42, 2), -- Pia needs hearing aid
(42, 3), -- Pia needs visual aid
(43, 4), -- Rick needs cognitive functioning assistance
(44, 5), -- Sara needs self-care assistance
(45, 6), -- Tom needs communication assistance
(46, 7), -- Ula needs mobility assistance
(47, 1), -- Vera needs walking assistance
(47, 2), -- Vera needs hearing aid
(48, 3), -- Will needs visual aid
(49, 4), -- Xena needs cognitive functioning assistance
(50, 5), -- Yuri needs self-care assistance
(51, 6), -- Zara needs communication assistance
(52, 7), -- Alan needs mobility assistance
(53, 1), -- Beth needs walking assistance
(53, 2), -- Beth needs hearing aid
(54, 3), -- Carl needs visual aid
(55, 4), -- Dora needs cognitive functioning assistance
(56, 5), -- Evan needs self-care assistance
(57, 6), -- Fay needs communication assistance
(58, 7), -- Glen needs mobility assistance
(59, 1), -- Hope needs walking assistance
(60, 2), -- Ian needs hearing aid
(61, 3), -- Jill needs visual aid
(62, 4), -- Kyle needs cognitive functioning assistance
(63, 5), -- Lana needs self-care assistance
(64, 6), -- Mark needs communication assistance
(65, 7), -- Nora needs mobility assistance
(66, 1), -- Owen needs walking assistance
(67, 2), -- Pam needs hearing aid
(68, 3), -- Quinn needs visual aid
(69, 4), -- Ruth needs cognitive functioning assistance
(70, 5), -- Steve needs self-care assistance
(71, 6), -- Tara needs communication assistance
(72, 7), -- Uri needs mobility assistance
(73, 1), -- Vicky needs walking assistance
(74, 2), -- Walt needs hearing aid
(75, 3), -- Xia needs visual aid
(76, 4), -- Yvonne needs cognitive functioning assistance
(77, 5), -- Zane needs self-care assistance
(78, 6), -- Anna needs communication assistance
(79, 7), -- Blake needs mobility assistance
(80, 1), -- Cora needs walking assistance
(81, 2), -- Dean needs hearing aid
(82, 3), -- Ella needs visual aid
(83, 4), -- Finn needs cognitive functioning assistance
(84, 5), -- Gail needs self-care assistance
(85, 6), -- Hank needs communication assistance
(86, 7), -- Ivy needs mobility assistance
(87, 1), -- Jade needs walking assistance
(88, 2), -- Kara needs hearing aid
(89, 3), -- Mona needs visual aid
(90, 4), -- Nina needs cognitive functioning assistance
(91, 5), -- Oasis needs self-care assistance
(92, 6), -- Pia needs communication assistance
(93, 7), -- Quinn needs mobility assistance
(94, 1), -- Rita needs walking assistance
(95, 2), -- Taylor needs hearing aid
(96, 3), -- Lia needs visual aid
(97, 4), -- Felix needs cognitive functioning assistance
(98, 5), -- Loha needs self-care assistance
(99, 6), -- Belle needs communication assistance
(100, 7); -- Tina needs mobility assistance


-- Insert Values for help_seeker_language
INSERT INTO help_seeker_language (help_seeker_id, language_id) VALUES
(1, 3),
(1, 1),
(2, 3),
(2, 4),
(3, 3),
(3, 5),
(4, 3),
(4, 8),
(5, 15),
(6, 3),
(6, 12),
(7, 3),
(7, 9),
(8, 3),
(8, 1),
(9, 3),
(9, 4),
(10, 3),
(10, 5),
(11, 3),
(11, 8),
(12, 3),
(12, 10),
(13, 3),
(13, 12),
(14, 3),
(14, 9),
(15, 3),
(15, 1),
(16, 3),
(16, 4),
(17, 3),
(17, 5),
(18, 3),
(18, 8),
(19, 3),
(19, 10),
(20, 3),
(20, 12),
(21, 3),
(21, 9),
(22, 3),
(22, 1),
(23, 3),
(23, 4),
(24, 3),
(24, 5),
(25, 3),
(25, 8),
(26, 3),
(27, 3),
(27, 12),
(28, 3),
(28, 9),
(29, 3),
(29, 1),
(30, 3),
(30, 4),
(31, 3),
(31, 5),
(32, 3),
(32, 8),
(33, 10),
(34, 3),
(34, 12),
(35, 3),
(35, 9),
(36, 3),
(36, 1),
(37, 3),
(37, 4),
(38, 3),
(38, 5),
(39, 3),
(39, 8),
(40, 3),
(40, 10),
(41, 3),
(41, 12),
(42, 3),
(42, 9),
(43, 3),
(43, 1),
(44, 4),
(45, 3),
(45, 5),
(46, 3),
(46, 8),
(47, 3),
(47, 10),
(48, 3),
(48, 12),
(49, 3),
(49, 9),
(50, 3),
(50, 1),
(51, 3),
(51, 4),
(52, 3),
(52, 5),
(53, 3),
(53, 8),
(54, 13),
(55, 3),
(55, 12),
(56, 3),
(56, 9),
(57, 3),
(57, 1),
(58, 3),
(58, 4),
(59, 7),
(59, 5),
(60, 3),
(60, 8),
(61, 3),
(62, 3),
(62, 12),
(63, 3),
(63, 9),
(64, 3),
(64, 1),
(65, 3),
(65, 4),
(66, 3),
(66, 5),
(67, 6),
(67, 8),
(68, 3),
(68, 10),
(69, 3),
(69, 12),
(70, 3),
(70, 9),
(71, 3),
(71, 1),
(72, 3),
(72, 4),
(73, 3),
(73, 5),
(74, 3),
(74, 8),
(75, 6),
(76, 3),
(76, 12),
(77, 3),
(77, 9),
(78, 3),
(78, 1),
(79, 3),
(79, 4),
(80, 3),
(80, 5),
(81, 3),
(81, 8),
(82, 10),
(83, 3),
(83, 12),
(84, 3),
(84, 9),
(85, 3),
(85, 1),
(86, 3),
(86, 4),
(87, 3),
(87, 5),
(88, 3),
(88, 8),
(89, 3),
(89, 10),
(90, 3),
(90, 12),
(91, 3),
(91, 9),
(92, 3),
(92, 1),
(93, 3),
(94, 3),
(94, 5),
(95, 3),
(95, 8),
(96, 3),
(96, 10),
(97, 3),
(97, 12),
(98, 3),
(98, 9),
(99, 3),
(99, 1);

-- Insert Values for volunteer_language
INSERT INTO volunteer_language (volunteer_id, language_id) VALUES
(1, 1),
(1, 3),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 3),
(4, 8),
(5, 10),
(5, 12),
(6, 13),
(6, 9),
(7, 3),
(7, 1),
(8, 13),
(8, 14),
(9, 15),
(9, 6),
(10, 5),
(10, 8),
(11, 10),
(11, 12),
(12, 3),
(12, 9),
(13, 3),
(13, 1),
(14, 3),
(14, 14),
(15, 15),
(15, 6),
(16, 3),
(16, 8),
(17, 10),
(17, 12),
(18, 3),
(18, 9),
(19, 7),
(19, 1),
(20, 3),
(20, 4),
(21, 5),
(21, 6),
(22, 2),
(22, 8),
(23, 10),
(23, 12),
(24, 3),
(24, 9),
(25, 3),
(25, 11),
(26, 3),
(26, 4),
(27, 5),
(27, 6),
(28, 3),
(28, 8),
(29, 10),
(29, 12),
(30, 3),
(30, 9),
(31, 2),
(31, 1),
(32, 3),
(32, 4),
(33, 15),
(33, 16),
(34, 3),
(34, 8),
(35, 10),
(35, 12),
(36, 2),
(36, 9),
(37, 17),
(37, 1),
(38, 3),
(38, 4),
(39, 5),
(39, 6),
(40, 3),
(40, 18),
(41, 10),
(41, 12),
(42, 3),
(42, 9),
(43, 3),
(43, 1),
(44, 3),
(44, 4),
(45, 5),
(45, 6),
(46, 3),
(46, 8),
(47, 10),
(47, 12),
(48, 2),
(48, 3),
(48, 9),
(49, 3),
(49, 1),
(50, 3),
(50, 14);    
