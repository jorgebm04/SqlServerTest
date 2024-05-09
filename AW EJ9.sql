--- Ejercicio 9 PIVOT ---
/*
En este ejemplo se pivota la tabla que se genera en la primera query, que muestra en 3 columnas el productId, la quantity y el quarter en el que se produce la venta, 
para obtener en las columnas los quarter y saber la cantidad de cada producto por quarter.

SELECT
    <non-pivoted column>, -- Columnas no afectadas por la rotación
    [<pivoted column1>, ...], -- Columnas que se rotarán
    ...
FROM 
    (<source_table>) AS <alias>
PIVOT
(
    <aggregate_function>(<pivot_column>)
    FOR <pivot_column> IN ([<value1>, <value2>, ...])
) AS <pivot_alias>;

- <non-pivoted column>: Son las columnas que no se verán afectadas por la rotación y permanecerán como están en la tabla original.
- <pivoted column>: Son las columnas que se rotarán, es decir, cuyos valores se convertirán en nombres de columna en la salida final.
- <source_table>: Es la tabla de origen de la que se extraen los datos para realizar la rotación.
- <alias>: Es un alias opcional que se utiliza para hacer referencia a <source_table>.
- <aggregate_function>: Es una función de agregación como SUM, COUNT, AVG, etc., que se utilizará para resumir los valores de las columnas pivote si hay duplicados.
- <pivot_column>: Es la columna cuyos valores se convertirán en nombres de columna en la salida final.
- <value1>, <value2>, ...: Son los valores únicos de <pivot_column> que se convertirán en nombres de columna en la salida final.
- <pivot_alias>: Es un alias opcional para la tabla resultante después de la rotación.
*/
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

--- Ejercicio 9 UNPIVOT ---
/*
En este caso utilizamos la función UNPIVOT para transformar las columnas SubTotal, TaxAmt, TotalDue en filas.

SELECT 
    <non-unpivoted column>, -- Columnas no afectadas por la rotación
    <unpivoted column>, -- Nueva columna que contendrá los valores rotados
    <value_column> -- Columna que contiene los valores a rotar
FROM 
    (<source_table>) AS <alias>
UNPIVOT
(
    <value_column> FOR <unpivoted column> IN ([<value1>, <value2>, ...])
) AS <unpivot_alias>;

- <non-unpivoted column>: Son las columnas que no se verán afectadas por la rotación y permanecerán como están en la tabla original.
- <unpivoted column>: Es la nueva columna que contendrá los valores rotados, es decir, los nombres de las columnas que se rotarán.
- <value_column>: Es la columna que contiene los valores a rotar.
- <source_table>: Es la tabla de origen de la que se extraen los datos para realizar la rotación.
- <alias>: Es un alias opcional que se utiliza para hacer referencia a <source_table>.
- <value1>, <value2>, ...: Son los nombres de las columnas que se rotarán y se convertirán en valores de la columna <unpivoted column> en la salida final.
- <unpivot_alias>: Es un alias opcional para la tabla resultante después de la rotación.
*/
SELECT * FROM Sales.SalesOrderHeader

SELECT SalesOrderID, AmountType, Amount
FROM 
    (SELECT SalesOrderID, SubTotal, TaxAmt, TotalDue FROM Sales.SalesOrderHeader) AS SourceTable
UNPIVOT
(
    Amount FOR AmountType IN (SubTotal, TaxAmt, TotalDue)
) AS UnpivotTable;
