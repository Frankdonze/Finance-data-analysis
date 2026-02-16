Stock Market Analysis Data Pipeline and Analysis

Data Engineering

Overview

This project is an end-to-end cloud-based data engineering pipeline for analyzing stock market data. It ingests raw stock market data, cleans, and enables SQL-based analysis and dashboarding.

The focus is on building a pipeline that demonstrates core data engineering skills, including cloud infrastructure, ETL pipelines, data modeling, and analytical workflows.

Key Questions

Which company had the highest total return over 1 year? 3 years? 5 years?

Which stock recovered fastest after market downturns?

Which stock has the highest price volatility?

If $10,000 were invested equally in all four, what would the portfolio value be today?

Architecture

- Data from public financial API
- Amazon S3 (Bronze – Raw Data)
- Python ETL (EC2/lambda) - first iteration on EC2 / Now developing automated version with eventbright and lambda function
- Amazon S3 (Silver – Cleaned)
- Amazon RDS (PostgreSQL – Gold Analytics Layer)
- SQL Queries
- Power BI Dashboards

Data Layers
Bronze (Raw)

Original financial transaction files (json)

Stored in Amazon S3

Immutable and preserved for reprocessing

Silver (Cleaned)

Parsed and split api calls into seperate json files to organise for different tables in Database

Gold (Analytics)

Curated relational tables in PostgreSQL

Optimized for SQL queries and BI tools

Technologies Used

Cloud: AWS (S3, EC2, RDS, IAM, lambda, eventbright)

Infrastructure as Code: Terraform

ETL / Processing: Python

Storage Format: json

Database: PostgreSQL (Amazon RDS)

Analytics: SQL

Visualization: Power BI

Version Control: Git & GitHub

ETL Workflow

pull json data from api

write api calls to json files and place in  Amazon S3 (Bronze)

Process data with Python:

organized data into seperate json files correlating to tables in DB

Write cleaned data to Amazon S3 (Silver)

Load analytics-ready tables into PostgreSQL (Gold)

Analytics & Insights

Example analyses include:

avg daily price change weekly, monthly, yearly

7 day moving average price

Average daily volume over a period

trading volume spikes

mock investments and returns

Insights are queried using SQL and visualized using Power BI dashboards.

Infrastructure

All cloud infrastructure for this project is provisioned using Terraform and deployed on AWS.
