# Отчёт по работе Безопасность в SQL Server

## Подготовка базы данных

### SQL-код

```sql
USE master;
GO
IF DB_ID(N'MyDB') IS NULL CREATE DATABASE MyDB;
GO
USE MyDB;
GO

CREATE TABLE dbo.Groups (GroupID int PRIMARY KEY, GroupName nvarchar(100) NOT NULL);
CREATE TABLE dbo.Students
(
    StudentID int IDENTITY(1,1) PRIMARY KEY,
    FullName nvarchar(150) NOT NULL,
    GroupID int NOT NULL REFERENCES dbo.Groups(GroupID),
    PassportNumber varchar(20) NOT NULL,
    BirthDate date NOT NULL
);
CREATE TABLE dbo.Orders
(
    OrderID int PRIMARY KEY, CustomerID int NOT NULL,
    Status varchar(30) NOT NULL, Total decimal(10,2) NOT NULL
);
CREATE TABLE dbo.Employees
(
    EmployeeID int PRIMARY KEY, FullName nvarchar(150) NOT NULL,
    PositionName nvarchar(100) NOT NULL, Salary decimal(12,2) NOT NULL
);

INSERT dbo.Groups VALUES (1, N'IS-101'), (2, N'IS-102');
INSERT dbo.Students (FullName, GroupID, PassportNumber, BirthDate)
VALUES (N'Ivan Petrov', 1, '4010 123456', '2005-03-12'),
       (N'Anna Sidorova', 2, '4011 654321', '2005-10-25');
INSERT dbo.Orders VALUES (1, 1, 'New', 1200.00), (2, 2, 'New', 850.00);
INSERT dbo.Employees VALUES (1, N'Olga Volkova', N'Manager', 95000.00),
                            (2, N'Pavel Orlov', N'Analyst', 110000.00);
GO

CREATE VIEW dbo.StudentsPublic AS
    SELECT FullName, GroupID FROM dbo.Students;
GO
CREATE VIEW dbo.EmployeesPublic AS
    SELECT EmployeeID, FullName, PositionName FROM dbo.Employees;
GO
CREATE VIEW dbo.MyOrders AS
    SELECT OrderID, CustomerID, Status, Total FROM dbo.Orders WHERE CustomerID = 1;
GO
CREATE USER Reader WITHOUT LOGIN;
CREATE USER Writer WITHOUT LOGIN;
GO
```

### Краткое пояснение

Созданы база данных MyDB, таблицы с тестовыми данными, представления с ограниченным набором столбцов и пользователи Reader и Writer.

## Задача 1 Создать пользователей и проверить их права

### SQL-код

```sql
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
```

Reader может читать Students, но не может добавлять строки. Writer может добавлять строки, но не может читать таблицу.

![[Pasted image 20261026093820.png]]

## Задача 2 Ограничение доступа через представление

### SQL-код

```sql
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
```

Reader видит только FullName и GroupID через представление StudentsPublic. Доступ к исходной таблице Students запрещён.

![[Pasted image 20261026093855.png]]
## Задача 3 Запрет удаления заказов

### SQL-код

```sql
GRANT INSERT ON dbo.Orders TO Writer;
GRANT SELECT ON dbo.Orders TO Writer;
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
```

Writer добавил заказ с номером 100. Удаление запрещено, так как право DELETE не выдавалось. Запись осталась в таблице.

![[Pasted image 20261026093925.png]]
## Задача 4 Разрешить обновлять только статус заказа

### SQL-код

```sql
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
```

Writer может обновлять только столбец Status. Попытка изменить Total вызывает ошибку отсутствия права UPDATE для этого столбца.

![[Pasted image 20261026094049.png]]
## Задача 5 Ограничить доступ к зарплатам сотрудников

### SQL-код

```sql
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
```

Представление EmployeesPublic не содержит Salary. Reader может читать представление, но не исходную таблицу Employees.

![[Pasted image 20261026094110.png]]
## Задача 6 Попытка эскалации прав

### SQL-код

```sql
EXECUTE AS USER = 'Reader';
BEGIN TRY
    EXEC(N'CREATE PROCEDURE dbo.ReaderBlocked AS SELECT 1 AS Value;');
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ExpectedError;
END CATCH;
REVERT;
GO
```

Reader не имеет права на создание процедуры в базе MyDB, поэтому SQL Server возвращает ошибку доступа.

![[Pasted image 20261026094134.png]]
## Задача 7 Ограничить доступ к удалённым данным

### SQL-код

```sql
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
```

MyOrders показывает Writer только заказы с CustomerID = 1. Прямое чтение Orders запрещено.

![[Pasted image 20261026094200.png]]
## Задача 8 Проверка отката при нарушении прав

### SQL-код

```sql
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
```

У Writer нет права изменять Total. Ошибка не меняет сумму, а ROLLBACK отменяет транзакцию. Значение Total до и после попытки остаётся одинаковым.

![[Pasted image 20261026094217.png]]