--- Ejercicio 10 ---
/*
En este ejemplo obtenemos la cantidad total vendida de cada producto dentro de un CTE y posteriormente hacemos un join con la tabal de productus para saber el nombre de cada producto y la cantidad total vendida
*/
WITH ProductSales AS (
    SELECT ProductID, SUM(OrderQty) AS TotalSales
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
)
SELECT p.ProductID, p.Name AS ProductName, ps.TotalSales
FROM Production.Product AS p
JOIN ProductSales AS ps ON p.ProductID = ps.ProductID;
