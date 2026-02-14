--pulling price data from 1/28/2026
select symbol, date, price from eod_market_data where eod_market_data.date =  '2026-01-28';

--pulling price for Apple every day passed 2026-01-20
select symbol, date, price from eod_market_data where symbol = 'AAPL' and date >= '2026-01-20';

-- using window function to get todays price and previous days price side by side for AAPL
select symbol, date, price, lag(price) over(order by date) as previous_days_price from eod_market_data where symbol = 'AAPL' and date >= '2026-01-25';

--get difference of AAPL EOD stock price every day
select symbol, date, price - lag(price) over(order by date) as priceDifference from eod_market_data where symbol = 'AAPL' and date >= '2026-01-25';

--average difference over a period of time
with DailyDifferences as( select symbol, date, price - lag(price) over(order by date) as priceDiff from eod_market_data where symbol = 'AAPL' and date > '2026-01-25') select avg(priceDiff) from DailyDifferences;
