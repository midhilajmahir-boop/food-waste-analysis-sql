--FOOD WASTE MANAGEMENT ANALYSIS--


--table craetion --
create table food_waste (
    inventory_id varchar(20) primary key,
    order_date date not null,
    business_type varchar(100) not null,
    food_category varchar(100) not null,
    purchase_quantity integer not null check (purchase_quantity >= 0),
    units_sold integer not null check (units_sold >= 0),
    remaining_stock integer not null check (remaining_stock >= 0),
    shelf_life_days integer check (shelf_life_days >= 0),
    storage_temperature decimal(5,2),
    daily_demand integer check (daily_demand >= 0),
    promotion varchar(10),
    weather varchar(50),
    waste_quantity integer not null check (waste_quantity >= 0),
    waste_reason varchar(100),
    donation_made varchar(10),
    waste_level varchar(20)
);


--Check total records--
select count(*)
from food_waste;


--Table structure verification--
select *
from information_schema.columns
where table_name = 'food_waste'
and table_schema = 'public'
order by ordinal_position;

--Verify Constraints--
select
    conname,
    contype,
    pg_get_constraintdef(oid) as constraint_definition
from pg_constraint
where conrelid = 'public.food_waste'::regclass;


--Database Normalization--
-- cheking 1NF--

select
    food_category,
    count(distinct shelf_life_days) as shelf_life_variations
from food_waste
group by food_category
order by shelf_life_variations desc;


--cheking 2NF--

select
    business_type,
    count(distinct weather) as weather_variations
from food_waste
group by business_type
order by weather_variations desc;


--checking 3NF--
select
    food_category,
    count(distinct waste_reason) as waste_reason_variations
from food_waste
group by food_category
order by waste_reason_variations desc;