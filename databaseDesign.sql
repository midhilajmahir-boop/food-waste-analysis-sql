--FOOD WASTE MANAGEMENT ANALYSIS--


--table craetion --
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


-- create weather dimension table

CREATE TABLE dim_weather (
    weather_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    weather_name VARCHAR(50) UNIQUE NOT NULL
);

-- insert unique weather values

INSERT INTO dim_weather (weather_name)
SELECT DISTINCT
    TRIM(weather)
FROM food_waste
WHERE weather IS NOT NULL;

-- verify weather dimension

SELECT *
FROM dim_weather
ORDER BY weather_id;

-- create business dimension table

CREATE TABLE dim_business (
    business_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    business_type VARCHAR(100) UNIQUE NOT NULL
);

-- insert unique business types

INSERT INTO dim_business (business_type)
SELECT DISTINCT
    TRIM(business_type)
FROM food_waste
WHERE business_type IS NOT NULL;

-- verify business dimension

SELECT *
FROM dim_business
ORDER BY business_id;

-- create food category dimension table

CREATE TABLE dim_food_category (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    food_category VARCHAR(100) UNIQUE NOT NULL
);

-- insert unique food categories

INSERT INTO dim_food_category (food_category)
SELECT DISTINCT
    TRIM(food_category)
FROM food_waste
WHERE food_category IS NOT NULL;

-- verify food category dimension

SELECT *
FROM dim_food_category
ORDER BY category_id;

-- create waste reason dimension table

CREATE TABLE dim_waste_reason (
    waste_reason_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    waste_reason VARCHAR(150) UNIQUE NOT NULL
);

-- insert unique waste reasons

INSERT INTO dim_waste_reason (waste_reason)
SELECT DISTINCT
    TRIM(waste_reason)
FROM food_waste
WHERE waste_reason IS NOT NULL;

-- verify waste reason dimension

SELECT *
FROM dim_waste_reason
ORDER BY waste_reason_id;

-- create promotion dimension table

CREATE TABLE dim_promotion (
    promotion_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    promotion_status VARCHAR(50) UNIQUE NOT NULL
);

-- insert unique promotion values

INSERT INTO dim_promotion (promotion_status)
SELECT DISTINCT
    TRIM(promotion)
FROM food_waste
WHERE promotion IS NOT NULL;

-- create donation dimension table

CREATE TABLE dim_donation (
    donation_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    donation_status VARCHAR(50) UNIQUE NOT NULL
);

-- insert unique donation values

INSERT INTO dim_donation (donation_status)
SELECT DISTINCT
    TRIM(donation_made)
FROM food_waste
WHERE donation_made IS NOT NULL;

-- create waste level dimension table

CREATE TABLE dim_waste_level (
    waste_level_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    waste_level VARCHAR(50) UNIQUE NOT NULL
);

-- insert unique waste levels

INSERT INTO dim_waste_level (waste_level)
SELECT DISTINCT
    TRIM(waste_level)
FROM food_waste
WHERE waste_level IS NOT NULL;

-- create date dimension table

CREATE TABLE dim_date (
    date_id INTEGER PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    day_number INTEGER NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    month_number INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter_number INTEGER NOT NULL,
    year_number INTEGER NOT NULL,
    week_number INTEGER NOT NULL
);

-- insert date records

INSERT INTO dim_date (
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
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER,
    d,
    EXTRACT(DAY FROM d)::INTEGER,
    TRIM(TO_CHAR(d, 'Day')),
    EXTRACT(MONTH FROM d)::INTEGER,
    TRIM(TO_CHAR(d, 'Month')),
    EXTRACT(QUARTER FROM d)::INTEGER,
    EXTRACT(YEAR FROM d)::INTEGER,
    EXTRACT(WEEK FROM d)::INTEGER
FROM GENERATE_SERIES(
    (SELECT MIN(order_date) FROM food_waste),
    (SELECT MAX(order_date) FROM food_waste),
    INTERVAL '1 day'
) AS dates(d);

-- verify dimension tables

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN (
    'dim_date',
    'dim_business',
    'dim_food_category',
    'dim_waste_reason',
    'dim_weather',
    'dim_promotion',
    'dim_donation',
    'dim_waste_level'
)
ORDER BY table_name;



DROP TABLE IF EXISTS food_waste;