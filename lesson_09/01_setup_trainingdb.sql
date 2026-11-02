/* Подготовка учебной базы TrainingDB. Запускается один раз. */
USE master;
GO

IF DB_ID(N'TrainingDB') IS NULL
    CREATE DATABASE TrainingDB;
GO

USE TrainingDB;
GO

IF OBJECT_ID(N'dbo.Departments', N'U') IS NULL
CREATE TABLE dbo.Departments
(
    DepartmentID int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Departments PRIMARY KEY,
    DepartmentName nvarchar(100) NOT NULL
);

IF OBJECT_ID(N'dbo.Employees', N'U') IS NULL
CREATE TABLE dbo.Employees
(
    EmployeeID int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Employees PRIMARY KEY,
    FirstName nvarchar(50),
    LastName nvarchar(50),
    DepartmentID int FOREIGN KEY REFERENCES dbo.Departments(DepartmentID),
    Salary decimal(10, 2),
    HireDate date
);

IF OBJECT_ID(N'dbo.Projects', N'U') IS NULL
CREATE TABLE dbo.Projects
(
    ProjectID int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Projects PRIMARY KEY,
    ProjectName nvarchar(100),
    StartDate date,
    EndDate date
);

IF OBJECT_ID(N'dbo.Timesheets', N'U') IS NULL
CREATE TABLE dbo.Timesheets
(
    TimesheetID int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Timesheets PRIMARY KEY,
    EmployeeID int FOREIGN KEY REFERENCES dbo.Employees(EmployeeID),
    ProjectID int FOREIGN KEY REFERENCES dbo.Projects(ProjectID),
    WorkDate date,
    HoursWorked decimal(5, 2)
);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Departments)
    INSERT dbo.Departments (DepartmentName)
    VALUES (N'HR'), (N'Finance'), (N'IT'), (N'Sales'), (N'Marketing');

IF NOT EXISTS (SELECT 1 FROM dbo.Employees)
BEGIN
    WITH N AS
    (
        SELECT TOP (500) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.objects AS o1 CROSS JOIN sys.objects AS o2
    )
    INSERT dbo.Employees (FirstName, LastName, DepartmentID, Salary, HireDate)
    SELECT
        N'Employee' + CAST(n AS nvarchar(10)),
        N'Surname' + CAST(n AS nvarchar(10)),
        ABS(CHECKSUM(NEWID()) % 5) + 1,
        CAST(20000 + ABS(CHECKSUM(NEWID()) % 60000) AS decimal(10, 2)),
        DATEADD(day, ABS(CHECKSUM(NEWID()) % 1000), '2022-01-01')
    FROM N;
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Projects)
    INSERT dbo.Projects (ProjectName, StartDate, EndDate)
    VALUES
        (N'Project Alpha', '2023-01-01', '2024-01-01'),
        (N'Project Beta', '2023-03-01', '2024-06-01'),
        (N'Project Gamma', '2023-06-01', '2024-12-01');

IF NOT EXISTS (SELECT 1 FROM dbo.Timesheets)
BEGIN
    WITH N AS
    (
        SELECT TOP (2000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.objects AS o1 CROSS JOIN sys.objects AS o2
    )
    INSERT dbo.Timesheets (EmployeeID, ProjectID, WorkDate, HoursWorked)
    SELECT
        ABS(CHECKSUM(NEWID()) % 500) + 1,
        ABS(CHECKSUM(NEWID()) % 3) + 1,
        DATEADD(day, ABS(CHECKSUM(NEWID()) % 365), '2023-01-01'),
        CAST(4 + ABS(CHECKSUM(NEWID()) % 5) AS decimal(5, 2))
    FROM N;
END;
GO

SELECT
    (SELECT COUNT(*) FROM dbo.Departments) AS Departments,
    (SELECT COUNT(*) FROM dbo.Employees) AS Employees,
    (SELECT COUNT(*) FROM dbo.Projects) AS Projects,
    (SELECT COUNT(*) FROM dbo.Timesheets) AS Timesheets;
GO
