-- select all non-payment and holdover cases filed since 2020: 
with cases_plus_rep as (
	select 
		oi.*,
		representationtype from oca_index oi  
	left join oca_parties op using(indexnumberid)
	left join oca_case_summary ocs using(indexnumberid)
	where oi.classification in ('Non-Payment','Holdover')
		and propertytype = 'Residential'
		and oi.court = any('{
						Bronx County Civil Court,
						Kings County Civil Court,
						New York County Civil Court,
						Queens County Civil Court,
						Richmond County Civil Court,
						Redhook Community Justice Center,
						Harlem Community Justice Center
					}')
		-- grab everything after the eviction moratorium ended
		and fileddate > '2020-01-02'
),

-- select just relevant fields and eliminate duplicates
all_cases as (
	select 
		indexnumberid, 
		classification, 
		fileddate,
		date_trunc('week', fileddate)::date as day
	from cases_plus_rep
	group by indexnumberid, classification, fileddate, day
)
-- group by week filed and calculated representation rate 
select 
	day as week_starting_day, 
	count(*) as allcases
from all_cases
where day < current_date - interval '4 weeks'
group by day
order by day;


