select * from portofolio.order
order by row_id;

select * from portofolio.customer
order by row_id;

-- 1. Tiga Produk Terlaris Berdasarkan Quantity
SELECT c.product_name
, SUM(o.quantity) AS total_penjualan
FROM portofolio.order o 
JOIN portofolio.customer c ON o.row_id = c.row_id
GROUP BY c.product_name ORDER BY total_penjualan DESC LIMIT 3;

-- 2. Top 3 country berdasarkan jumlah pesanan
SELECT c.country
, count(distinct order_id) AS total_pesanan
FROM portofolio.order o 
JOIN portofolio.customer c ON o.row_id = c.row_id
GROUP BY c.country ORDER BY total_pesanan DESC LIMIT 3;

-- 3. Tiga customer dengan rerata nilai transaksi Tertinggi (AOV)
SELECT c.customer_name
, SUM(o.sales) AS total_sales
, COUNT(DISTINCT order_id) AS total_order
, round(SUM(o.sales)/COUNT(DISTINCT order_id), 2) AS rerata_order_value
FROM portofolio.order o
JOIN portofolio.customer c ON o.row_id = c.row_id
GROUP BY c.customer_name ORDER BY rerata_order_value DESC LIMIT 3;

-- 4. Category product dengan Total Profit Margin Tertinggi
SELECT c.category
, ROUND(SUM(o.profit)/NULLIF(SUM(o.sales), 0), 4) AS profit_margin_total
FROM portofolio.order o
JOIN portofolio.customer c ON o.row_id = c.row_id
GROUP BY c.category ORDER BY profit_margin_total DESC;

-- 5. Analisis rata-rata waktu pengiriman per order priority (hari)
SELECT o.order_priority
, CONCAT (ROUND(AVG(DATE_PART('day', o.ship_date::timestamp - o.order_date::timestamp))::numeric, 2), ' hari')
AS rerata_pengiriman
FROM portofolio.order o
GROUP BY o.order_priority ORDER BY rerata_pengiriman;

-- 6. RFM Analysis Dasar per Customer
WITH rfm AS 
(
  SELECT c.customer_name
  , MAX(o.order_date) AS last_order_date
  , COUNT(DISTINCT o.order_id) AS frequency
  , SUM(o.sales) AS monetary
  FROM portofolio.order o
  JOIN portofolio.customer c ON o.row_id = c.row_id
  GROUP BY c.customer_name
)
SELECT customer_name
, (CURRENT_DATE - last_order_date) 
AS recency
, frequency
, monetary
FROM rfm ORDER BY monetary DESC;