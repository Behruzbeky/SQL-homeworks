-- 1. Assign row number based on SaleDate
SELECT *, ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

-- 2. Rank products based on total quantity sold (DENSE_RANK avoids skipping ranks)
SELECT ProductName, SUM(Quantity) AS TotalQuantity,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM ProductSales
GROUP BY ProductName;

-- 3. Top sale per customer based on SaleAmount
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) AS Ranked
WHERE rn = 1;

-- 4. Each sale's amount with the next sale amount (by date)
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

-- 5. Each sale's amount with the previous sale amount (by date)
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales;

-- 6. Sales where current amount is greater than previous (by date)
SELECT *
FROM (
    SELECT *, LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
) AS T
WHERE SaleAmount > PrevAmount;

-- 7. Difference from previous sale per product
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DifferenceFromPrev
FROM ProductSales;

-- 8. Percentage change compared to next sale (by date)
SELECT SaleID, ProductName, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextAmount,
       (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount AS PercentChangeToNext
FROM ProductSales;

-- 9. Ratio of current to previous sale within same product
SELECT SaleID, ProductName, SaleAmount,
       LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount,
       SaleAmount * 1.0 / NULLIF(LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate), 0) AS RatioToPrev
FROM ProductSales;

-- 10. Difference from the very first sale of that product
SELECT SaleID, ProductName, SaleAmount,
       FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS FirstSaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromFirst
FROM ProductSales;

-- 11. Find continuously increasing sales for each product
SELECT *
FROM (
    SELECT *,
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
) AS T
WHERE SaleAmount > PrevAmount;

-- 12. Running total of sale amounts (closing balance)
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM ProductSales;

-- 13. Moving average of sales amounts over last 3 sales (by date)
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM ProductSales;

-- 14. Difference between sale amount and average sale amount
SELECT SaleID, ProductName, SaleAmount,
       AVG(SaleAmount) OVER () AS AvgSaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;
-- 15. Employees Who Have the Same Salary Rank
SELECT *, DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

-- 16. Top 2 Highest Salaries in Each Department
SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
    FROM Employees1
) AS Ranked
WHERE rnk <= 2;

-- 17. Lowest-Paid Employee in Each Department
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rnk
    FROM Employees1
) AS Ranked
WHERE rnk = 1;

-- 18. Running Total of Salaries in Each Department
SELECT *,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate) AS RunningTotal
FROM Employees1;

-- 19. Total Salary of Each Department Without GROUP BY
SELECT *,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees1;

-- 20. Average Salary of Each Department Without GROUP BY
SELECT *,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees1;

-- 21. Difference Between Salary and Department Average
SELECT *,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;

-- 22. Moving Average Salary Over 3 Employees (Previous, Current, Next)
SELECT *,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

-- 23. Sum of Salaries for the Last 3 Hired Employees
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS rn
    FROM Employees1
) AS Ranked
WHERE rn <= 3;



