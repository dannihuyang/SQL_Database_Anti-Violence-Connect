/*
This file includes 1 stored procedure to create interventions to match volunteer with help seekers in order to demonstrate
the app's main function. It also includes 7 queries (5.1 and 5.2 as two queries) to implement data analysis based on a mock
data sample for the app users and organizations to understand the violence issues more in depth as to further their volunteering work.
*/

USE anti_violence;

/* 
** Note:
This procedure is designed after we finished mocking data, writing queries, and data analysis in the report. Originally we have 
implemented a stored procedure (refer to group07_stored_procedures.sql - PROCEDURE delete_ineligible_interventions) to delete
invalid intervention mock data entries afterwards, where volunteers' resources are mismatched with needs. However, we found that
a prior control makes more sense in the functional logic and is crucial for validating our user cases, so we created this alternative
stored procedure for reference, which is more comprehensive for our main app feature. 

For the queries, we are still using our mocked data with already inserted interventions.

-----------

Stored Procedure to create interventions for an incident of a help seeker.

As for using this to create interventions in the actual application, this procedure is intended to be run after the operations of storing volunteer 
and help_seeker information, creating incident, need, and incident_need_list.

Since there might be several needs an incident involves, the JOIN table incident_need_list would
include several matchings of incident and need. Thus, multiple interventions need to be created
to address these different pairings of incident_need.

There will be no updating of the volunteer's availability after chosen, since one volunteer can intervene with multiple cases in reality depending on 
how much they want to commit. Volunteer's availability should be updated by themselves on the app.

However, in the future, we could implement TRIGGER operations to better the logic of matching volunteers for each incident need.
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


	    
/* 
Query 1: On Incident-Need Satisfaction

As each intervention is directing addressing an incident’s unique need, 
which means there will be multiple intervention created to meet the same incident’s different needs. 

For each violence category’s various need (category of need), how many needs have been requested? 
What is the percentage of intervention being effective out of all interventions 
(excluding the ones that are closed and escalated) for each pairing of violence category and need? 
List the top 3 largest number of need requested for each violence category.

* assuming as long as there is an incident with need, an intervention is automatically generally as pending
thus if there are 9 incident-need pair, there will automatically be 9 interventions

Potential Insights: By identifying the pairings with the highest number of needs requested as well as if it has 
a low effectiveness percentage, volunteeres and organizations can prioritize resources and attention towards 
the most critical areas. This can help ensure that the most prevalent needs are addressed promptly and adequately.
*/

WITH ViolenceNeedPairing AS ( # use WITH for temporary reference to use with SELECT query
    SELECT 
        violence_category_name AS violence_category,
        need_name,
        COUNT(need_name) AS num_of_need,
        ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' THEN 1 ELSE 0 END) 
            / COUNT(CASE WHEN intervention_status_name != 'Closed' 
                          AND intervention_status_name != 'Escalated' THEN 1 END), 1) AS per_effective,
        ROW_NUMBER() OVER ( # assign a sequential interger to rows with paritition
			PARTITION BY violence_category_name # calculation restarts for each partition (grouping)
            ORDER BY COUNT(need_name) DESC # ranking from least effective on top
		) AS NeedEachViolenceRanked
    FROM violence_category vc
    JOIN incident USING (violence_category_id)
	JOIN incident_need_list USING (incident_id)
	JOIN need USING (need_id)
	JOIN intervention USING (incident_need_id)
	JOIN intervention_status USING (intervention_status_id)
    GROUP BY violence_category_name, need_name
)
SELECT 
    violence_category,
    need_name,
    num_of_need,
    per_effective
FROM ViolenceNeedPairing
WHERE NeedEachViolenceRanked <= 3 # only include the top three ranked needs for each violence
ORDER BY violence_category;

/*
Query 2: Violence-Location Statistics

For each location, what type of violence happen and how many incidents? 
For each location and violence pairing, list the number of incidents in descending order. 
Show the top 10 most number of incident pairing.

Potential Insights: By examining the most frequent location-violence pairings, 
we can discern trends and patterns, which may indicate underlying social, economic, 
political or cultural factors contributing to violence in specific areas.
*/
SELECT 
	location_name as location,
	violence_category_name as violence_category, 
	COUNT(incident_id) as num_incident
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN location USING (location_id)
GROUP BY violence_category_name, location_name
ORDER BY num_incident DESC
LIMIT 10;

-- Show the number of incidents of all types of violence in each location
SELECT 
    location_name as location,
    violence_category_name as violence_category, 
    COUNT(incident_id) as num_incident
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN location USING (location_id)
GROUP BY location_name, violence_category_name
ORDER BY location_name, num_incident DESC;



/* 
Query 3: On Intervention - Effectiveness Over Time

For each violence category, 
show the percentage of interventions being effective out of all interventions (excluding cases where intervention status = “closed”) 
after 3 months, 6 months, 12 months and 24 months. 
In the same query, output the average duration each violence category’s interventions take to be effective
(even if it took more than 24 months), order by the longest average duration. 
*/
SELECT 
	violence_category_name as violence_category,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 90 THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) as effective_3_months,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 180 THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) as effective_6_months,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 365 THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) as effective_12_months,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= (365 * 2) THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed' 
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) as effective_24_months,
    ROUND(AVG(CASE WHEN intervention_status_name = 'Effective' 
        THEN DATEDIFF(intervention_end_date, intervention_start_date) END), 0) 
        as average_duration
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN incident_need_list USING (incident_id)
JOIN intervention USING (incident_need_id)
JOIN intervention_status USING (intervention_status_id)
GROUP BY violence_category_name
ORDER BY average_duration DESC;

/*
Query 4: On Language Family - Need Satisfaction

For each different language family, which needs (such as shelter, food, medical care, etc.) are the least satisfied? 
Calculate the satisfaction rate (i.e., the proportion of effective interventions, with no time limit) 
for each need within each language family, order from least percentage of effectiveness to most. 
Show the satisfaction rate that is lower than 60%.
*/
SELECT 
	language_family_name as language_family,
    need_name,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) as per_effective
FROM language_family
JOIN language USING (language_family_id)
JOIN help_seeker_language USING (language_id)
JOIN help_seeker USING (help_seeker_id)
JOIN incident USING (help_seeker_id)
JOIN incident_need_list USING (incident_id)
JOIN need USING (need_id)
JOIN intervention USING (incident_need_id)
JOIN intervention_status USING (intervention_status_id)
GROUP BY language_family_name, need_name
HAVING per_effective IS NOT NULL
-- HAVING per_effective <= 60.0
ORDER BY per_effective;
	
/*
Query 5.1:  On Intervention Effectiveness if with Functional Needs

Since functional_need’s relationship with incident_need still need other implementations, 
this query can be currently used as a hypothetical analysis. 
We currently think of functional need for now as a need that each help_seeker might have but not necessarily addressed by 
the volunteers (the volunteers do not have such resource) to exemplify how these needs in our current environment are unseen.

1) step 1: Are there any connection between help seeker having functional needs or not and whether the interventions 
are successfully resolved or not within a long enough period of time (6months and 12 months)? 
*/

WITH EffectiveWithFunctionalNeed AS (
	SELECT 
		ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 180 THEN 1 ELSE 0 END) 
		/ COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) AS effective_6_months_with_fn,
		ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 365 THEN 1 ELSE 0 END) 
		/ COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) AS effective_12_months_with_fn
	FROM help_seeker
	JOIN incident USING (help_seeker_id)
	JOIN incident_need_list USING (incident_id)
	JOIN intervention USING (incident_need_id)
	JOIN intervention_status USING (intervention_status_id)
	WHERE help_seeker_id IN
		(SELECT DISTINCT
			help_seeker_id
		FROM help_seeker_functional_need)
),
EffectiveWithoutFunctionalNeed AS (
	SELECT 
		ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 180 THEN 1 ELSE 0 END) 
		/ COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) AS effective_6_months_without_fn,
		ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 365 THEN 1 ELSE 0 END) 
		/ COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) AS effective_12_months_without_fn
	FROM help_seeker
	JOIN incident USING (help_seeker_id)
	JOIN incident_need_list USING (incident_id)
	JOIN intervention USING (incident_need_id)
	JOIN intervention_status USING (intervention_status_id)
		WHERE help_seeker_id NOT IN
		(SELECT DISTINCT
			help_seeker_id
		FROM help_seeker_functional_need)
)
SELECT
	(SELECT effective_6_months_with_fn FROM EffectiveWithFunctionalNeed) AS 6_months_with_fn,
	(SELECT effective_6_months_without_fn FROM EffectiveWithoutFunctionalNeed) AS 6_months_without_fn,
    	(SELECT effective_12_months_with_fn FROM EffectiveWithFunctionalNeed) AS 12_months_with_fn,
    	(SELECT effective_12_months_without_fn FROM EffectiveWithoutFunctionalNeed) AS 12_months_without_fn;
	 
    
/* 
Query 5.2:  On Intervention Effectiveness with Each Functional Need

Are there any correlations between what the help seeker’s functional needs are and whether the interventions
are successfully resolved or not within a long enough period of time (12 months)? 
For each kind of functional need of help seekers, what are the percentage of the interventions being effective, 
order from least percentage of effectiveness to most.
*/
SELECT 
	functional_need_name,
 	ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 365 THEN 1 ELSE 0 END) 
		/ COUNT(CASE WHEN intervention_status_name != 'Closed'
			AND intervention_status_name != 'Escalated' THEN 1 END), 1) AS effective_12_months
FROM functional_need
JOIN help_seeker_functional_need USING (functional_need_id)
JOIN help_seeker USING (help_seeker_id)
JOIN incident USING (help_seeker_id)
JOIN incident_need_list USING (incident_id)
JOIN intervention USING (incident_need_id)
JOIN intervention_status USING (intervention_status_id)
GROUP BY functional_need_name
ORDER BY effective_12_months;


/*
Query 6: On Help Seeker Statistics - Residency Status

For help seekers with different residency status, what kind of violence do they face the most, 
show the number of incidents happen for different pairs of residency status and violence category? 
Which pair experiences the most violent incidents? 
Show the top 10 most number of incident pairing.

Potential Insights: The findings can inform community outreach and education programs. 
For instance, if workplace violence is particularly high among permanent residents, 
targeted workplace safety and rights education campaigns can be implemented.
*/
SELECT 
	residency_status_category,
	violence_category_name,
	COUNT(incident_id) as num_incident
FROM help_seeker
JOIN residency_status USING (residency_status_id)
JOIN incident USING (help_seeker_id)
JOIN violence_category USING (violence_category_id)
GROUP BY residency_status_category, violence_category_name
ORDER BY num_incident DESC
LIMIT 10;

