--- Ejercicios Adventure Works ---
--- Ejercicio 2 ---
WITH RankedSales AS(
	SELECT 
        SalesPersonID,
        MONTH(OrderDate) AS month,
        ROW_NUMBER() OVER (PARTITION BY MONTH(OrderDate) ORDER BY SUM(TotalDue) DESC) AS rank,
		SUM(TotalDue) as Total
    FROM 
        Sales.SalesOrderHeader
	WHERE SalesPersonID IS NOT NULL
    GROUP BY 
        SalesPersonID, MONTH(OrderDate)
)
SELECT SalesPersonID,month,Total FROM RankedSales WHERE rank = 1