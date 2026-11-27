-- food waste management analysis --

-- table creation --
-- create fact table

create table fact_food_waste (
    inventory_id varchar(20) primary key,

    date_id integer not null,
    business_id integer not null,
    category_id integer not null,
    waste_reason_id integer not null,
    weather_id integer not null,
    promotion_id integer not null,
    donation_id integer not null,
    waste_level_id integer not null,

    purchase_quantity integer not null,
    units_sold integer not null,
    remaining_stock integer not null,
    shelf_life_days integer,
    storage_temperature decimal(5,2),
    daily_demand integer,
    waste_quantity integer not null,

    constraint fk_date
        foreign key (date_id)
        references dim_date(date_id),

    constraint fk_business
        foreign key (business_id)
        references dim_business(business_id),

    constraint fk_category
        foreign key (category_id)
        references dim_food_category(category_id),

    constraint fk_waste_reason
        foreign key (waste_reason_id)
        references dim_waste_reason(waste_reason_id),

    constraint fk_weather
        foreign key (weather_id)
        references dim_weather(weather_id),

    constraint fk_promotion
        foreign key (promotion_id)
        references dim_promotion(promotion_id),

    constraint fk_donation
        foreign key (donation_id)
        references dim_donation(donation_id),

    constraint fk_waste_level
        foreign key (waste_level_id)
        references dim_waste_level(waste_level_id)
);

-- check total records

select count(*)
from food_waste;

-- table structure verification

select *
from information_schema.columns
where table_name = 'food_waste'
and table_schema = 'public'
order by ordinal_position;

-- verify constraints

select
    conname,
    contype,
    pg_get_constraintdef(oid) as constraint_definition
from pg_constraint
where conrelid = 'public.food_waste'::regclass;

-- create weather dimension table

create table dim_weather (
    weather_id integer generated always as identity primary key,
    weather_name varchar(50) unique not null
);

-- insert unique weather values

insert into dim_weather (weather_name)
select distinct
    trim(weather)
from food_waste
where weather is not null;

-- verify weather dimension

select *
from dim_weather
order by weather_id;

-- create business dimension table

create table dim_business (
    business_id integer generated always as identity primary key,
    business_type varchar(100) unique not null
);

-- insert unique business types

insert into dim_business (business_type)
select distinct
    trim(business_type)
from food_waste
where business_type is not null;

-- verify business dimension

select *
from dim_business
order by business_id;

-- create food category dimension table

create table dim_food_category (
    category_id integer generated always as identity primary key,
    food_category varchar(100) unique not null
);

-- insert unique food categories

insert into dim_food_category (food_category)
select distinct
    trim(food_category)
from food_waste
where food_category is not null;

-- verify food category dimension

select *
from dim_food_category
order by category_id;

-- create waste reason dimension table

create table dim_waste_reason (
    waste_reason_id integer generated always as identity primary key,
    waste_reason varchar(150) unique not null
);

-- insert unique waste reasons

insert into dim_waste_reason (waste_reason)
select distinct
    trim(waste_reason)
from food_waste
where waste_reason is not null;

-- verify waste reason dimension

select *
from dim_waste_reason
order by waste_reason_id;

-- create promotion dimension table

create table dim_promotion (
    promotion_id integer generated always as identity primary key,
    promotion_status varchar(50) unique not null
);

-- insert unique promotion values

insert into dim_promotion (promotion_status)
select distinct
    trim(promotion)
from food_waste
where promotion is not null;

-- create donation dimension table

create table dim_donation (
    donation_id integer generated always as identity primary key,
    donation_status varchar(50) unique not null
);

-- insert unique donation values

insert into dim_donation (donation_status)
select distinct
    trim(donation_made)
from food_waste
where donation_made is not null;

-- create waste level dimension table

create table dim_waste_level (
    waste_level_id integer generated always as identity primary key,
    waste_level varchar(50) unique not null
);

-- insert unique waste levels

insert into dim_waste_level (waste_level)
select distinct
    trim(waste_level)
from food_waste
where waste_level is not null;

-- create date dimension table

create table dim_date (
    date_id integer primary key,
    full_date date unique not null,
    day_number integer not null,
    day_name varchar(20) not null,
    month_number integer not null,
    month_name varchar(20) not null,
    quarter_number integer not null,
    year_number integer not null,
    week_number integer not null
);

-- insert date records

insert into dim_date (
    date_id,
    full_date,
    day_number,
    day_name,
    month_number,
    month_name,
    quarter_number,
    year_number,
    week_number
)
select
    to_char(d, 'yyyymmdd')::integer,
    d,
    extract(day from d)::integer,
    trim(to_char(d, 'day')),
    extract(month from d)::integer,
    trim(to_char(d, 'month')),
    extract(quarter from d)::integer,
    extract(year from d)::integer,
    extract(week from d)::integer
from generate_series(
    (select min(order_date) from food_waste),
    (select max(order_date) from food_waste),
    interval '1 day'
) as dates(d);

-- verify dimension tables

select table_name
from information_schema.tables
where table_schema = 'public'
and table_name in (
    'dim_date',
    'dim_business',
    'dim_food_category',
    'dim_waste_reason',
    'dim_weather',
    'dim_promotion',
    'dim_donation',
    'dim_waste_level'
)
order by table_name;

