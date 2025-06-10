SELECT CAST(EMPLOYEE_ID AS VARCHAR) + '-' + FIRST_NAME + ' ' + LAST_NAME AS FULL_INFO
FROM employees;

UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');
SELECT* FROM EMPLOYEES

select first_name as 'First_Name', len(first_name) as 'Name_Length' from employees
where first_name like 'A%'
or first_name like 'J%'
or first_name like 'M%'
order by first_name

select Manager_ID,sum(salary) as Total_Salary from employees
group by Manager_ID
order by manager_id

SELECT 
    year1,
    CASE
        WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1
        WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2
        ELSE Max3
    END AS highest_value
FROM TestMax;

select movie as Movie_Name from cinema c
where id%2=1
and description !='boring'
order by id

SELECT *
FROM SingleOrder
ORDER BY CASE WHEN id = 0 THEN 1 ELSE 0 END, id;

SELECT 
    COALESCE(id, ssn, passportid, itin) AS first_non_null_value
FROM 
    person;

SELECT
    LEFT(FullName, CHARINDEX(' ', FullName) - 1) AS FirstName,
    SUBSTRING(
        FullName,
        CHARINDEX(' ', FullName) + 1,
        CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) - CHARINDEX(' ', FullName) - 1
    ) AS MiddleName,
    RIGHT(FullName, LEN(FullName) - CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1)) AS LastName
FROM
    Students;

SELECT DISTINCT o1.orderid, o1.customerid
FROM Orders o1
WHERE o1.deliverystate = 'Texas'
AND o1.customerid IN (
    SELECT DISTINCT customerid
    FROM Orders
    WHERE deliverystate = 'California'
);
select*from dmltable
SELECT sequencenumber, STRING_AGG(string, ', ') AS concatenated_values
FROM DMLTable
GROUP BY sequencenumber;
select* from employees
SELECT first_name, last_name
FROM Employees
WHERE LENGTH(LOWER(CONCAT(first_name, last_name))) - 
      LENGTH(REPLACE(LOWER(CONCAT(first_name, last_name)), 'a', '')) >= 3;
	  select* from employees
SELECT
    Department_ID,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Hire_Date <= DATEADD(YEAR, -3, GETDATE()) THEN 1 ELSE 0 END) AS EmployeesOver3Years,
    CAST(SUM(CASE WHEN Hire_Date <= DATEADD(YEAR, -3, GETDATE()) THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS PercentageOver3Years
FROM Employees
GROUP BY Department_ID;

WITH ExperienceRank AS (
    SELECT 
        SpacemanID,
        JobDescription,
        MissionCount,
        MIN(missioncount) OVER (PARTITION BY JobDescription) AS EarliestHire,
        MAX(missioncount) OVER (PARTITION BY JobDescription) AS LatestHire
    FROM 
        Personal
)
SELECT 
    JobDescription,
    MAX(CASE WHEN missioncount = EarliestHire THEN SpacemanID END) AS MostExperiencedSpacemanID,
    MAX(CASE WHEN missioncount = LatestHire THEN SpacemanID END) AS LeastExperiencedSpacemanID
FROM 
    ExperienceRank
GROUP BY 
    JobDescription
ORDER BY 
    JobDescription;

WITH Tally AS (
    SELECT TOP (LEN('tf56sd#%OqH')) 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master..spt_values  -- you can replace with any big table for TOP N rows
),
SplitChars AS (
    SELECT 
        n,
        SUBSTRING('tf56sd#%OqH', n, 1) AS ch
    FROM Tally
),
Classified AS (
    SELECT
        ch,
        CASE 
            WHEN ch COLLATE Latin1_General_CS_AS BETWEEN 'A' AND 'Z' THEN 'Uppercase'
            WHEN ch COLLATE Latin1_General_CS_AS BETWEEN 'a' AND 'z' THEN 'Lowercase'
            WHEN ch BETWEEN '0' AND '9' THEN 'Number'
            ELSE 'Other'
        END AS Category
    FROM SplitChars
)
SELECT
    (SELECT STRING_AGG(ch, '') FROM Classified WHERE Category = 'Uppercase') AS Uppercase_Letters,
    (SELECT STRING_AGG(ch, '') FROM Classified WHERE Category = 'Lowercase') AS Lowercase_Letters,
    (SELECT STRING_AGG(ch, '') FROM Classified WHERE Category = 'Number') AS Numbers,
    (SELECT STRING_AGG(ch, '') FROM Classified WHERE Category = 'Other') AS Other_Characters;

	SELECT 
    Studentid,
    SUM(grade) OVER (ORDER BY Studentid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM 
    Students;

SELECT * FROM student

SELECT s.*
FROM Student s
JOIN (
    SELECT Birthday
    FROM Student
    GROUP BY Birthday
    HAVING COUNT(*) > 1
) dup ON s.Birthday = dup.Birthday
ORDER BY s.Birthday, s.StudentName;

SELECT 
    LEAST(PlayerA, PlayerB) AS Player1,
    GREATEST(PlayerA, PlayerB) AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY LEAST(PlayerA, PlayerB), GREATEST(PlayerA, PlayerB)
ORDER BY Player1, Player2;
