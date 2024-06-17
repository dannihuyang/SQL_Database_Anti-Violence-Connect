USE anti_violence;


SELECT * FROM violence_category;
SELECT * FROM need;
SELECT * FROM incident;
SELECT * FROM incident_need_list;

SELECT * FROM volunteer;
SELECT * FROM intervention_status;
SELECT * FROM intervention;

/* 1. (Resource/Need satisfaction) 
As each intervention is directing addressing an incident’s unique need, 
which means there will be multiple intervention created to meet the same incident’s different needs. 

What is the percentage of intervention being effective out of all interventions 
in terms of each violence category’s different needs of an incident?

* assuming as long as there is an incident with need, an intervention is automatically generally as pending
thus if there are 9 incident-need pair, there will automatically be 9 interventions
*/
SELECT 
  violence_category_name as violence_category,
  need_name,
  ROUND(100.0 * SUM(CASE WHEN ins.intervention_status_name = 'Effective' THEN 1 ELSE 0 END) 
  / COUNT(*), 2) as per_effective
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN incident_need_list USING (incident_id)
JOIN need USING (need_id)
JOIN intervention inte USING (incident_need_id)
JOIN intervention_status ins ON (inte.intervention_status_id = ins.intervention_status_id)
GROUP BY violence_category, need_name
ORDER BY violence_category, need_name;


/*
2. (Violence-location statistics) 
For each violence category, how many incidents happened in different locations in Vancouver? 
For each violence category, list the top three location with the corresponding number of incidents.

To limit the number of rows for each category, 
we need to use a stored procedure in mySQL or variables in PostgreSQL, Oracle which support window functions.
*/
SELECT 
	violence_category_name as violence_category, 
	location_name as location,
	COUNT(incident_id) as num_incident
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN location USING (location_id)
GROUP BY violence_category_name, location_name
ORDER BY violence_category, num_incident;


/*
3. (Help seeker statistics) 
The top violence that help seekers with different residency status face, 
and the number of incidents of each violence category. 
For the top violence of Temporary visa holders, 
what is the top language family that the help seekers’s language belongs to?
*/

/*
4. (Intervention - Violence Category - Effectiveness/Time) 
Show the percentage of interventions in each violence category been effective (intervention status = “effective”) 
out of all interventions (excluding cases where intervention status = “closed”) after 3 months, 6 months and 12 months. 
In the same query, output the average dates each violence category’s interventions take.
/*


/*
5. (Functional Needs - Intervention Effectiveness) 
Are there any correlations between what the help seeker’s functional needs are 
and whether the interventions are successfully resolved or not within a long enough period of time (12 months)? 
For each kind of functional need of help seekers, what are the percentage of the interventions being effective.
/*
