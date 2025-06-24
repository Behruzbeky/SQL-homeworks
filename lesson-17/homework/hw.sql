WITH AllRegions AS (
  SELECT DISTINCT Region FROM #RegionSales
),
AllDistributors AS (
  SELECT DISTINCT Distributor FROM #RegionSales
),
AllCombinations AS (
  SELECT 
    r.Region, 
    d.Distributor
  FROM AllRegions r
  CROSS JOIN AllDistributors d
)
SELECT 
  ac.Region,
  ac.Distributor,
  ISNULL(rs.Sales, 0) AS Sales
FROM AllCombinations ac
LEFT JOIN #RegionSales rs
  ON ac.Region = rs.Region AND ac.Distributor = rs.Distributor
ORDER BY ac.Region, ac.Distributor;
---------------------------------------------------------------------------------------------
SELECT e.name
FROM Employee e
JOIN (
    SELECT managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) m ON e.id = m.managerId;
--------------------------------------------------------------------------------------
select p.product_name, sum(o.unit) as unit from orders o
join products p on p.product_id=o.product_id
where o.order_date>='2020-02-01' and o.order_date<'2020-03-01'
group by p.product_name
having sum(o.unit)>=100
order by unit desc
---------------------------------------------------------------------------------------
with cte as(
select CustomerID, Vendor,Count(*) as OrderCount, row_number() over(
partition by CustomerID
order by count(*) desc)
as rn
from orders
group by CustomerID,Vendor)
select CustomerID,Vendor from cte 
where rn=1
--------------------------------------------------------------------------------------
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;  

IF @Check_Prime <= 1
BEGIN
    SET @IsPrime = 0;
END
ELSE
BEGIN
    WHILE @i * @i <= @Check_Prime
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END
END

IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';
---------------------------------------------------------------------------------------
WITH SignalCounts AS (
  SELECT 
    Device_id,
    Locations,
    COUNT(*) AS signal_count
  FROM Device
  GROUP BY Device_id, Locations
),
MaxSignalLocation AS (
  SELECT 
    Device_id,
    Locations AS max_signal_location,
    RANK() OVER (PARTITION BY Device_id ORDER BY COUNT(*) DESC) AS rnk
  FROM Device
  GROUP BY Device_id, Locations
),
DeviceSummary AS (
  SELECT 
    Device_id,
    COUNT(DISTINCT Locations) AS no_of_location,
    COUNT(*) AS no_of_signals
  FROM Device
  GROUP BY Device_id
)
SELECT 
  ds.Device_id,
  ds.no_of_location,
  msl.max_signal_location,
  ds.no_of_signals
FROM DeviceSummary ds
JOIN MaxSignalLocation msl 
  ON ds.Device_id = msl.Device_id AND msl.rnk = 1
ORDER BY ds.Device_id;
-------------------------------------------------------------------------------
WITH DeptAvg AS (
  SELECT 
    DeptID,
    AVG(Salary) AS AvgSalary
  FROM Employee
  GROUP BY DeptID
)
SELECT 
  e.EmpID,
  e.EmpName,
  e.Salary
FROM Employee e
JOIN DeptAvg d ON e.DeptID = d.DeptID
WHERE e.Salary > d.AvgSalary
ORDER BY e.EmpID;
------------------------------------------------------------------------------------------
CREATE TABLE WinningNumbers (
  Number INT
);

CREATE TABLE Tickets (
  TicketID VARCHAR(20),
  Number INT
);

INSERT INTO WinningNumbers VALUES (25), (45), (78);

INSERT INTO Tickets VALUES
('A23423', 25), ('A23423', 45), ('A23423', 78),
('B35643', 25), ('B35643', 45), ('B35643', 98),
('C98787', 67), ('C98787', 86), ('C98787', 91);

WITH TicketMatches AS (
  SELECT 
    TicketID,
    COUNT(*) AS MatchCount
  FROM Tickets t
  JOIN WinningNumbers w ON t.Number = w.Number
  GROUP BY TicketID
)

SELECT 
  SUM(
    CASE 
      WHEN MatchCount = 3 THEN 100
      WHEN MatchCount BETWEEN 1 AND 2 THEN 10
      ELSE 0
    END
  ) AS TotalWinnings
FROM (
  SELECT DISTINCT TicketID
  FROM Tickets
) all_tickets
LEFT JOIN TicketMatches tm ON all_tickets.TicketID = tm.TicketID;
----------------------------------------------------------------------------------------------------------
WITH UserPlatforms AS (
  SELECT 
    User_id, 
    Spend_date,
    MAX(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS used_mobile,
    MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS used_desktop
  FROM Spending
  GROUP BY User_id, Spend_date
),
UserCategories AS (
  SELECT 
    User_id,
    Spend_date,
    CASE 
      WHEN used_mobile = 1 AND used_desktop = 1 THEN 'Both'
      WHEN used_mobile = 1 THEN 'Mobile'
      WHEN used_desktop = 1 THEN 'Desktop'
    END AS Platform_Category
  FROM UserPlatforms
),
SpendByUser AS (
  SELECT 
    User_id, 
    Spend_date, 
    SUM(Amount) AS Total_Amount
  FROM Spending
  GROUP BY User_id, Spend_date
),
FinalAgg AS (
  SELECT 
    uc.Spend_date,
    uc.Platform_Category AS Platform,
    COUNT(*) AS Total_users,
    SUM(s.Total_Amount) AS Total_Amount
  FROM UserCategories uc
  JOIN SpendByUser s 
    ON uc.User_id = s.User_id AND uc.Spend_date = s.Spend_date
  GROUP BY uc.Spend_date, uc.Platform_Category
),
-- Add missing (date, platform) combinations
AllDates AS (
  SELECT DISTINCT Spend_date FROM Spending
),
AllPlatforms AS (
  SELECT 'Mobile' AS Platform
  UNION ALL
  SELECT 'Desktop'
  UNION ALL
  SELECT 'Both'
),
DatePlatformGrid AS (
  SELECT d.Spend_date, p.Platform
  FROM AllDates d CROSS JOIN AllPlatforms p
)

SELECT 
  ROW_NUMBER() OVER (ORDER BY g.Spend_date, g.Platform) AS Row,
  g.Spend_date,
  g.Platform,
  COALESCE(f.Total_Amount, 0) AS Total_Amount,
  COALESCE(f.Total_users, 0) AS Total_users
FROM DatePlatformGrid g
LEFT JOIN FinalAgg f 
  ON g.Spend_date = f.Spend_date AND g.Platform = f.Platform
ORDER BY g.Spend_date, 
         CASE g.Platform 
           WHEN 'Mobile' THEN 1 
           WHEN 'Desktop' THEN 2 
           WHEN 'Both' THEN 3 
         END;
--------------------------------------------------------------------------------------------------------
WITH Numbers AS (
  SELECT 1 AS n UNION ALL
  SELECT 2 UNION ALL
  SELECT 3 UNION ALL
  SELECT 4 UNION ALL
  SELECT 5 UNION ALL
  SELECT 6 UNION ALL
  SELECT 7 UNION ALL
  SELECT 8 UNION ALL
  SELECT 9 UNION ALL
  SELECT 10
)

SELECT 
  g.Product,
  1 AS Quantity
FROM Grouped g
JOIN Numbers n ON n.n <= g.Quantity
ORDER BY g.Product;







