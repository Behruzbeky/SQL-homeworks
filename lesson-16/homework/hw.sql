with cte as(
select 1 as Number
union all
select Number +1 from cte where Number <1000)
select* from Cte option (maxrecursion 5000
);

-----------------------------------------------------------
SELECT 
    e.EmployeeID,
    e.FirstName 
FROM 
    Employees e
JOIN (
    SELECT 
        EmployeeID,
        SUM(SalesAmount) AS total_sales
    FROM 
        Sales
    GROUP BY 
        EmployeeID
) s ON e.EmployeeID = s.EmployeeID;
---------------------------------------------------------
WITH AvgSalaryCTE AS (
    SELECT 
        AVG(salary) AS average_salary
    FROM 
        Employees
)
SELECT * FROM AvgSalaryCTE;
-------------------------------------------------------------------
select p.ProductName, p.ProductID, s.MaxSales from Products p
join( select ProductID, max(SalesAmount) 
as MaxSales
from Sales
group by ProductID) s 
on p.ProductID=s.ProductID;
---------------------------------------------------------------------
with CTE as (
select 1 as Number
union all
select Number *2 from CTE where Number<1000000)
select* from CTE ;
---------------------------------------------------------------------
WITH SalesCount AS (
    SELECT 
        EmployeeID,
        COUNT(*) AS total_sales
    FROM 
        Sales
    GROUP BY 
        EmployeeID
)
SELECT 
    e.FirstName,
	e.LastName,
    sc.total_sales
FROM 
    SalesCount sc
JOIN 
    Employees e ON sc.EmployeeID = e.EmployeeID
WHERE 
    sc.total_sales > 5;
---------------------------------------------------------------------
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(SalesAmount) AS total_sales
    FROM 
        Sales
    GROUP BY 
        ProductID
)
SELECT 
    p.ProductID,
    p.ProductName,
    ps.total_sales
FROM 
    ProductSales ps
JOIN 
    Products p ON ps.ProductID = p.ProductID
WHERE 
    ps.total_sales > 500;
---------------------------------------------------------------------------

WITH AvgSalary AS (
    SELECT AVG(salary) AS average_salary
    FROM Employees
)
SELECT 
    e.EmployeeID,
    e.FirstName,
	e.LastName,
    e.salary
FROM 
    Employees e,
    AvgSalary a
WHERE 
    e.salary > a.average_salary;
------------------------------------------------------------------
	SELECT top 5
    e.EmployeeID,
    e.FirstName,
	e.LastName,
    s.order_count
FROM 
    Employees e
JOIN (
    SELECT 
        EmployeeID,
        COUNT(*) AS order_count
    FROM 
        Sales
    GROUP BY 
        EmployeeID
) s ON e.EmployeeID = s.EmployeeID
ORDER BY 
    s.order_count DESC;
-------------------------------------------------------
SELECT 
    p.CategoryID,
    SUM(s.total_sales) AS category_sales
FROM 
    (
        SELECT 
            ProductID,
            SUM(SalesAmount) AS total_sales
        FROM 
            Sales
        GROUP BY 
            ProductID
    ) s
JOIN 
    Products p ON s.ProductID = p.ProductID
GROUP BY 
    p.CategoryID;
---------------------------------------------------------
with CTE as(
select Number,
1 as step, 1 as Factorial
from Numbers1
union all
select f.Number, f.step+1, f.factorial* (f.step+1) as factorial
from CTE f
where f.step+1<=f.Number)
select Number, max(Factorial) as Factorial
from CTE
group by Number
order by Number
--------------------------------------------------------------------
WITH StringSplit AS (
    -- Base case: first character of each string
    SELECT 
        Id,
        1 AS position,
        SUBSTRING(String, 1, 1) AS character,
        String
    FROM 
        Example
    WHERE 
        LEN(String) >= 1

    UNION ALL

    -- Recursive case: next character
    SELECT 
        Id,
        position + 1,
        SUBSTRING(String, position + 1, 1),
        String
    FROM 
        StringSplit
    WHERE 
        position + 1 <= LEN(String)
)

-- Final result
SELECT 
    Id,
    position,
    character
FROM 
    StringSplit
ORDER BY 
    Id, position;
-----------------------------------------------------------------
WITH MonthlySales AS (
    SELECT 
        FORMAT(saledate, 'yyyy-MM') AS sale_month,
        SUM(salesamount) AS total_sales
    FROM 
        Sales
    GROUP BY 
        FORMAT(saledate, 'yyyy-MM')
),

MonthlyDiff AS (
    SELECT 
        sale_month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY sale_month) AS prev_month_sales
    FROM 
        MonthlySales
)

SELECT 
    sale_month,
    total_sales,
    prev_month_sales,
    total_sales - ISNULL(prev_month_sales, 0) AS sales_difference
FROM 
    MonthlyDiff;
--------------------------------------------------------------------------
SELECT 
    e.EmployeeID,
    e.FirstName,
	e.LastName,
    quarterly_sales.quarter,
    quarterly_sales.total_sales
FROM 
    Employees e
JOIN (
    SELECT 
        EmployeeID,
        CONCAT('Q', DATEPART(QUARTER, SaleDate), '-', DATEPART(YEAR, SaleDate)) AS quarter,
        SUM(SalesAmount) AS total_sales
    FROM 
        Sales
    GROUP BY 
        EmployeeID,
        DATEPART(YEAR, SaleDate),
        DATEPART(QUARTER, SaleDate)
) AS quarterly_sales
    ON e.EmployeeID = quarterly_sales.EmployeeID
WHERE 
    quarterly_sales.total_sales > 45000
ORDER BY 
    e.EmployeeID,
    quarterly_sales.quarter;
-----------------------------------------------------------------------------------
WITH FibonacciCTE AS (
    SELECT 
        0 AS n,
        0 AS fib_current,
        1 AS fib_next
    UNION ALL
    SELECT 
        n + 1,
        fib_next,
        fib_current + fib_next
    FROM 
        FibonacciCTE
    WHERE 
        n + 1 <= 20  
)

SELECT 
    n AS position,
    fib_current AS fibonacci_number
FROM 
    FibonacciCTE
ORDER BY 
    n;
---------------------------------------------------------------
SELECT *
FROM FindSameCharacters
WHERE LEN(Vals) > 1
  AND NOT EXISTS (
      SELECT 1
      FROM STRING_SPLIT(Vals, '')
      WHERE value <> LEFT(Vals, 1)
  );
--------------------------------------------------------------------
-- Declare the value of n
DECLARE @n INT = 5;

-- Recursive CTE to generate strings: 1, 12, 123, ..., up to n
WITH NumberSequence AS (
    -- Base case
    SELECT 
        1 AS num,
        CAST('1' AS VARCHAR(MAX)) AS sequence
    UNION ALL
    -- Recursive case: append the next number to the string
    SELECT 
        num + 1,
        sequence + CAST(num + 1 AS VARCHAR)
    FROM 
        NumberSequence
    WHERE 
        num + 1 <= @n
)

-- Final output
SELECT sequence
FROM NumberSequence;

--------------------------------------------------------------------------
SELECT 
    e.EmployeeID,
    e.FirstName,
	e.LastName,
    top_sellers.total_sales
FROM 
    Employees e
JOIN (
    -- Derived table: total sales per employee in last 6 months
    SELECT 
        EmployeeID,
        SUM(SalesAmount) AS total_sales
    FROM 
        Sales
    WHERE 
        saledate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY 
        EmployeeID
) AS top_sellers
    ON e.EmployeeID = top_sellers.EmployeeID
WHERE 
    top_sellers.total_sales = (
        -- Subquery to find max sales
        SELECT MAX(SUM(SalesAmount))
        FROM Sales
        WHERE saledate >=DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID);

-------------------------------------------------------------------------


