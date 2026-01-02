# COROS Training & Recovery Analysis (Data Engineering MVP)

## Overview

This project analyzes running activity data collected from a COROS watch to understand how work schedule (day shift vs night shift) impacts training performance and recovery.

The goal is to build an end-to-end, cloud-based data pipeline that ingests raw activity files, cleans and structures the data, stores it in analytics-ready formats, and answers real-world performance questions using SQL and dashboards.

This project focuses on a **minimum viable product (MVP)** emphasizing data engineering, cloud infrastructure, and analytical workflows.

---

## Research Questions

1. How does night shift training affect running performance and recovery compared to a regular day schedule?
2. How does training volume (e.g., mileage or intensity) impact next-day performance?
3. How has overall running fitness changed over time?

---

## Architecture

The project follows a layered data architecture to separate raw ingestion, cleaning, and analytics:

COROS TSX Files  
→ Amazon S3 (Bronze – Raw Data)  
→ Python ETL (EC2) 
→ Amazon S3 (Silver – Cleaned Parquet)  
→ Amazon RDS (PostgreSQL – Gold Analytics Layer)  
→ SQL Queries  
→ PowerBI Dashboard

---

## Data Layers

### Bronze (Raw)
- Original COROS `.tsx` activity files
- Stored in Amazon S3
- Immutable and preserved for reprocessing

### Silver (Cleaned)
- Parsed and cleaned activity data
- Stored in Amazon S3 using **Parquet** format
- Standardized schema and timestamps

### Gold (Analytics)
- Curated relational tables in PostgreSQL
- Optimized for SQL queries and dashboards

---

## Technologies Used

- **Cloud:** AWS (EC2, S3, RDS, IAM)
- **Infrastructure as Code:** Terraform
- **ETL / Processing:** Python (pandas, pyarrow)
- **Storage Format:** Parquet
- **Database:** PostgreSQL (AWS RDS)
- **Analytics:** SQL
- **Visualization:** PowerBI
- **Version Control:** Git & GitHub

---

## ETL Process

1. Upload raw COROS `.tsx` files to Amazon S3 (Bronze)
2. Parse and clean data using Python:
   - Normalize timestamps
   - Extract distance, pace, and heart rate metrics
   - Label training periods (day shift vs night shift)
3. Write cleaned data to Amazon S3 as Parquet (Silver)
4. Load curated tables into PostgreSQL (Gold)

---

## Analytics & Insights

Example analyses include:
- Performance and recovery comparison between night shift and day shift periods
- Relationship between training volume and next-day running performance
- Long-term trends in fitness indicators over time

These analyses are exposed through SQL queries and visualized using PowerBI dashboards.

---

## Infrastructure

All cloud infrastructure for this project is provisioned using **Terraform** and deployed on **AWS**.

### AWS Resources

- **Amazon S3**
  - Stores raw COROS `.tsx` files (Bronze layer)
  - Stores cleaned, analytics-ready Parquet files (Silver layer)

- **Amazon RDS (PostgreSQL)**
  - Serves as the relational analytics database (Gold layer)
  - Optimized for SQL queries and dashboard consumption

- **IAM Roles & Policies**
  - Secure access between S3, ETL processes, and the database
  - No credentials are hard-coded or stored in the repository

### Infrastructure as Code

Terraform configuration files are stored in the `infra/` directory and define:
- S3 buckets
- RDS instance
- IAM roles and permissions

Terraform state files and credentials are excluded from version control to ensure security.

This approach ensures the infrastructure is **reproducible, auditable, and environment-agnostic**.

---

## Project Status

**Current Phase:** MVP  
- Core data pipeline implemented
- Initial SQL analyses and dashboards completed

**Planned Enhancements:**
- Machine learning models for fatigue or performance prediction
- Anomaly detection for recovery metrics
- Natural language querying using LLMs

---

## Disclaimer

This project uses personal fitness data for educational and portfolio purposes only.

