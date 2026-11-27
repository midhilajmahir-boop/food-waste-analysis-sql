# Food Waste Management Analysis Using SQL

## Project Overview

Food waste is a major challenge for restaurants, supermarkets, cloud kitchens, and cafeterias. Poor inventory management, overproduction, low demand, and storage issues can lead to significant food waste.

This project uses **PostgreSQL** to analyze food waste data, identify waste patterns, evaluate business performance, and generate insights that can help businesses reduce food waste.

## Project Objectives

- Analyze food waste across different business types.
- Identify food categories with the highest waste.
- Understand the major reasons for food waste.
- Analyze monthly food waste trends.
- Calculate overall food waste percentage.
- Evaluate waste patterns based on product shelf life.
- Analyze donation-related data.
- Generate business insights using SQL queries.

## Tools & Technologies

- PostgreSQL
- pgAdmin 4
- SQL
- GitHub

## Dataset Description

The dataset contains food inventory and waste information.

Important columns include:

- `inventory_id`
- `order_date`
- `business_type`
- `food_category`
- `purchase_quantity`
- `units_sold`
- `remaining_stock`
- `shelf_life_days`
- `storage_temperature`
- `daily_demand`
- `promotion`
- `weather`
- `waste_quantity`
- `waste_reason`
- `donation_made`
- `waste_level`

## SQL Concepts Used

This project demonstrates the following SQL concepts:

- SELECT and WHERE
- Aggregate Functions
- GROUP BY and HAVING
- ORDER BY
- CASE Statements
- COALESCE and NULLIF
- Subqueries
- Common Table Expressions (CTEs)
- JOIN Operations
- Window Functions
- Date Functions
- Data Cleaning
- Database Constraints
- Database Normalization
- Views
- KPI Calculations

## Business Questions

The project addresses 10 business questions:

1. Which business type generates the highest total food waste?
2. Which food category contributes the most to total waste?
3. What are the most common reasons for food waste?
4. Which month records the highest food waste?
5. What is the overall food waste percentage?
6. Which business type has the highest average food waste?
7. How does shelf life affect average food waste?
8. Which food categories have waste above the average category waste?
9. How much food waste is associated with donations across business types?
10. What is the ranking of food categories based on their contribution to total waste?

## Key Performance Indicators (KPIs)

| KPI | Result |
|---|---:|
| Total Purchase Quantity | 946,310 |
| Total Waste Quantity | 46,179 |
| Overall Waste Percentage | 4.88% |

*Donation-related metrics are calculated using the `donation_made` flag and should be interpreted as an estimate based on that dataset field.*

## Key Findings

### 1. Business Type Analysis

Supermarkets recorded the highest total food waste, followed by restaurants, cloud kitchens, and cafeterias.

### 2. Food Category Analysis

Prepared Food contributed the highest total waste, with 13,362 units.

Dairy recorded the lowest total waste, with 5,301 units.

### 3. Waste Reason Analysis

Among the actual waste reasons, overproduction was the most common, followed by expired products, low demand, and storage issues.

### 4. Monthly Analysis

October recorded the highest monthly food waste, with 4,580 units.

June recorded the lowest, with 2,961 units.

### 5. Shelf Life Analysis

Products with short shelf life recorded the highest average waste compared with medium- and long-shelf-life products.

## Project Deliverables

- SQL database analysis
- Data cleaning and profiling
- Database structure and normalization checks
- Business question analysis
- KPI calculations
- SQL views
- ER diagram
- Final project report

## Conclusion

This project demonstrates how SQL can be used to analyze food waste data and identify important business patterns.

The analysis highlights supermarkets and prepared food as major contributors to total waste. It also identifies overproduction as the leading actual waste reason.

These insights can help businesses improve inventory planning, manage product shelf life, and make better decisions to reduce food waste.

---

**Project Domain:** Food Waste Management  
**Database:** PostgreSQL  
**Project Type:** SQL Data Analysis