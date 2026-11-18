-- IPO Valuation & Listing Performance | SQLite
-- Table: ipo (loaded from ipo_data.csv). Derived columns are computed in view v.

DROP VIEW IF EXISTS v;
CREATE VIEW v AS
SELECT *,
  ROUND((listing_open  / issue_price - 1) * 100, 2) AS gain_open_pct,
  ROUND((listing_close / issue_price - 1) * 100, 2) AS gain_close_pct,
  substr(listing_date, 1, 7) AS listing_month,
  CASE WHEN total_x < 10 THEN '1. <10x'
       WHEN total_x < 50 THEN '2. 10-50x'
       WHEN total_x < 100 THEN '3. 50-100x'
       ELSE '4. 100x+' END AS sub_bucket,
  CASE WHEN issue_size_cr < 500 THEN '1. <500 Cr'
       WHEN issue_size_cr < 1500 THEN '2. 500-1500 Cr'
       ELSE '3. 1500+ Cr' END AS size_bucket
FROM ipo;

-- Q1. Month-wise: IPO count, avg listing-day gain, avg return till date
SELECT listing_month, COUNT(*) AS n_ipos,
       ROUND(AVG(gain_close_pct),1) AS avg_listing_gain_pct,
       ROUND(AVG(gain_till_date_pct),1) AS avg_till_date_pct
FROM v GROUP BY listing_month ORDER BY listing_month;

-- Q2. Subscription bucket vs listing gain
SELECT sub_bucket, COUNT(*) AS n_ipos,
       ROUND(AVG(gain_close_pct),1) AS avg_listing_gain_pct,
       ROUND(100.0 * SUM(gain_close_pct > 0) / COUNT(*),0) AS pct_positive_listing,
       ROUND(AVG(gain_till_date_pct),1) AS avg_till_date_pct
FROM v GROUP BY sub_bucket ORDER BY sub_bucket;

-- Q3. Issue-size bucket vs performance
SELECT size_bucket, COUNT(*) AS n_ipos,
       ROUND(AVG(gain_close_pct),1) AS avg_listing_gain_pct,
       ROUND(AVG(total_x),1) AS avg_subscription_x,
       ROUND(AVG(gain_till_date_pct),1) AS avg_till_date_pct
FROM v GROUP BY size_bucket ORDER BY size_bucket;

-- Q4. Top 5 and bottom 5 by listing-day close gain
SELECT * FROM (SELECT company, total_x, gain_close_pct, gain_till_date_pct FROM v ORDER BY gain_close_pct DESC LIMIT 5)
UNION ALL
SELECT * FROM (SELECT company, total_x, gain_close_pct, gain_till_date_pct FROM v ORDER BY gain_close_pct ASC LIMIT 5);

-- Q5. Did the day-1 pop last?
SELECT CASE WHEN gain_close_pct > 0 THEN 'Closed above issue price on day 1' ELSE 'Closed at/below issue price on day 1' END AS day1_outcome,
       COUNT(*) AS n_ipos,
       ROUND(AVG(gain_till_date_pct),1) AS avg_till_date_pct,
       ROUND(100.0 * SUM(gain_till_date_pct > 0) / COUNT(*),0) AS pct_still_in_profit
FROM v GROUP BY day1_outcome;

-- Q6. QIB demand vs retail demand
SELECT CASE WHEN qib_x >= 50 THEN 'QIB >= 50x' ELSE 'QIB < 50x' END AS qib_group,
       CASE WHEN retail_x >= 10 THEN 'Retail >= 10x' ELSE 'Retail < 10x' END AS retail_group,
       COUNT(*) AS n_ipos,
       ROUND(AVG(gain_close_pct),1) AS avg_listing_gain_pct,
       ROUND(AVG(gain_till_date_pct),1) AS avg_till_date_pct
FROM v GROUP BY qib_group, retail_group ORDER BY qib_group, retail_group;
