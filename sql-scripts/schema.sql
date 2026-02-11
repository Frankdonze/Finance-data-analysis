--drop table if exists raw_company_info;
drop table if exists raw_market_data;
--drop table if exists companies;
drop table if exists market_data;
--drop table if exists eod_market_data;

create table raw_company_info (
	id serial primary key,
	symbol varchar(5),
	payload TEXT,
	ingested_date date
);

create table raw_market_data (
	id serial primary key,
	symbol varchar(5),
	payload TEXT,
	ingested_date date
);

create table companies (
	id serial primary key,
	companyName varchar(30),
	symbol varchar(5),
	sector varchar(28),
	industry varchar(30),
	country varchar(30),
	exchange varchar(20),
	currency varchar(10),
	ceo varchar(30),
	fullTimeEmployees integer
);

create table market_data (
	id serial primary key,
	symbol varchar(5),
	price numeric(12, 2),
	marketCap numeric(20,4),
	volume integer,
	changePercentage numeric(6,3),
	isActivelyTrading boolean
);

create table eod_market_data (
	id serial primary key,
	symbol varchar(5),
	date date,
	price numeric(12,2),
	volume integer
);

