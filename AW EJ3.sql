--- Ejercicios Adventure Works ---
--- Ejercicio 3 ---
SELECT
    ProductId,
    SUM(OrderQty) as [Sum Qty]
FROM 
    Sales.SalesOrderDetail
GROUP BY ProductId
ORDER BY SUM(OrderQty) ASC