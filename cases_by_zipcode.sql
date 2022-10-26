-- select non-payment and holdover cases' respondents and representation types, filed after the eviction moratorium expired, that have had their first appearance within the last week
with first_appearance as (
    select 
    	indexnumberid, 
    	min(appearancedatetime) as appearancedatetime
    from oca_appearances
    group by indexnumberid
),

cases_plus_rep as (
	select 
		oi.*,
		representationtype,
		postalcode 
	from oca_index oi  
	left join oca_parties op using(indexnumberid)
	inner join first_appearance using(indexnumberid)
	left join (
		-- NOTE: A total of 17 cases since 1/16/2022 had 2 postal codes associated
		-- with the same case. All others had only one. This analysis only takes the 
		-- first postal code listed with the case.
		select 
			indexnumberid,
			first(postalcode) as postalcode
		from oca_addresses
		group by indexnumberid
	) oa using(indexnumberid)
	where oi.classification in ('Non-Payment','Holdover')
	and role = 'Respondent' 
	and propertytype = 'Residential'
	and representationtype != 'No Appearance' -- filter out no appearances 
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
		and fileddate > '2022-01-16'
		and appearancedatetime < current_date - interval '1 weeks'
),

-- select just relevant fields and eliminate duplicates
all_cases as (
	select 
		indexnumberid, 
		date_trunc('week', fileddate)::date as weekstartingday, 
		postalcode,
		string_agg(distinct representationtype, ', ') as representationtype
	from cases_plus_rep
	group by indexnumberid, weekstartingday, postalcode
)
-- group by week filed and calculated representation rate 
select 
	postalcode, 
	-- Count cases with "Self-Represented Litigants" only
	count(*) filter (where representationtype = 'SRL') as srl,
	-- Count cases with representation (or partial representation)
	count(*) filter (where representationtype != 'SRL') as represented,
	-- Count total eviction cases with appearances 
	count(*) as allcases,
	-- Calculate percent of cases that had representation
	(count(*) filter (where representationtype != 'SRL'))::numeric*100 / count(*) as rep_rate
from all_cases
-- grab everything after the eviction moratorium ended
where weekstartingday < current_date - interval '4 weeks'
group by postalcode
order by allcases;

