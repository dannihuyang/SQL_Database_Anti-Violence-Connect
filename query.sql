USE anti_violence;


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
	ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' THEN 1 ELSE 0 END) 
	/ COUNT(CASE WHEN intervention_status_name != 'Closed' THEN 1 END), 1) as per_effective
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN incident_need_list USING (incident_id)
JOIN need USING (need_id)
JOIN intervention USING (incident_need_id)
JOIN intervention_status USING (intervention_status_id)
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
3. (Help seeker - Residency Status - Incident, statistics) 
For help seekers with different residency status, what kind of violence (violence_category) do they face the most, 
show the number of incidents happen for different pairs of residency status and violence category? 
Which pair experience the most violent incidents?
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
ORDER BY num_incident;

/*
4. (Intervention - Violence Category - Effectiveness/Time) 
For each violence category, 
show the percentage of interventions being effective out of all interventions (excluding cases where intervention status = “closed”) 
after 3 months, 6 months, 12 months and 24 months. 
In the same query, output the average duration each violence category’s interventions take to be effective (even if it took more than 24 months),
order by the longest average duration. 
*/
SELECT 
	violence_category_name as violence_category,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 90 THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed' THEN 1 END), 1) as effective_3_months,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 180 THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed' THEN 1 END), 1) as effective_6_months,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 365 THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed' THEN 1 END), 1) as effective_12_months,
    ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= (365 * 2) THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed' THEN 1 END), 1) as effective_24_months,
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
5. (Functional Needs - Intervention Effectiveness) 
* Since functional_need’s relationship with incident_need still need other implementations, 
this query can be currently used as a hypothetical analysis.
* We can think of functional need for now as a need that each help_seeker might have but not necessarily addressed by the volunteers 
(the volunteers do not have such resource) to exemplify how these needs in our current environment are unseen.

Are there any correlations between what the help seeker’s functional needs are and whether the interventions are successfully 
resolved or not within a long enough period of time (12 months)? 
For each kind of functional need of help seekers, what are the percentage of the interventions being effective, 
order from least percentage of effectiveness to most.
*/
SELECT 
functional_need_name,
 ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' AND DATEDIFF(intervention_end_date, intervention_start_date) <= 365 THEN 1 ELSE 0 END) 
    / COUNT(CASE WHEN intervention_status_name != 'Closed' THEN 1 END), 1) as effective_12_months
FROM functional_need
JOIN help_seeker_functional_need USING (functional_need_id)
JOIN help_seeker USING (help_seeker_id)
JOIN incident USING (help_seeker_id)
JOIN incident_need_list USING (incident_id)
JOIN intervention USING (incident_need_id)
JOIN intervention_status USING (intervention_status_id)
GROUP BY functional_need_name
ORDER BY effective_12_months;
