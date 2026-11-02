USE master;
GO

IF DB_ID(N'MyDB') IS NULL
    CREATE DATABASE MyDB;
GO

USE MyDB;
GO

/* Часть 1. Тестовые данные */
CREATE TABLE dbo.Groups
(
    GroupID int NOT NULL CONSTRAINT PK_Groups PRIMARY KEY,
    GroupName nvarchar(100) NOT NULL
);

CREATE TABLE dbo.Students
(
    StudentID int IDENTITY(1, 1) NOT NULL CONSTRAINT PK_Students PRIMARY KEY,
    FullName nvarchar(150) NOT NULL,
    GroupID int NOT NULL CONSTRAINT FK_Students_Groups
        FOREIGN KEY REFERENCES dbo.Groups(GroupID),
    PassportNumber varchar(20) NOT NULL,
    BirthDate date NOT NULL
);

CREATE TABLE dbo.Orders
(
    OrderID int NOT NULL CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerID int NOT NULL,
    Status varchar(30) NOT NULL,
    Total decimal(10, 2) NOT NULL
);

CREATE TABLE dbo.Employees
(
    EmployeeID int NOT NULL CONSTRAINT PK_Employees PRIMARY KEY,
    FullName nvarchar(150) NOT NULL,
    PositionName nvarchar(100) NOT NULL,
    Salary decimal(12, 2) NOT NULL
);
GO

INSERT dbo.Groups (GroupID, GroupName)
VALUES (1, N'IS-101'), (2, N'IS-102');

INSERT dbo.Students (FullName, GroupID, PassportNumber, BirthDate)
VALUES
    (N'Ivan Petrov', 1, '4010 123456', '2005-03-12'),
    (N'Anna Sidorova', 2, '4011 654321', '2005-10-25');

INSERT dbo.Orders (OrderID, CustomerID, Status, Total)
VALUES
    (1, 1, 'New', 1200.00),
    (2, 2, 'New', 850.00);

INSERT dbo.Employees (EmployeeID, FullName, PositionName, Salary)
VALUES
    (1, N'Olga Volkova', N'Manager', 95000.00),
    (2, N'Pavel Orlov', N'Analyst', 110000.00);
GO

CREATE VIEW dbo.StudentsPublic
AS
    SELECT FullName, GroupID
    FROM dbo.Students;
GO

CREATE VIEW dbo.EmployeesPublic
AS
    SELECT EmployeeID, FullName, PositionName
    FROM dbo.Employees;
GO

CREATE VIEW dbo.MyOrders
AS
    SELECT OrderID, CustomerID, Status, Total
    FROM dbo.Orders
    WHERE CustomerID = 1;
GO

CREATE USER Reader WITHOUT LOGIN;
CREATE USER Writer WITHOUT LOGIN;
GO

/* Задача 1. Reader имеет только SELECT, Writer имеет только INSERT. */
GRANT SELECT ON dbo.Students TO Reader;
GRANT INSERT ON dbo.Students TO Writer;
GO

EXECUTE AS USER = 'Reader';
SELECT * FROM dbo.Students;
BEGIN TRY
    INSERT dbo.Students (FullName, GroupID, PassportNumber, BirthDate)
    VALUES (N'Reader attempt', 1, '4000 000000', '2005-01-01');
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO

EXECUTE AS USER = 'Writer';
INSERT dbo.Students (FullName, GroupID, PassportNumber, BirthDate)
VALUES (N'Writer added student', 1, '4001 111111', '2005-04-05');
BEGIN TRY
    SELECT * FROM dbo.Students;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO

/* Задача 2. Reader читает публичное представление, но не таблицу Students. */
REVOKE SELECT ON dbo.Students FROM Reader;
GRANT SELECT ON dbo.StudentsPublic TO Reader;
GO

EXECUTE AS USER = 'Reader';
SELECT * FROM dbo.StudentsPublic;
BEGIN TRY
    SELECT * FROM dbo.Students;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO

/* Задача 3. Writer может добавлять заказы, но не удалять их. */
GRANT INSERT ON dbo.Orders TO Writer;
GRANT SELECT ON dbo.Orders TO Writer; -- Временно: требуется только для итоговой проверки задачи.
GO

EXECUTE AS USER = 'Writer';
INSERT dbo.Orders (OrderID, CustomerID, Status, Total)
VALUES (100, 1, 'New', 1500.00);
BEGIN TRY
    DELETE FROM dbo.Orders WHERE OrderID = 100;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
SELECT * FROM dbo.Orders WHERE OrderID = 100;
REVERT;
GO

/* Задача 4. Право на уровне столбца: можно менять только Orders.Status. */
GRANT UPDATE (Status) ON dbo.Orders TO Writer;
GO

EXECUTE AS USER = 'Writer';
UPDATE dbo.Orders SET Status = 'Paid' WHERE OrderID = 100;
BEGIN TRY
    UPDATE dbo.Orders SET Total = 1.00 WHERE OrderID = 100;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO

/* Задача 5. Reader видит данные сотрудников без Salary. */
GRANT SELECT ON dbo.EmployeesPublic TO Reader;
GO

EXECUTE AS USER = 'Reader';
SELECT * FROM dbo.EmployeesPublic;
BEGIN TRY
    SELECT * FROM dbo.Employees;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO

/* Задача 6. Reader не может создавать процедуры в MyDB. */
EXECUTE AS USER = 'Reader';
BEGIN TRY
    EXEC(N'CREATE PROCEDURE dbo.ReaderBlocked AS SELECT 1 AS Value;');
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO

/* Задача 7. Отзываем временное прямое чтение и открываем только заказы Writer. */
REVOKE SELECT ON dbo.Orders FROM Writer;
GRANT SELECT ON dbo.MyOrders TO Writer;
GO

EXECUTE AS USER = 'Writer';
SELECT * FROM dbo.MyOrders;
BEGIN TRY
    SELECT * FROM dbo.Orders;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO

/* Задача 8. Запрещённое изменение явно откатывается. */
SELECT Total AS TotalBeforeAttempt FROM dbo.Orders WHERE OrderID = 100;
GO

BEGIN TRANSACTION;
EXECUTE AS USER = 'Writer';
BEGIN TRY
    UPDATE dbo.Orders SET Total = 999999.00 WHERE OrderID = 100;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
ROLLBACK TRANSACTION;
GO

SELECT Total AS TotalAfterRollback FROM dbo.Orders WHERE OrderID = 100;
GO
