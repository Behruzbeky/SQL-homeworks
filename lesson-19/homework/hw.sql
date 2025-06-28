CREATE PROC Employee_Bonus_Calculator
AS
BEGIN

    CREATE TABLE #EmployeeBonus (EmployeeID INT, FullName VARCHAR(100), Department VARCHAR(40), Salary FLOAT, BonusAmount FLOAT)

    INSERT INTO #EmployeeBonus

    SELECT EmployeeID,
           CONCAT(FIRSTNAME,' ', LASTNAME) AS FullName,
           E.Department,
           Salary,
           Salary * BonusPercentage / 100 AS BonusAmount

    FROM Employees AS E JOIN DepartmentBonus AS DB ON E.Department = DB.Department

    SELECT * FROM #EmployeeBonus

END
EXECUTE Employee_Bonus_Calculator
-------------------------------------------------------------------------------------------------
create proc New_calculator as begin
UPDATE DepartmentBonus
SET BonusPercentage = 50
WHERE Department = 'Sales'

end

EXECUTE Employee_Bonus_Calculator
--------------------------------------------------------------------------------------------------
MERGE INTO Products_Current AS target
USING Products_New AS source
ON target.ProductID = source.ProductID

WHEN MATCHED THEN
    UPDATE SET 
        target.ProductName = source.ProductName,
        target.Price = source.Price

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

select* from Products_Current
---------------------------------------------------------------------------------------
SELECT 
    t.id,
    CASE 
        WHEN t.p_id IS NULL THEN 'Root'
        WHEN EXISTS (SELECT 1 FROM Tree AS children WHERE children.p_id = t.id) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree AS t;
-------------------------------------------------------------------------------------------------------
SELECT 
    s.user_id,
    ROUND(
        CAST(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(COUNT(c.action), 0), 2
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id;
-------------------------------------------------------------------------------------------------------
SELECT *
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);
----------------------------------------------------------------------------------------
create proc GetProductSalesSummary 
@ProductID int 
as
begin 
select p.ProductName,
sum(s.Quantity) as TotalQuantitySold,
sum(s.Quantity*p.Price) as TotalSalesAmount,
min(s.SaleDate) as FirstSaleDate,
max(s.SaleDate) as LastSaleDate from Products p
left join sales s on p.ProductID=s.ProductID 
where p.ProductID=@ProductID
group by ProductName
end
--------------------------------------------------------------------------------------------





