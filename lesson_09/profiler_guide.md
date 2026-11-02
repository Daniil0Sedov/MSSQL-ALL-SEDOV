# SQL Server Profiler

1. Запусти [01_setup_trainingdb.sql](01_setup_trainingdb.sql) в SSMS.
2. В SSMS выбери `Tools` -> `SQL Server Profiler`, подключись к тому же экземпляру SQL Server.
3. В поле `Trace name` укажи `TrainingDB_Profiler_2019`, в `Use template` выбери `Blank`.
4. Открой `Events Selection` и добавь события: `RPC:Completed`, `SQL:BatchCompleted`, `ShowplanStatisticsProfile`, `ShowplanXMLStatisticsProfile`, `Lock:Acquired`.
5. Оставь столбцы `TextData`, `Duration`, `Reads`, `CPU`. В `Column Filters` задай `DatabaseName Like TrainingDB` и `Duration Greater than or equal 100`.
6. Нажми `Run`, перейди в SSMS и выполни [02_workload_before.sql](02_workload_before.sql). Каждый запрос запустится три раза.
7. Останови трассировку. Отсортируй `Duration` по убыванию и запиши показатели в отчёт. Сделай скриншот.
8. Повтори пункты 2-5 с теми же фильтрами, затем выполни [03_create_indexes.sql](03_create_indexes.sql) и [04_workload_after.sql](04_workload_after.sql). Останови трассировку, запиши новые показатели и сделай скриншот.

Если запросы не попали в трассировку, временно замени фильтр `Duration >= 100` на `Duration >= 0`: на небольшом учебном наборе из 500 и 2000 строк запросы могут выполняться быстрее 100 мс. В отчёте укажи, что порог был снижен из-за малого объёма тестовых данных.
