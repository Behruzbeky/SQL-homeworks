CREATE TABLE #MonthlySales (
    ProductID INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(10,2)
);
INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM
    Sales s
JOIN
    Products p ON s.ProductID = p.ProductID
WHERE MONTH(s.SaleDate) = 4 AND YEAR(s.SaleDate) = 2025
GROUP BY
    s.ProductID;

SELECT * FROM #MonthlySales;
--------------------------------------------------------------------------------------------------
create view vw_ProductSalesSummary as 
select 
p.ProductID,
p.ProductName,
p.Category, isnull(sum(s.Quantity),0) as TotalQuantitySold from Products p
Left join Sales s on p.ProductID=s.ProductID
group by 
p.ProductID,
p.ProductName,
p.Category;

select* from vw_ProductSalesSummary
-------------------------------------------------------------------------------------------------------
create function fn_GetTotalRevenueForProduct(@ProductID int)
returns decimal(10,2)
as 
begin 
declare @TotalRevenue decimal(18,2);
select @TotalRevenue = sum(s.Quantity*p.Price)
from sales s
join products p on p.ProductID=s.ProductID
where s.ProductID=@ProductID;
return isnull(@TotalRevenue,0.00);
end;

SELECT dbo.fn_GetTotalRevenueForProduct(1) AS TotalRevenueForProduct1;
------------------------------------------------------------------------------------------------------------
CREATE FUNCTION UDF_GetSalesByCategory(@CATEGORY VARCHAR(50))
RETURNS TABLE AS RETURN(
SELECT PRODUCTNAME,SUM(QUANTITY) TOTALQUANTITY, SUM(PRICE*QUANTITY) AS TOTAL_REVENUE FROM PRODUCTS P
JOIN SALES S ON P.PRODUCTID=S.PRODUCTID
WHERE CATEGORY=@CATEGORY
GROUP BY PRODUCTNAME);

SELECT* from dbo.UDF_GetSalesByCategory('ELECTRONICS')
--------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime BIT = 1;
    DECLARE @Result VARCHAR(3);

    IF @Number < 2
        SET @IsPrime = 0;
    ELSE
    BEGIN
        WHILE @i * @i <= @Number
        BEGIN
            IF @Number % @i = 0
            BEGIN
                SET @IsPrime = 0;
                BREAK;
            END
            SET @i = @i + 1;
        END
    END

    SET @Result = CASE WHEN @IsPrime = 1 THEN 'Yes' ELSE 'No' END;

    RETURN @Result;
END
----------------------------------------------------------------------------------------
CREATE FUNCTION dbo.fn_GetNumbersBetween (
    @Start INT,
    @End INT
)
RETURNS @Numbers TABLE (
    Number INT
)
AS
BEGIN
    DECLARE @Current INT = @Start;

    WHILE @Current <= @End
    BEGIN
        INSERT INTO @Numbers (Number)
        VALUES (@Current);

        SET @Current = @Current + 1;
    END

    RETURN;
END

SELECT * FROM dbo.fn_GetNumbersBetween(3, 7);
---------------------------------------------------------------------------------
CREATE FUNCTION getNthHighestSalary (@N INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        MAX(salary) AS HighestNSalary
    FROM (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        OFFSET (@N - 1) ROWS FETCH NEXT 1 ROWS ONLY
    ) AS Temp
);

SELECT * FROM getNthHighestSalary(2);
-----------------------------------------------------------------------
SELECT TOP 1
    id,
    COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY COUNT(*) DESC;
------------------------------------------------------------------------------------
create view vw_CustomerOrderSummary as 
select
c.customer_id,
c.name,
count(o.order_id) as Total_order,
coalesce(sum(o.amount),0) as Total_amount,
max(o.order_date) as Last_order_date
from customers c
left join orders o on c.customer_id=o.customer_id
group by c.customer_id, c.name;

SELECT * FROM vw_CustomerOrderSummary;
--------------------------------------------------------------------------------------
SELECT
    g.RowNumber,
    (
        SELECT TOP 1 TestCase
        FROM Gaps g2
        WHERE g2.RowNumber <= g.RowNumber AND g2.TestCase IS NOT NULL
        ORDER BY g2.RowNumber DESC
    ) AS Workflow
FROM Gaps g
ORDER BY g.RowNumber;

