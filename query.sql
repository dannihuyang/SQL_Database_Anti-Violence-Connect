USE anti_violence;


/* 
Query 1: On Incident-Need Satisfaction

As each intervention is directing addressing an incident’s unique need, 
which means there will be multiple intervention created to meet the same incident’s different needs. 

For each violence category’s various need (category of need), how many needs have been requested? 
What is the percentage of intervention being effective out of all interventions 
(excluding the ones that are closed and escalated) for each pairing of violence category and need? 
List the pairing with the top 5 most number of need requested to match volunteers with, 
show how effective the corresponding interventions were.

* assuming as long as there is an incident with need, an intervention is automatically generally as pending
thus if there are 9 incident-need pair, there will automatically be 9 interventions

Potential Insights: By identifying the pairings with the highest number of needs requested as well as if it has 
a low effectiveness percentage, volunteeres and organizations can prioritize resources and attention towards 
the most critical areas. This can help ensure that the most prevalent needs are addressed promptly and adequately.
*/
SELECT 
	violence_category_name as violence_category,
	need_name,
    count(need_name) as num_of_need,
	ROUND(100.0 * SUM(CASE WHEN intervention_status_name = 'Effective' THEN 1 ELSE 0 END) 
	/ COUNT(CASE WHEN intervention_status_name != 'Closed' 
					  AND intervention_status_name != 'Escalated' THEN 1 END), 1) as per_effective
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN incident_need_list USING (incident_id)
JOIN need USING (need_id)
JOIN intervention USING (incident_need_id)
JOIN intervention_status USING (intervention_status_id)
GROUP BY violence_category, need_name
ORDER BY num_of_need DESC
LIMIT 5;


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


/*
Query 3: On Help Seeker Statistics - Residency Status

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


/* 
Query 4: On Intervention - Effectiveness Over Time

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
Query 5:  On Intervention Effectiveness if with Functional Needs

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
	 
    
/* step 2 
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
Query 6: On Language Family - Need Satisfaction

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
HAVING per_effective <= 60.0
ORDER BY per_effective;
