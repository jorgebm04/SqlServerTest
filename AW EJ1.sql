--- Ejercicios Adventure Works ---
--- Ejercicio 1 ---
SELECT 
	ed.*,
	e.NationalIDNumber,
	e.JobTitle,
	e.Gender,
	e.HireDate
FROM HumanResources.EmployeeDepartmentHistory ed
	LEFT JOIN HumanResources.Employee e ON ed.BusinessEntityID = e.BusinessEntityID
WHERE 
	ed.DepartmentID IN (select DepartmentID FROM HumanResources.EmployeeDepartmentHistory WHERE EndDate IS NULL GROUP BY DepartmentID HAVING COUNT(DepartmentID) > 5)
	AND ed.EndDate IS NULL