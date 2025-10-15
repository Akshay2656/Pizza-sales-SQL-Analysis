# 🍕 Pizza-sales-SQL-Analysis

📘 Project Overview

The Pizza Sales Report is an end-to-end SQL analysis project designed to explore and understand sales performance using raw transactional data.
The goal of this project is to extract key business insights from the pizza sales dataset using only SQL queries.


🗂️ Dataset Description

The dataset used for this project is named pizza_sales, which contains detailed transaction-level data of pizza orders.

| Column Name           | Description                                                     |
| --------------------- | --------------------------------------------------------------- |
| **pizza_id**          | Unique identifier for each pizza type                           |
| **order_id**          | Unique identifier for each customer order                       |
| **pizza_name_id**     | Combined name ID used for linking pizza details                 |
| **quantity**          | Number of pizzas ordered in each record                         |
| **order_date**        | Date on which the order was placed                              |
| **order_time**        | Time of the order (used for hourly trend analysis)              |
| **unit_price**        | Price of a single pizza                                         |
| **total_price**       | Total amount for that order line (quantity × unit_price)        |
| **pizza_size**        | Size of the pizza (S, M, L, XL, XXL)                            |
| **pizza_category**    | Category of the pizza (Classic, Supreme, Veggie, Chicken, etc.) |
| **pizza_ingredients** | List of ingredients used in the pizza                           |
| **pizza_name**        | Actual name of the pizza                                        |

