SELECT DISTINCT s.CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales sub
    WHERE sub.CustomerName = s.CustomerName
      AND sub.SaleDate >= '2024-03-01'
      AND sub.SaleDate < '2024-04-01'
);
------------------------------------------------------------------------------
SELECT Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRev)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRev
        FROM #Sales
        GROUP BY Product
    ) AS Revenues
);
-------------------------------------------------------------------------------------
SELECT MAX(SaleAmount) AS SecondHighestSale
FROM (
    SELECT Quantity * Price AS SaleAmount
    FROM #Sales
) AS SalesAmounts
WHERE SaleAmount < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);
-----------------------------------------------------------------------------------
SELECT SaleMonth, SUM(TotalQty) AS TotalQuantity
FROM (
    SELECT 
        FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
        Quantity AS TotalQty
    FROM #Sales
) AS MonthlySales
GROUP BY SaleMonth
ORDER BY SaleMonth;
---------------------------------------------------------
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.Product = s1.Product
      AND s2.CustomerName <> s1.CustomerName
);
--------------------------------------------------------------------------
SELECT Name, ISNULL(Apple, 0) AS Apple, ISNULL(Orange, 0) AS Orange, ISNULL(Banana, 0) AS Banana
FROM (
    SELECT Name, Fruit
    FROM Fruits
) AS SourceTable
PIVOT (
    COUNT(Fruit)
    FOR Fruit IN ([Apple], [Orange], [Banana])
) AS PivotTable;
-----------------------------------------------------------------------------------
WITH FamilyHierarchy AS (
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family
    UNION ALL
    SELECT fh.PID, f.ChildID
    FROM FamilyHierarchy fh
    JOIN Family f ON fh.CHID = f.ParentId
)
SELECT *
FROM FamilyHierarchy
ORDER BY PID, CHID;
----------------------------------------------------------------------------------------
SELECT *
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders o2
      WHERE o2.CustomerID = o.CustomerID
        AND o2.DeliveryState = 'CA'
  );
---------------------------------------------------------------------------------------------
UPDATE #residents
SET address = CONCAT(address, ' name=', fullname)
WHERE address NOT LIKE '%name=%';

------------------------------------------------------------------------------------------------
WITH RoutePaths AS (
    -- Anchor: start from Tashkent
    SELECT 
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        ArrivalCity,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    -- Recursive: extend path from current arrival city
    SELECT
        CAST(rp.Route + ' - ' + r.ArrivalCity AS VARCHAR(MAX)) AS Route,
        r.ArrivalCity,
        rp.Cost + r.Cost AS Cost
    FROM RoutePaths rp
    JOIN #Routes r ON rp.ArrivalCity = r.DepartureCity
    WHERE rp.Route NOT LIKE '% - ' + r.ArrivalCity + '%'
)

SELECT Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost;

-----------------------------------------------------------------------------------------------
WITH ProductGroups AS (
    SELECT 
        ID,
        Vals,
        -- Группировка по появлению 'Product'
        SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
            OVER (ORDER BY ID) AS ProductGroup
    FROM #RankingPuzzle
),
OnlyProducts AS (
    SELECT *
    FROM ProductGroups
    WHERE Vals <> 'Product'
),
FirstAppearance AS (
    SELECT 
        ProductGroup,
        Vals,
        MIN(ID) AS FirstID
    FROM OnlyProducts
    GROUP BY ProductGroup, Vals
),
FinalResult AS (
    SELECT 
        *,
        DENSE_RANK() OVER (ORDER BY FirstID) AS InsertionRank
    FROM FirstAppearance
)
SELECT 
    Vals AS Product,
    ProductGroup,
    FirstID AS FirstAppearanceID,
    InsertionRank
FROM FinalResult
ORDER BY InsertionRank;
---------------------------------------------------------------------------------------------
WITH DepartmentAvg AS (
    SELECT 
        Department,
        SalesMonth,
        SalesYear,
        AVG(SalesAmount) AS AvgSales
    FROM #EmployeeSales
    GROUP BY Department, SalesMonth, SalesYear
)

SELECT 
    e.EmployeeName,
    e.Department,
    e.SalesAmount,
    e.SalesMonth,
    e.SalesYear,
    d.AvgSales
FROM #EmployeeSales e
JOIN DepartmentAvg d
    ON e.Department = d.Department 
   AND e.SalesMonth = d.SalesMonth 
   AND e.SalesYear = d.SalesYear
WHERE e.SalesAmount > d.AvgSales
ORDER BY e.Department, e.SalesYear, e.SalesMonth;
--------------------------------------------------------------------
SELECT e1.EmployeeName, e1.Department, e1.SalesAmount, e1.SalesMonth, e1.SalesYear
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.SalesMonth = e1.SalesMonth
      AND e2.SalesYear = e1.SalesYear
      AND e2.SalesAmount > e1.SalesAmount
);
---------------------------------------------------------------------------------
SELECT e.EmployeeName
FROM #EmployeeSales e
GROUP BY e.EmployeeName
HAVING NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT SalesMonth
        FROM #EmployeeSales
    ) AS AllMonths
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales es
        WHERE es.EmployeeName = e.EmployeeName
          AND es.SalesMonth = AllMonths.SalesMonth
    )
);
------------------------------------------------------------------------------------------
SELECT Name, Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);
-------------------------------------------------------------------------------------------------
SELECT Name, Stock
FROM Products
WHERE Stock < (
    SELECT MAX(Stock)
    FROM Products
);
------------------------------------------------------------------------------------------
SELECT Name
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);
-------------------------------------------------------------------------------------------------------------
SELECT Name, Category, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);
----------------------------------------------------------------------
SELECT Name, Category, Price
FROM Products p
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = p.Category
);
------------------------------------------------------------------------------------
SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);
----------------------------------------------------------------------------------
-- Step 1: Get total quantity ordered per product
WITH ProductOrderTotals AS (
    SELECT 
        p.ProductID,
        p.Name,
        SUM(o.Quantity) AS TotalQuantity
    FROM Products p
    JOIN Orders o ON p.ProductID = o.ProductID
    GROUP BY p.ProductID, p.Name
),
-- Step 2: Calculate average quantity across all products
AverageQuantity AS (
    SELECT AVG(TotalQuantity * 1.0) AS AvgQuantity
    FROM ProductOrderTotals
)
-- Step 3: Filter products whose total quantity > average
SELECT pot.ProductID, pot.Name, pot.TotalQuantity
FROM ProductOrderTotals pot
CROSS JOIN AverageQuantity aq
WHERE pot.TotalQuantity > aq.AvgQuan
---------------------------------------------------------------------------------------------------
SELECT ProductID, Name, Category, Price
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);
---------------------------------------------------------------------------------------
SELECT TOP 1 
    p.ProductID,
    p.Name,
    SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalQuantity DESC;




