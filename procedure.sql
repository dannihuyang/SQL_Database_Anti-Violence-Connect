USE anti_violence;


-- Procedure to delete the invalid entries in intervention table 
-- where volunteers has unmatched resources to needs (result: 173/180 interventions left).
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





