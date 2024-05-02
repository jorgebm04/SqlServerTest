--- Ejercicio 9 ---
SELECT ProductID, OrderQty, 'Q' + CAST(DATEPART(QUARTER, OrderDate) AS VARCHAR(2)) AS Quarter
    FROM Sales.SalesOrderDetail sod
		INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID

SELECT *
FROM (
    SELECT ProductID, OrderQty, 'Q' + CAST(DATEPART(QUARTER, OrderDate) AS VARCHAR(2)) AS Quarter
    FROM Sales.SalesOrderDetail sod
		INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
) AS SourceTable
PIVOT (
    SUM(OrderQty)
    FOR Quarter IN ([Q1], [Q2], [Q3], [Q4])
) AS PivotTable;

