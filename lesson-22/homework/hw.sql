SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS running_total
FROM sales_data;
-----------------------------------------------------------------------------
SELECT
    product_category,
    COUNT(*) AS order_count
FROM sales_data
GROUP BY product_category;
----------------------------------------------------------------------------
SELECT
    product_category,
    MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category;
--------------------------------------------------------------------------------
SELECT
    product_category,
    MIN(unit_price) AS min_unit_price
FROM sales_data
GROUP BY product_category;
------------------------------------------------------------------------------------
SELECT
    order_date,
    AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg_sales
FROM sales_data;
---------------------------------------------------------------------------------
SELECT
    region,
    SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region;
-------------------------------------------------------------------------------------
SELECT
    customer_id,
    customer_name,
    SUM(total_amount) AS total_purchase,
    RANK() OVER (
        ORDER BY SUM(total_amount) DESC
    ) AS purchase_rank
FROM sales_data
GROUP BY customer_id, customer_name;
-------------------------------------------------------------------------------------------------------
SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    total_amount - LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS amount_diff
FROM sales_data;
--------------------------------------------------------------------------------------------
SELECT *
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY product_category
               ORDER BY unit_price DESC
           ) AS price_rank
    FROM sales_data
) ranked
WHERE price_rank <= 3;
--------------------------------------------------------------------------------------
SELECT
    region,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY region
        ORDER BY order_date
    ) AS cumulative_sales
FROM sales_data;
---------------------------------------------------------------------------------------
SELECT
    product_category,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date
    ) AS cumulative_revenue
FROM sales_data;
------------------------------------------------------------------------------------------
SELECT
    ID,
    SUM(ID) OVER (ORDER BY ID) AS SumPreValues
FROM EmployeesID;
------------------------------------------------------------------------------------------
SELECT
    Value,
    Value + COALESCE(LAG(Value) OVER (ORDER BY (SELECT NULL)), 0) AS "Sum of Previous"
FROM OneColumn;
-----------------------------------------------------------------------------------------------------------
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT product_category) AS category_count
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;
---------------------------------------------------------------------------------------------------
SELECT
    customer_id,
    customer_name,
    region,
    SUM(total_amount) AS customer_total,
    region_avg
FROM (
    SELECT *,
           AVG(total_amount) OVER (PARTITION BY region) AS region_avg
    FROM sales_data
) AS sd
GROUP BY customer_id, customer_name, region, region_avg
HAVING SUM(total_amount) > region_avg;
-----------------------------------------------------------------------------------------------------
SELECT
    customer_id,
    customer_name,
    region,
    SUM(total_amount) AS total_spent,
    RANK() OVER (
        PARTITION BY region
        ORDER BY SUM(total_amount) DESC
    ) AS region_rank
FROM sales_data
GROUP BY customer_id, customer_name, region;
-------------------------------------------------------------------------------------------
SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS cumulative_sales
FROM sales_data;
---------------------------------------------------------------------------------------
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS monthly_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)) AS prev_month_sales,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date))) * 100.0 /
        NULLIF(LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', order_date)), 0),
        2
    ) AS growth_rate_percent
FROM sales_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
-------------------------------------------------------------------------------------------------------------
SELECT *
FROM (
    SELECT
        customer_id,
        customer_name,
        order_date,
        total_amount,
        LAG(total_amount) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_amount
    FROM sales_data
) AS sub
WHERE total_amount > COALESCE(previous_order_amount, 0);
-----------------------------------------------------------------------------------------------
SELECT
    product_name,
    unit_price
FROM sales_data
WHERE unit_price > (
    SELECT AVG(unit_price) FROM sales_data
);
-------------------------------------------------------------------------------------------
SELECT
    Id,
    Grp,
    Val1,
    Val2,
    CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS GroupSum
FROM MyData;
------------------------------------------------------------------------------------------
SELECT
    ID,
    SUM(Cost) AS TotalCost,
    SUM(DISTINCT Quantity) AS TotalQuantity
FROM TheSumPuzzle
GROUP BY ID;
------------------------------------------------------------------------------------------------
WITH OrderedSeats AS (
    SELECT
        SeatNumber,
        LEAD(SeatNumber) OVER (ORDER BY SeatNumber) AS NextSeat
    FROM Seats
),
Gaps AS (
    SELECT
        SeatNumber + 1 AS GapStart,
        NextSeat - 1 AS GapEnd
    FROM OrderedSeats
    WHERE NextSeat - SeatNumber > 1
),
FirstGap AS (
    SELECT
        1 AS GapStart,
        MIN(SeatNumber) - 1 AS GapEnd
    FROM Seats
),
LastGap AS (
    SELECT
        MAX(SeatNumber) + 1 AS GapStart,
        60 AS GapEnd
    FROM Seats
)
SELECT * FROM FirstGap WHERE GapStart <= GapEnd
UNION ALL
SELECT * FROM Gaps
UNION ALL
SELECT * FROM LastGap WHERE GapStart <= GapEnd
ORDER BY GapStart;
