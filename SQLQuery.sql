-- C.Y Number of Casualties
select sum(number_of_casualties) as CY_Casualties
from road_accident
where accident_date like '2022%'

-- C.Y Number of Accidents
select count(accident_index) as CY_Accidents
from road_accident
where accident_date like '2022%'

-- C.Y Fatal Casualties
select sum(number_of_casualties) as CY_Fatal_Casualties
from road_accident
where accident_severity ='Fatal' and accident_date like '2022%'

-- C.Y Serious Casualties
select sum(number_of_casualties) as CY_Serious_Casualties
from road_accident
where accident_severity ='Serious' and accident_date like '2022%'

-- C.Y Slight Casualties
select sum(number_of_casualties) as CY_Slight_Casualties
from road_accident
where accident_severity ='Slight' and accident_date like '2022%';

--Casualties by Vehicle Type
with t1 as (
select *,
case when vehicle_type in ('Agricultural vehicle') then 'Agriculture'
when vehicle_type in ('Car','Taxi/Private hire car') then 'Cars'
when vehicle_type in ('Motorcycle 125cc and under','Motorcycle 50cc and under',
	'Motorcycle over 125cc and up to 500cc','Motorcycle over 500cc','Pedal cycle') then 'Bike'
when vehicle_type in ('Bus or coach (17 or more pass seats)',
	'Minibus (8 - 16 passenger seats)') then 'Bus'
when vehicle_type in ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t',
	'Van / Goods 3.5 tonnes mgw or under') then 'Van'
else 'Other'
end as Vehicle_group
from road_accident
where accident_date like '2022%')
select Vehicle_group, sum(number_of_casualties) as CY_Casualties_by
from t1
group by Vehicle_group
order by Vehicle_group;

--CY Casualties Monthly Trend
select datename(MONTH,accident_date) as Month_Name,
sum(number_of_casualties) as CY_Casualties
from road_accident
where accident_date like '2022%'
group by datename(MONTH,accident_date)

--PY Casualties Monthly Trend
select datename(MONTH,accident_date) as Month_Name,
sum(number_of_casualties) as PY_Casualties
from road_accident
where accident_date like '2021%'
group by datename(MONTH,accident_date)

--CY Casualties by road type
select road_type, sum(number_of_casualties) as Casualties_by_Road_Type
from road_accident
where accident_date like '2022%'
group by road_type

--CY Casualties by Urban/ rural area
select urban_or_rural_area, cast(sum(number_of_casualties) as decimal(10,2))*100/
(select cast(sum(number_of_casualties) as decimal(10,2)) from road_accident where accident_date like '2022%') as Areawise_Casualties
from road_accident
where accident_date like '2022%'
group by urban_or_rural_area;

--CY Casualties by Light Condition
with t1 as (
select *,
case when light_conditions = 'Daylight' then 'Day'
else 'Night' end as Light_condition
from road_accident
)
select Light_condition, cast(sum(number_of_casualties) as decimal(10,2))*100/
(select cast(sum(number_of_casualties) as decimal(10,2)) from t1 where accident_date like '2022%') as Casualties_by_Light_Condition
from t1
where accident_date like '2022%'
group by Light_condition

--CY Top 10 Casualties by Location
select top 10 local_authority as Loaction, sum(number_of_casualties) as Total_Casualties
from road_accident
where accident_date like '2022%'
group by local_authority
order by sum(number_of_casualties) desc