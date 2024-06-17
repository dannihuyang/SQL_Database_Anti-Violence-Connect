USE anti_violence;


SELECT * FROM violence_category;
SELECT * FROM need;
SELECT * FROM incident;
SELECT * FROM incident_need_list;

SELECT * FROM volunteer;
SELECT * FROM intervention_status;
SELECT * FROM intervention;

/* 1. (Resource/Need satisfaction) 
What are the needs for different violence categories and how well are they addressed? 
Order by number of needs in desc order, **and show the % of intervention that has been resolved.**
*/ 

-- what are the needs for different violence categories

-- JOIN intervention_status ins ON (inte.intervention_status_id = ins.intervention_status_id AND intervention_status_name = 'Effective')
-- AND intervention_status_name = 'Effective'

-- assuming as long as there is an incident with need, an intervention is automatically generally as pending
-- thus if there are 9 incident-need pair, there will automatically be 9 interventions
SELECT 
violence_category_name as violence_category,
GROUP_CONCAT(DISTINCT need_name ORDER BY need_name SEPARATOR ', ') as need,
COUNT(need_name) as num_need
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN incident_need_list USING (incident_id)
JOIN need USING (need_id)
JOIN intervention inte USING (incident_need_id)

GROUP BY violence_category_name
ORDER BY num_need DESC;


SELECT 
*
FROM violence_category
JOIN incident USING (violence_category_id)
JOIN incident_need_list USING (incident_id)
JOIN need USING (need_id)
JOIN intervention inte USING (incident_need_id)
JOIN intervention_status ins ON (inte.intervention_status_id = ins.intervention_status_id);

/*
2. (Violence-location statistics) 
What are the distribution of locations of violence incidents in Vancouver? 
Order by violence category in desc order.
*/


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
