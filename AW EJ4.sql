--- Ejercicios Adventure Works ---
--- Ejercicio 4 ---
SELECT
    soh.TerritoryID,
    st.Name,
    COUNT(SalesOrderID) [N Sales]
FROM 
    Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY soh.TerritoryID, st.Name