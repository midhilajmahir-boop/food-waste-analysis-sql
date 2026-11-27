--data cleaning--


--Check if colum contain null value--
select
    count(*) filter (where inventory_id is null) as inventory_id_null,
	count(*) filter (where order_date is null) as order_date_null,
	count(*) filter (where business_type is null) as business_type_null,
	count(*) filter (where food_category is null) as food_category_null,
	count(*) filter (where purchase_quantity is null) as purchase_quantity_null,
	count(*) filter (where units_sold is null) as units_sold_null,
	count(*) filter (where remaining_stock is null) as remaining_stock_null,
	count(*) filter (where shelf_life_days is null) as shelf_life_days_null,
	count(*) filter (where storage_temperature is null) as storage_temperature_null,
	count(*) filter (where daily_demand is null) as daily_demand_null,
	count(*) filter (where promotion is null) as promotion_null,
	count(*) filter (where weather is null) as weather_null,
	count(*) filter (where waste_quantity is null) as waste_quantity_null,
	count(*) filter (where waste_reason is null) as waste_reason_null,
	count(*) filter (where donation_made is null) as donation_made_null,
	count(*) filter (where waste_level is null) as waste_level_null
	from food_waste;
	

--updating the null values--
update food_waste
set
    shelf_life_days = coalesce(
        shelf_life_days,
        (select percentile_cont(0.5)
         within group (order by shelf_life_days)
         from food_waste)
    ),
    storage_temperature = coalesce(
        storage_temperature,
        (select percentile_cont(0.5)
         within group (order by storage_temperature)
         from food_waste)
    ),
    daily_demand = coalesce(
        daily_demand,
        (select percentile_cont(0.5)
         within group (order by daily_demand)
         from food_waste)
    ),
    weather = coalesce(weather, 'Unknown'),
    donation_made = coalesce(donation_made, 'Unknown')
where
    shelf_life_days is null
    or storage_temperature is null
    or daily_demand is null
    or weather is null
    or donation_made is null;
	

--cheking duplicate record--
select
     inventory_id,
	 count(*) as duplicate_record
from food_waste
group by inventory_id
having count(*)>1


--checking Inconsistent categories--
select 'business_type' as column_name, business_type as value, count(*) as count
from food_waste
group by business_type

union all

select 'food_category', food_category, count(*)
from food_waste
group by food_category

union all

select 'waste_reason', waste_reason, count(*)
from food_waste
group by waste_reason

union all

select 'weather', weather, count(*)
from food_waste
group by weather

union all

select 'promotion', promotion, count(*)
from food_waste
group by promotion

union all

select 'donation_made', donation_made, count(*)
from food_waste
group by donation_made

order by column_name, value;
select 'food_category' as column_name, food_category as value, count(*) as count
from food_waste
group by food_category

union all

select 'waste_reason', waste_reason, count(*)
from food_waste
group by waste_reason

union all

select 'weather', weather, count(*)
from food_waste
group by weather

union all

select 'promotion', promotion, count(*)
from food_waste
group by promotion

union all

select 'donation_made', donation_made, count(*)
from food_waste
group by donation_made

order by column_name, value;

--check invalid values--
select 'purchase_quantity' as column_name, count(*) as invalid_count
from food_waste
where purchase_quantity < 0

union all

select 'units_sold', count(*)
from food_waste
where units_sold < 0

union all

select 'remaining_stock', count(*)
from food_waste
where remaining_stock < 0

union all

select 'shelf_life_days', count(*)
from food_waste
where shelf_life_days < 0

union all

select 'daily_demand', count(*)
from food_waste
where daily_demand < 0

union all

select 'waste_quantity', count(*)
from food_waste
where waste_quantity < 0

union all

select 'storage_temperature', count(*)
from food_waste
where storage_temperature < 0;


--Check the temperature distribution--
select
    storage_temperature,
    count(*) as record_count
from food_waste
where storage_temperature < 0
group by storage_temperature
order by storage_temperature;


--Check the complete temperature range--
select
    min(storage_temperature) as minimum_temperature,
    max(storage_temperature) as maximum_temperature,
    avg(storage_temperature) as average_temperature
from food_waste;


--Check the date range--
select
    min(order_date) as earliest_date,
    max(order_date) as latest_date,
    count(*) as total_records
from food_waste;


--Check NULL dates--
select count(*) as null_dates
from food_waste
where order_date is null;


--Check duplicate dates and date distribution--
select
    order_date,
    count(*) as record_count
from food_waste
group by order_date
order by order_date;
