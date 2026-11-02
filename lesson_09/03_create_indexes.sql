/* Создание индексов для этапа оптимизации. Запускается один раз. */
USE TrainingDB;
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.Employees') AND name = N'IX_Employees_Salary'
)
    CREATE INDEX IX_Employees_Salary ON dbo.Employees(Salary);
GO

IF NOT EXISTS
(
    SELECT 1 FROM sys.indexes
    WHERE object_id = OBJECT_ID(N'dbo.Timesheets') AND name = N'IX_Timesheets_WorkDate'
)
    CREATE INDEX IX_Timesheets_WorkDate ON dbo.Timesheets(WorkDate);
GO
