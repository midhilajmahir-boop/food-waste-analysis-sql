--Exploratory & Core Analysis--



--Which business type generates the highest total food waste?--
select 
     business_type ,
	 sum(waste_quantity) as total_waste
from food_waste
group by business_type
order by total_waste desc

--Which food category contributes the most to food waste?--
select
     food_category,
	 sum(waste_quantity) as product_waste
from food_waste
group by food_category
order by product_waste desc


--What is the most common reason for food waste?--
select 
     waste_reason,count(*)
from food_waste
group by waste_reason


--Which month records the highest food waste?--
select
     extract(month from order_date) as most_wastage_month,
	 sum(waste_quantity)
from food_waste
group by most_wastage_month
order by most_wastage_month asc

	 
--What percentage of purchased food becomes waste?--
select
    sum(purchase_quantity) as total_purchase,
    sum(waste_quantity) as total_waste,
    (sum(waste_quantity)::numeric /
     nullif(sum(purchase_quantity), 0)) * 100 as waste_percentage
from food_waste


--Which business type has the highest average food waste?--
select 
     business_type,
	 avg(waste_quantity) as avg_waste
from food_waste
group by business_type
order by avg_waste desc


--Does shorter shelf life lead to higher food waste?--
select 
     case
	    when shelf_life_days between 1 and 3 then 'Short'
		when shelf_life_days between 4 and 7 then 'Medium'
		else 'Long'
		end as life_food,
	avg(waste_quantity)
from food_waste
group by  case
	    when shelf_life_days between 1 and 3 then 'Short'
		when shelf_life_days between 4 and 7 then 'Medium'
		else 'Long'
		end 
--Which food categories generate more waste than the average waste across all food categories?--
select 
     food_category,
	 sum(waste_quantity) as total_waste
from food_waste
group by food_category
having sum(waste_quantity)>(
select avg(category_waste)
    from (
        select
            food_category,
            sum(waste_quantity) as category_waste
        from food_waste
        group by food_category
    ) as category_summary
)
order by total_waste desc


--Which business types generate the most waste and donations?--
with business_waste as(
select
     business_type,
	 sum(waste_quantity) as total_waste
from food_waste
group by business_type
),
donation_summary as(
select
     business_type,
	 sum(waste_quantity) as donated_waste
from food_waste
where donation_made='Yes'
group by business_type
)
select
    b.business_type,
	b.total_waste,
	d.donated_waste,
	(d.donated_waste::numeric / nullif(b.total_waste, 0)) * 100 as donation_percentage
from business_waste as b
left join donation_summary as d
on b.business_type=d.business_type


--rank food categories contribute the most to total waste?--
with category_waste as(
select
     food_category,
	 sum(waste_quantity) as total_waste
from food_waste
group by food_category
),
overall_waste as(
select
     sum(waste_quantity) as overall_total_waste
from food_waste
)
select 
    c.food_category,
    c.total_waste,
rank() over(
order by c.total_waste desc
) as rank_waste,
(c.total_waste::numeric / o.overall_total_waste) * 100
    as contribution_percentage
from category_waste as c
cross join overall_waste as o


--reusable summary of food waste by business type.--
create view business_waste_summary as
select
     business_type,
	 sum(waste_quantity) as total_waste,
	 avg(waste_quantity) as avg_waste,
	 count(*) as total_record
from food_waste
group by business_type


--Management wants to understand which food categories contribute most to food waste.--
create view food_category_waste_summary as
select 
      food_category,
	  sum(waste_quantity) as total_waste,
	  avg(waste_quantity) as avg_waste,
	  count(*) as total_record,
	  sum(waste_quantity)::numeric/
	  nullif((select sum(waste_quantity) from food_waste),0)*100
	  as waste_contribution
from food_waste 
group by food_category


--Management wants to understand whether promotions influence food waste.--
create view promotion_waste_summary as
select
     promotion as promation_status,
	 sum(waste_quantity) as total_waste,
	 avg(waste_quantity) as avg_waste,
	 count(*) as total_record,
	 (sum(waste_quantity)::numeric /
     nullif((select sum(waste_quantity) from food_waste), 0)) * 100
     as waste_contribution
from food_waste
group by promation_status


--Which food categories have the highest waste percentage compared with their purchased quantity?--
select
   food_category,
   sum(purchase_quantity) as total_puschase,
   sum(waste_quantity) as total_waste,
   (sum(waste_quantity)::numeric /
     nullif(sum(purchase_quantity) , 0)) * 100
     as waste_percentage
from food_waste
group by food_category
order by waste_percentage desc




--KPI's--
select 
     sum(purchase_quantity) as total_purchase,
	 sum(waste_quantity) as total_waste,
	 (sum(waste_quantity)::numeric /
     nullif(sum(purchase_quantity) , 0)) * 100
     as waste_percentage,
	 sum(
	    case
           when donation_made='Yes' then waste_quantity 
		   else 0
		   end
		   ) as total_donated_waste,
	sum(
        case
		    when donation_made='Yes' then waste_quantity 
		   else 0
		   end
		   ) ::numeric /nullif (sum(waste_quantity),0)*100 as donation_percentage,
		   
	
	 avg(waste_quantity) as avg_waste
from food_waste

