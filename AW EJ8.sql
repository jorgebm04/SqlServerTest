--- Ejercicio 8 ---
/*
 Las cláusulas WHERE y HAVING actúan como filtros; eliminan del resultado final de una consulta los registros o datos que no cumplen determinados criterios. 
 Sin embargo, se aplican a conjuntos de datos diferentes. Este es el punto importante que hay que entender sobre WHERE frente a HAVING: 
 WHERE filtra a nivel de registro, mientras que HAVING filtra a nivel de "grupo de registros".
*/
--- Suma y promedio de total de ventas por año y trimestre ---
SELECT 
    DATEPART(YEAR, OrderDate) AS OrderYear,
    DATEPART(QUARTER, OrderDate) AS OrderQuarter,
    SUM(TotalDue) AS TotalSales,
    AVG(TotalDue) AS AvgSales
FROM 
    Sales.SalesOrderHeader
GROUP BY 
    DATEPART(YEAR, OrderDate), 
    DATEPART(QUARTER, OrderDate)
ORDER BY
	OrderYear;

--- Clientes con más de 10 pedidos ---
SELECT 
    CustomerID,
    COUNT(*) AS NumOrders
FROM 
    Sales.SalesOrderHeader
GROUP BY 
    CustomerID
HAVING 
    COUNT(*) > 10;

--- Productos con un inventario promedio superior a 100 unidades ---
SELECT 
    ProductID,
    AVG(Quantity) AS AvgInventory
FROM 
    Production.ProductInventory
GROUP BY 
    ProductID
HAVING 
    AVG(Quantity) > 100;

--- Cantidad total de unidades vendidas por producto con más de 500 unidades vendidas ---
SELECT 
    ProductID,
    SUM(OrderQty) AS TotalUnitsSold
FROM 
    Sales.SalesOrderDetail
GROUP BY 
    ProductID
HAVING 
    SUM(OrderQty) > 500;

--- Territorios con un promedio de ventas superior a 5000$ ---
SELECT 
    st.TerritoryID,
	st.Name,
    AVG(TotalDue) AS AvgMonthlySales
FROM 
    Sales.SalesOrderHeader soh
INNER JOIN 
    Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY 
    st.TerritoryID,st.Name
HAVING 
    AVG(TotalDue) > 5000;
