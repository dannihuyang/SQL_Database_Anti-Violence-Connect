USE anti_violence;

/* 
This file includes two stored procedures for this project, both for controlling the data quality of the "intervention" table value.

PROCEDRE delete_ineligible_interventions is implemented at the end of the database setup (also see group07_backup.sql),
which is part of the steps for intervention table data cleaning after mock data insertion.

PROCEDRE create_intervention_with_incident_id is designed as an alternative procedure to create eligible user cases directly
in a prior control way for reference ((also see group07_query.sql). 

*/

/* 
Stored Procedure 1: delete the invalid entries in intervention table after mock data insertion
where volunteers has unmatched resources to needs (result: 172/180 interventions left).
*/
DROP PROCEDURE IF EXISTS delete_ineligible_interventions;

DELIMITER //

CREATE PROCEDURE delete_ineligible_interventions()
BEGIN
    -- Create a temporary table to store IDs of ineligible interventions
    CREATE TEMPORARY TABLE temp_ineligible_interventions
    AS
    SELECT incident_need_id
    FROM intervention
    LEFT JOIN incident_need_list USING (incident_need_id)
    LEFT JOIN volunteer_has_resource_list USING (volunteer_id)
    WHERE incident_need_list.need_id = volunteer_has_resource_list.need_id;

    -- Delete from intervention table using the temporary table
    DELETE FROM intervention
    WHERE incident_need_id NOT IN (SELECT incident_need_id FROM temp_ineligible_interventions);

    -- Drop the temporary table
    DROP TEMPORARY TABLE temp_ineligible_interventions;
END;
//
DELIMITER ;

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Call the procedure to delete invalid entries;
CALL delete_ineligible_interventions();

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;

-- Check restored intervention # of rows
SELECT *
FROM intervention; 


/* 
Note:
This procedure is designed after we finished mocking data, writing queries, and data analysis in the report. Originally we have 
implemented a stored procedure (refer to group07_stored_procedures.sql - PROCEDURE delete_ineligible_interventions) to delete
invalid intervention mock data entries afterwards, where volunteers' resources are mismatched with needs. However, we found that
a prior control makes more sense in the functional logic and is crucial for validating our user cases, so we create this alternative
stored procedure for reference, which is more comprehensive and prudent. 

For the queries, we are still using our mocked data with already inserted interventions.

----------

Stored Procedure 2: create interventions for an incident of a help seeker.

As for using this to create interventions in the actual application, this procedure is intended to be run after the operations of storing volunteer 
and help_seeker information, creating incident, need, and incident_need_list.

Since there might be several needs an incident involves, the JOIN table incident_need_list would
include several matchings of incident and need. Thus, multiple interventions need to be created
to address these different pairings of incident_need.

There will be no updating of the volunteer's availability after chosen, since one volunteer can intervene with multiple cases in reality depending on 
how much they want to commit. Volunteer's availability should be updated by themselves on the app.

*/

DROP PROCEDURE IF EXISTS create_intervention_with_incident_id;

DELIMITER //

CREATE PROCEDURE create_intervention_with_incident_id(
	IN incident_id_param INT)
BEGIN
    DECLARE incident_need_id_var INT;
    DECLARE need_id_var INT;
    DECLARE volunteer_id_var INT;
	###########row################
    DECLARE row_not_found TINYINT DEFAULT FALSE; 
    
    -- cursor to fetch incident needs because there might be multiple
    DECLARE incident_need_cursor CURSOR FOR         
	SELECT incident_need_id, need_id
    FROM incident_need_list
    WHERE incident_id = incident_id_param;
	
    -- continue handler, continue after finding an exception, don't just crash
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
        
	OPEN incident_need_cursor;
    
    -- read one row first (into the two variables)
    FETCH incident_need_cursor INTO incident_need_id_var, need_id_var;
    
    -- then while loop
    WHILE row_not_found = FALSE DO # meaning we found the row
		
        -- Find 1 volunteer to fulfill the need
		SELECT volunteer_id INTO volunteer_id_var
        FROM volunteer_has_resource_list
        JOIN volunteer USING (volunteer_id)
        WHERE need_id = need_id_var
        AND availability = 1
        LIMIT 1;
        
        -- Create intervention
        IF volunteer_id_var IS NOT NULL THEN
			INSERT INTO intervention(
				incident_need_id, 
                volunteer_id, 
                intervention_start_date, 
                intervention_status_id)
            VALUES (
				incident_need_id_var,
                volunteer_id_var,
                CURDATE(),
                1); -- 1 is for the intervention status 'Pending'
		END IF;
        
        -- read next row (ready after done the insert)
        FETCH incident_need_cursor INTO incident_need_id_var, need_id_var; 
	END WHILE;
    
    CLOSE incident_need_cursor;
    
END;
//
DELIMITER ;

-- Test cases:
-- Check current intervention # of rows
SELECT *
FROM intervention; 

-- Call the procedure with an incident_id
CALL  create_intervention_with_incident_id(5);

-- Check updated intervention # of rows
SELECT *
FROM intervention
JOIN incident_need_list USING (incident_need_id)
JOIN incident USING (incident_id)
WHERE incident_id = 5
AND intervention_start_date = CURDATE(); 

-- Delete this test case so the sample size of our mock data does not change
DELETE FROM intervention
WHERE intervention_start_date = CURDATE()
AND incident_need_id IN (
	SELECT incident_need_id
    FROM incident_need_list
    WHERE incident_id = 5
);

-- Check restored intervention # of rows
SELECT *
FROM intervention; 

