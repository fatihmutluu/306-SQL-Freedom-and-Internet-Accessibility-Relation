-- finds the set difference of high democracy level countries and low urban population countries
select Country_name, Democracy_estimate
from step3.policy
where Year between 1990 and 2022 and Democracy_estimate >= 8.0;
select Country_name, Urban_population
from step3.infrastructure
where Year between 1990 and 2022 and Urban_population <= 10;

-- code below finds the same result using outer join
select p.Country_name, p.Democracy_estimate
from step3.policy p
left join step3.infrastructure i on p.Code = i.Code and p.Year = i.Year
where p.Year between 1990 and 2022 and p.Democracy_estimate >= 8.0 and (i.Urban_population is null or i.Urban_population <= 10);

-- using the IN operator:
select * from step3.policy
where Code in (
  select Code from step3.government
  where Year = 2022
) and Year = 2022;


-- using the EXISTS operator:
select * from step3.policy p
where exists (
  select * from step3.government g
  where p.Code = g.Code and g.Year = 2022
) and p.Year = 2022;

select countries.Country_name, count(*) AS Freedom_years from step3.policy p
join step3.countries on p.Code = countries.Code
WHERE p.Freedom_estimate > 75 and p.Democracy_estimate > 75
GROUP BY p.Code
HAVING COUNT(*) > 0;

SELECT C.Country_name, C.Internet_arrival_year, G.GDP FROM step3.countries C, step3.government G 
WHERE C.Code = G.Code AND G.GDP IS NOT NULL AND G.Year = C.Internet_arrival_year
GROUP BY G.GDP,G.Code, G.Year
HAVING C.Internet_arrival_year < (SELECT AVG(C2.Internet_arrival_year) FROM step3.countries C2);

select c.Country_name, com.Number_of_Internet_users as internet_users,
isp.Mobile_cellular_subscriptions as cell_subscriptions
from step3.countries c
join(
  select Code, Number_of_Internet_users
  From step3.community
  where Year = 2020
  group by Code, Number_of_Internet_users
) com on c.Code = com.Code
join (
  select Code, Mobile_cellular_subscriptions
  from step3.isp
  where Year = 2020
  group by Code, Mobile_cellular_subscriptions
) isp on c.Code = isp.Code;

select i.Year, sum(i.Landline_phone_subscriptions) as total_subscriptions
from step3.isp i
join step3.countries c on i.Code = c.Code
group by i.Year
having total_subscriptions > 1000
order by total_subscriptions desc;

select i.Year, c.Country_name, i.Urban_population, i.Electricity_access_urban
from step3.infrastructure i
join step3.countries c on c.Code = i.Code
where i.Electricity_access_urban = (
    select min(Electricity_access_urban)
    from step3.infrastructure
    where Year = i.Year
)
order by Year;
