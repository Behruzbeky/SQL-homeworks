select* from Orders
select category, count(*)as ProductsAvailable from Products
group by Category

select avg(price) from Products
where category='Electronics'

select* from CUSTOMERS
where City like 'L%'

select* from Products 
where ProductName like '%er'

select* from Customers
where city like '%a'

select  max(price) from Products

SELECT ProductName, StockQuantity,
       CASE
           WHEN StockQuantity < 30 THEN 'Low Stock'
           ELSE 'Sufficient'
       END AS StockStatus
FROM Products;

select country,count(CustomerID) from Customers
group by Country

select min(Quantity), max(Quantity) from Orders

SELECT DISTINCT o.CustomerID
FROM Orders o
LEFT JOIN Invoices i ON o.OrderID = i.OrderID 
WHERE o.OrderDate >= '2023-01-01'
  AND o.OrderDate < '2023-02-01'
  AND i.InvoiceID IS NULL;

 SELECT ProductName FROM Products
UNION ALL
SELECT ProductName FROM Products_Discounted;

 SELECT ProductName FROM Products
UNION 
SELECT ProductName FROM Products_Discounted;


SELECT 
    YEAR(OrderDate) AS OrderYear,
    AVG(Quantity) AS AverageOrderAmount
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;


SELECT 
    ProductName,
    CASE
        WHEN Price < 100 THEN 'Low'
        WHEN Price BETWEEN 100 AND 500 THEN 'Mid'
        WHEN Price > 500 THEN 'High'
        ELSE 'Unknown'  -- optional, in case of NULL or unexpected values
    END AS PriceGroup
FROM Products;

select* from 
(
    SELECT district_name, Year, Population
    FROM City_Population
) AS SourceTable
PIVOT
(
    sum(population)
    FOR Year IN ([2012], [2013])
) AS PivotTable;

select ProductID, sum(SaleAmount) from Sales
group by ProductID

SELECT productname FROM Products
WHERE productname LIKE '%oo%';

select* from
(
 select district_name, Year, Population from city_population
) as sourcetable
pivot
(
sum(population)
for district_name in ([Bektemir],[Chilonzor],[Yakkasaroy])
) as PivotTable


SELECT top 3 CustomerID, 
       SUM(TotalAmount) AS Totalspent
FROM Invoices
GROUP BY CustomerID
ORDER BY Totalspent DESC

SELECT* FROM
(
    SELECT district_name,year, population
    FROM city_population
) AS p
UNPIVOT
(
    population FOR [Year] IN ([2012], [2013])
) AS unpvt;

SELECT p.ProductName, 
       COUNT(s.ProductID) AS TimesSold
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName
ORDER BY TimesSold DESC;

SELECT*
FROM 
(
    SELECT Year, district_name, population
    FROM city_population
) AS SourceTable
UNPIVOT
(
    population FOR City IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS Unpivoted;

