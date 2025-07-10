SELECT
    Id,
    Dt,
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR), 2) AS MonthPrefixedWithZero
FROM Dates;
-------------------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVal) AS TotalOfMaxVals
FROM (
    SELECT
        Id,
        rID,
        MAX(Vals) AS MaxVal
    FROM MyTabel
    GROUP BY Id, rID
) AS MaxPerId
GROUP BY rID;
------------------------------------------------------------------------------------------
SELECT *
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;
-------------------------------------------------------------------------------------------
SELECT t.ID, t.Item, t.Vals
FROM TestMaximum t
JOIN (
    SELECT ID, MAX(Vals) AS MaxVal
    FROM TestMaximum
    GROUP BY ID
) max_vals
ON t.ID = max_vals.ID AND t.Vals = max_vals.MaxVal;
------------------------------------------------------------------------------------------------
SELECT Id, SUM(MaxVal) AS SumofMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVal
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) t
GROUP BY Id;
------------------------------------------------------------------------------------------------
SELECT 
    Id, a, b,
    CASE 
        WHEN a - b <> 0 THEN CAST(a - b AS VARCHAR)
        ELSE ''
    END AS OUTPUT
FROM TheZeroPuzzle;
----------------------------------------------------------------------------------------------
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue FROM Sales;
---------------------------------------------------------------------------------------------
SELECT AVG(UnitPrice) AS AverageUnitPrice FROM Sales;
---------------------------------------------------------------------------------------------
SELECT COUNT(*) AS TotalTransactions FROM Sales;
---------------------------------------------------------------------------------------------
SELECT MAX(QuantitySold) AS MaxUnitsSold FROM Sales;
---------------------------------------------------------------------------------------------
SELECT Category, SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category;
---------------------------------------------------------------------------------------------
SELECT Region, SUM(QuantitySold * UnitPrice) AS RegionRevenue
FROM Sales
GROUP BY Region;
---------------------------------------------------------------------------------------------
SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS ProductRevenue
FROM Sales
GROUP BY Product
ORDER BY ProductRevenue DESC;
---------------------------------------------------------------------------------------------
SELECT 
    SaleDate, 
    SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningRevenue
FROM Sales;
---------------------------------------------------------------------------------------------
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    ROUND(
        100.0 * SUM(QuantitySold * UnitPrice) / 
        (SELECT SUM(QuantitySold * UnitPrice) FROM Sales), 2
    ) AS PercentContribution
FROM Sales
GROUP BY Category;
---------------------------------------------------------------------------------------------
SELECT s.*, c.CustomerName
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID;
---------------------------------------------------------------------------------------------
SELECT *
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales);
---------------------------------------------------------------------------------------------
SELECT CustomerID, SUM(QuantitySold * UnitPrice) AS CustomerRevenue
FROM Sales
GROUP BY CustomerID;
---------------------------------------------------------------------------------------------
SELECT TOP 1 CustomerID, SUM(QuantitySold * UnitPrice) AS Revenue
FROM Sales
GROUP BY CustomerID
ORDER BY Revenue DESC;
---------------------------------------------------------------------------------------------
SELECT CustomerID, COUNT(*) AS SalesCount
FROM Sales
GROUP BY CustomerID;
---------------------------------------------------------------------------------------------
SELECT DISTINCT Product
FROM Sales;
---------------------------------------------------------------------------------------------
SELECT TOP 1 * FROM Products
ORDER BY SellingPrice DESC;
---------------------------------------------------------------------------------------------
SELECT *
FROM Products p
WHERE SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products p2
    WHERE p2.Category = p.Category
);







