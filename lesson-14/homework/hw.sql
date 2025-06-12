SELECT 
    LTRIM(RTRIM(SUBSTRING(Name, CHARINDEX(',', Name) + 1, LEN(Name)))) AS Name,
    LTRIM(RTRIM(LEFT(Name, CHARINDEX(',', Name) - 1))) AS Surname
FROM TestMultipleColumns;
select* from testmultiplecolumns

SELECT *
FROM TestPercent
WHERE Strs LIKE '%\%%' ESCAPE '\';

select* from splitter
SELECT
    LEFT(vals, CHARINDEX('.', vals) - 1) AS Part1,
    SUBSTRING(
        vals,
        CHARINDEX('.', vals) + 1,
        CHARINDEX('.', vals, CHARINDEX('.', vals) + 1) - CHARINDEX('.', vals) - 1
    ) AS Part2,
    RIGHT(vals, LEN(vals) - CHARINDEX('.', vals, CHARINDEX('.', vals) + 1)) AS Part3
FROM Splitter;

SELECT REPLACE(
           REPLACE(
           REPLACE(
           REPLACE(
           REPLACE(
           REPLACE(
           REPLACE(
           REPLACE(
           REPLACE(
           REPLACE(vals, '0', 'X'), 
       '1', 'X'), '2', 'X'), '3', 'X'), '4', 'X'), 
       '5', 'X'), '6', 'X'), '7', 'X'), '8', 'X'), '9', 'X') AS ReplacedVals
FROM 1234ABC123456XYZ1234567890ADS ;

SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

SELECT 
    texts,
    LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;


SELECT e.Name AS EmployeeName, e.Salary AS EmployeeSalary, 
       m.Name AS ManagerName, m.Salary AS ManagerSalary
FROM Employee e
JOIN Employee m ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;

SELECT 
    Employee_ID,
    First_Name,
    Last_Name,
    Hire_Date,
    DATEDIFF(YEAR, Hire_Date, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, Hire_Date, GETDATE()) > 10
  AND DATEDIFF(YEAR, Hire_Date, GETDATE()) < 15;
select* from employees

CREATE FUNCTION dbo.SplitDigitsAndLetters (@input NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
    WITH Numbers AS (
        SELECT TOP (LEN(@input))
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects
    )
    SELECT
        (SELECT STRING_AGG(SUBSTRING(@input, n, 1), '')
         FROM Numbers
         WHERE SUBSTRING(@input, n, 1) LIKE '[0-9]') AS DigitsOnly,
        
        (SELECT STRING_AGG(SUBSTRING(@input, n, 1), '')
         FROM Numbers
         WHERE SUBSTRING(@input, n, 1) LIKE '[A-Za-z]') AS LettersOnly;
SELECT *
FROM dbo.SplitDigitsAndLetters('rtcfvty34redt');

SELECT w1.Id, w1.RecordDate, w1.Temperature
FROM Weather w1
JOIN Weather w2
  ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature;


SELECT 
    player_id,
    MIN(event_date) AS first_login_date
FROM Activity
GROUP BY player_id;

SELECT fruit_list
FROM (
    SELECT fruit_list, ROW_NUMBER() OVER (ORDER BY fruit_list) AS rn
    FROM fruits
) AS numbered
WHERE rn = 3;

DECLARE @input NVARCHAR(MAX) = 'sdgfhsdgfhs@121313131';
WITH Numbers AS (
    SELECT TOP (LEN(@input))
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects -- any sufficiently large source
),
Chars AS (
    SELECT 
        n,
        SUBSTRING(@input, n, 1) AS char_value
    FROM Numbers
)
SELECT char_value
FROM Chars;

SELECT 
    p1.id,
    CASE 
        WHEN p1.code = 0 THEN p2.code
        ELSE p1.code
    END AS code
FROM p1
JOIN p2 ON p1.id = p2.id;

SELECT 
    Employee_ID,
    First_Name,
    Last_Name,
    Hire_Date,
    DATEDIFF(YEAR, Hire_Date, GETDATE()) AS YearsOfService,
    CASE 
        WHEN DATEDIFF(YEAR, Hire_Date, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, Hire_Date, GETDATE()) BETWEEN 1 AND 4 THEN 'Junior'
        WHEN DATEDIFF(YEAR, Hire_Date, GETDATE()) BETWEEN 5 AND 9 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, Hire_Date, GETDATE()) BETWEEN 10 AND 19 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;

SELECT 
    Vals,
    LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'X') - 1) AS LeadingInteger
FROM GetIntegers
WHERE Vals LIKE '[0-9]%';

-- Split string, swap first two letters, and re-join
WITH SplitVals AS (
    SELECT 
        Id,
        TRIM(vals) AS val
    FROM MultipleVals
    CROSS APPLY STRING_SPLIT(Vals, ',') 
    CROSS APPLY (SELECT id = ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) AS r
), Swapped AS (
    SELECT 
        id,
        CASE 
            WHEN LEN(val) >= 2 
                THEN SUBSTRING(val, 2, 1) + SUBSTRING(val, 1, 1) + SUBSTRING(val, 3, LEN(val))
            ELSE val
        END AS swapped
    FROM SplitVals
), Aggregated AS (
    SELECT 
        STRING_AGG(swapped, ',') AS SwappedVals
    FROM Swapped
)
SELECT * FROM Aggregated;

select* from multiplevals

SELECT player_id, device_id
FROM (
    SELECT 
        player_id,
        device_id,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date ASC) AS rn
    FROM Activity
) AS ranked
WHERE rn = 1;

WITH SalesWithWeek AS (
    SELECT 
        area,
        date,
        DATEPART(YEAR, date) AS year,
        DATEPART(WEEK, date) AS week,
        SUM(saleslocal) AS area_sales
    FROM WeekPercentagePuzzle
    GROUP BY area, date
),
WeeklyTotal AS (
    SELECT 
        year,
        week,
        SUM(area_sales) AS week_total_sales
    FROM SalesWithWeek
    GROUP BY year, week
),
AreaWeekPercentage AS (
    SELECT 
        s.area,
        s.date,
        s.year,
        s.week,
        s.area_sales,
        w.week_total_sales,
        CAST(s.area_sales * 100.0 / w.week_total_sales AS DECIMAL(5,2)) AS percentage_of_week
    FROM SalesWithWeek s
    JOIN WeeklyTotal w
      ON s.year = w.year AND s.week = w.week
)
SELECT *
FROM AreaWeekPercentage
ORDER BY year, week, area;
