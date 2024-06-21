USE anti_violence;


-- procedure to delete the invalid volunteers with the unmatched needs (result: 42/180 intervention left)
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

    -- Debug: Select records from the temporary table to verify
    SELECT * FROM temp_ineligible_interventions;

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

-- Call the procedure
CALL delete_ineligible_interventions();

-- Re-enable safe update mode (optional)
SET SQL_SAFE_UPDATES = 1;





-- test -----------

-- this query checks the remaining intervention records are all eligible for need matching (all volunteers involved have that resource)
select intervention_id, incident_need_id, incident_id, incident_need_list.need_id as "need", volunteer_id, volunteer_has_resource_list.need_id as "resource"
    FROM intervention
    LEFT JOIN incident_need_list using (incident_need_id)
	LEFT JOIN volunteer_has_resource_list using (volunteer_id)
    ORDER BY intervention_id;



-- other queries to check data
select intervention_id, incident_need_id, incident_id, incident_need_list.need_id as "need", volunteer_id, volunteer_has_resource_list.need_id as "resource"
    FROM intervention
    LEFT JOIN incident_need_list using (incident_need_id)
	LEFT JOIN volunteer_has_resource_list using (volunteer_id)
    WHERE incident_need_list.need_id != volunteer_has_resource_list.need_id
    ORDER BY intervention_id;
    
    
SELECT *
    FROM intervention
    LEFT JOIN incident_need_list USING (incident_need_id)
    LEFT JOIN volunteer_has_resource_list USING (volunteer_id)
    WHERE incident_need_list.need_id != volunteer_has_resource_list.need_id;
    
select intervention_id, incident_need_id, incident_id, incident_need_list.need_id as "need", volunteer_id, volunteer_has_resource_list.need_id as "resource"
    FROM intervention
    LEFT JOIN incident_need_list using (incident_need_id)
	LEFT JOIN volunteer_has_resource_list using (volunteer_id)
    WHERE incident_need_list.need_id != volunteer_has_resource_list.need_id
    ORDER BY intervention_id;


    SELECT intervention.intervention_id, incident_need_list.need_id, incident_need_list.incident_need_id
    FROM intervention
    LEFT JOIN incident_need_list using (incident_need_id)
	LEFT JOIN volunteer_has_resource_list using (volunteer_id)
    WHERE incident_need_list.need_id != volunteer_has_resource_list.need_id;
    
