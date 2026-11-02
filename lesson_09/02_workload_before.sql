/* Запускать при включённой трассировке Profiler до создания индексов. */
USE TrainingDB;
GO

/* Запрос A: фильтрация без индекса по Salary. */
SELECT *
FROM dbo.Employees
WHERE Salary > 50000;
GO 3

/* Запрос B: JOIN нескольких таблиц. */
SELECT e.FirstName, e.LastName, d.DepartmentName, p.ProjectName, t.HoursWorked
FROM dbo.Employees AS e
JOIN dbo.Departments AS d ON e.DepartmentID = d.DepartmentID
JOIN dbo.Timesheets AS t ON e.EmployeeID = t.EmployeeID
JOIN dbo.Projects AS p ON t.ProjectID = p.ProjectID
WHERE t.WorkDate BETWEEN '2023-01-01' AND '2023-12-31';
GO 3

/* Запрос C: агрегация по отделам. */
SELECT d.DepartmentName, AVG(e.Salary) AS AvgSalary, COUNT(*) AS EmployeeCount
FROM dbo.Departments AS d
JOIN dbo.Employees AS e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AvgSalary DESC;
GO 3
