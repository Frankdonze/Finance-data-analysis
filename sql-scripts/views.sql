create view amzn_dailyprice_difference as (select symbol, date, price - lag(price) over(order by date) as priceDifference from eod_market_data where symbol = 'AMZN');

create view tsla_dailyprice_difference as (select symbol, date, price - lag(price) over(order by date) as priceDifference from eod_market_data where symbol = 'TSLA');

create view aapl_dailyprice_difference as (select symbol, date, price - lag(price) over(order by date) as priceDifference from eod_market_data where symbol = 'AAPL');

create view NVDA_dailyprice_difference as (select symbol, date, price - lag(price) over(order by date) as priceDifference from eod_market_data where symbol = 'NVDA');
