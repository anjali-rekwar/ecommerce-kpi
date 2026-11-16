-- 1. Core KPIs
SELECT ROUND(SUM(Revenue),2) AS revenue,
       COUNT(DISTINCT InvoiceNo) AS orders,
       ROUND(SUM(Revenue)/COUNT(DISTINCT InvoiceNo),2) AS aov,
       COUNT(DISTINCT CustomerID) AS customers
FROM sales;

-- 2. Top 10 products
SELECT Description, SUM(Quantity) AS units, ROUND(SUM(Revenue),2) AS revenue
FROM sales GROUP BY Description ORDER BY revenue DESC LIMIT 10;

-- 3. Monthly trend with month-over-month growth
WITH m AS (
  SELECT strftime('%Y-%m', InvoiceDate) AS month, SUM(Revenue) AS revenue
  FROM sales GROUP BY 1)
SELECT month, ROUND(revenue,2) AS revenue,
       ROUND(100.0*(revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 2) AS mom_pct
FROM m;

-- 4. Revenue by country with share
SELECT Country, ROUND(SUM(Revenue),2) AS revenue,
       ROUND(100.0*SUM(Revenue)/(SELECT SUM(Revenue) FROM sales),2) AS pct
FROM sales GROUP BY Country ORDER BY revenue DESC;

-- 5. Repeat vs one-time customers
SELECT CASE WHEN n=1 THEN 'One-time' ELSE 'Repeat' END AS type, COUNT(*) AS customers
FROM (SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS n FROM sales
      WHERE CustomerID IS NOT NULL GROUP BY CustomerID) GROUP BY 1;