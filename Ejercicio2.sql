--- Ejercicio1: Crear tabla llamada Sales.InvoicesHeader ---
CREATE TABLE Countries
(
CountryId INT PRIMARY KEY IDENTITY (1,1),
CountryName VARCHAR(250)
)

CREATE TABLE Address
(
AddressId INT PRIMARY KEY IDENTITY (1,1),
Street VARCHAR(250),
CountryId INT FOREIGN KEY REFERENCES Countries(CountryId)
)

CREATE TABLE Customer
(
CustomerId INT PRIMARY KEY IDENTITY (1,1),
CustomerName VARCHAR(250)
)

-- Antes de crear esta tabla ha sido necesario crear el schema Sales en un fichero aparte para poder crear la tablla llamada Sales.InvoicesHeader con el comando CREATE SCHEMA Sales;
CREATE TABLE Sales.InvoicesHeader
(
InvoiceID INT PRIMARY KEY IDENTITY (1,1),
InvoiceDate DATETIME,
CustomerId INT FOREIGN KEY REFERENCES Customer(CustomerId),
AddressId INT FOREIGN KEY REFERENCES Address(AddressId),
TaxBase MONEY,
TotalVat MONEY,
Total MONEY
);

--- Ejercicio2: Creación de la tabla Sales.InvoicesDetail y sus dependientes ---

CREATE TABLE Product
(
ProductId INT PRIMARY KEY IDENTITY (1,1),
Description VARCHAR(MAX)
);

CREATE TABLE VatType
(
VatTypeId INT PRIMARY KEY IDENTITY(1,1),
Tax REAL
);

CREATE TABLE Sales.InvoicesDetail
(
InvoiceId INT PRIMARY KEY IDENTITY (1,1),
RefInvoiceHeader INT FOREIGN KEY REFERENCES Sales.InvoicesHeader(InvoiceId) NOT NULL,
RowNumber INT,
ProductId INT FOREIGN KEY REFERENCES Product(ProductId),
Description VARCHAR(MAX),
Quantity INT,
UnitPrice MONEY,
Discount REAL,
VatTypeId INT FOREIGN KEY REFERENCES VatType(VatTypeId),
TotalLine MONEY
);



--- Ejercicio Campo Calculado + Trigger
ALTER TABLE Sales.InvoicesHeader
DROP COLUMN Total

ALTER TABLE Sales.InvoicesHeader
ADD Total AS (TaxBase + TotalVat)

CREATE TRIGGER ActualizarTotalLine
ON Sales.InvoicesDetail
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Sales.InvoicesDetail
    SET TotalLine = (UnitPrice * ((100 - Discount)/100) + (UnitPrice * ((100 - Discount)/100) * v.Tax / 100))* Quantity
    FROM Sales.InvoicesDetail ide
    INNER JOIN VatType v ON ide.VatTypeId = v.VatTypeId;
END;




---Ejercicio Introducir datos de forma aleatoria
ALTER PROCEDURE [InsertaFacturas]
AS
BEGIN
	--Crea variables necesarias
	DECLARE @i INT = 1;
	DECLARE @j INT = 1;
	DECLARE @FechaInicio DATE = '2020-01-01';
	DECLARE @FechaFin DATE = '2024-12-31';
	DECLARE @DiasAleatorios INT;

	---- Introduce valores en la tabla de los IVA (Primero elimino los registros para asegurarme que está vacía y que su ID empieza en 1)
	DELETE FROM VatType
	DBCC CHECKIDENT('VatType',RESEED,0) 
	INSERT INTO VatType VALUES (21),(10),(3)

	---- Introduce valores en la tabla customer
	DELETE FROM Customer
	DBCC CHECKIDENT('Customer',RESEED,0) 
	INSERT INTO Customer VALUES ('Customer 1'),('Customer 2'),('Customer 3')

	---- Introduce valores en la tabla Countries
	DELETE FROM Countries
	DBCC CHECKIDENT('Countries',RESEED,0) 
	INSERT INTO Countries VALUES ('España'),('Francia'),('Italia')

	---- Introduce valores en la tabla Address
	DELETE FROM Address
	DBCC CHECKIDENT('Address',RESEED,0) 
	INSERT INTO Address VALUES ('Calle 1',1),('Calle 2',2),('Calle 3',3)

	----Introduce valores en la tabla Product
	DELETE FROM Product
	DBCC CHECKIDENT('Product',RESEED,0) 
	INSERT INTO Product VALUES ('Product 1'),('Product 2'),('Product 3')

	--Limpio las tablas de Invoices Header y Detail
	DELETE FROM Sales.InvoicesHeader
	DBCC CHECKIDENT('Sales.InvoicesHeader',RESEED,0) 

	DELETE FROM Sales.InvoicesDetail
	DBCC CHECKIDENT('Sales.InvoicesDetail',RESEED,0) 

	--Bucle para las facturas
	WHILE @i <= 10000
	BEGIN

		-- Calcular un número de días aleatorio entre las fechas de inicio y fin
		SET @DiasAleatorios = ABS(CHECKSUM(NEWID())) % (DATEDIFF(day, @FechaInicio, @FechaFin) + 1);

		-- Introduce datos aleatorios en las facturas
		INSERT INTO Sales.InvoicesHeader(InvoiceDate,CustomerId,AddressId,TaxBase,TotalVat)
		VALUES (DATEADD(day, @DiasAleatorios, @FechaInicio),FLOOR(1+RAND()*3),FLOOR(1+RAND()*3),CAST(ROUND(RAND() * 1000, 2) AS MONEY),CAST(ROUND(RAND() * 1000, 2) AS MONEY));

		-- Bucle para las lineas de la factura
		WHILE @j <= 50
		BEGIN
			INSERT INTO Sales.InvoicesDetail(RefInvoiceHeader,RowNumber,ProductId,Description,Quantity,UnitPrice,Discount,VatTypeId)
			VALUES(@i,@j,FLOOR(1+RAND()*3),'Description',FLOOR(1+RAND()*50),CAST(ROUND(RAND() * 1000, 2) AS MONEY),FLOOR(1+RAND()*100),FLOOR(1+RAND()*3))

			SET @j = @j + 1;
		END

		--Resetea el contador de las lineas para la siguiente factura
		SET @j = 1
		SET @i = @i + 1;
	END
END

select * from Sales.InvoicesHeader
select * from Sales.InvoicesDetail
select * from VatType
