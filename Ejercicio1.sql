--- Ejercicio 1: Crear Base de Datos ---

CREATE DATABASE smcdb1 COLLATE Modern_spanish_ci_ai;

--- Ejercicio 2: Crear Tabla Test en la Base de Datos ---

-- Cambiar al contexto de la base de datos deseada
USE smcdb1;

-- Crear la tabla sin columnas inicialmente
CREATE TABLE Test (
    Code CHAR(10) PRIMARY KEY
);

--- Ejercicio 3: Crear Segunda Base de Datos

CREATE DATABASE smcdb2 COLLATE Latin1_general_cs_as;

--- Ejercicio 4: Crear campos en la tabla Test de todos los tipos ---
-- Añadir columnas después de crear la tabla
ALTER TABLE Test
ADD varchar_field VARCHAR(255),
char_field CHAR(10),
text_field TEXT,
int_field INT,
bigint_field BIGINT,
smallint_field SMALLINT,
decimal_field DECIMAL(10,2),
numeric_field NUMERIC(10,2),
float_field FLOAT,
real_field REAL,
double_field DOUBLE PRECISION,
date_field DATE,
datetime_field DATETIME,
time_field TIME,
timestamp_field TIMESTAMP,
binary_field BINARY(255),
varbinary_field VARBINARY(255),
ID UNIQUEIDENTIFIER DEFAULT NEWID(),
price MONEY

select * from Test

--- Ejercicio 5 :Introducir valores de prueba en la tabla Test ---
INSERT INTO Test (
	Code,
    varchar_field,
    char_field,
    text_field,
    int_field,
    bigint_field,
    smallint_field,
    decimal_field,
    numeric_field,
    float_field,
    real_field,
    double_field,
    date_field,
    datetime_field,
    time_field,
    binary_field,
    varbinary_field,
    ID,
    price
) VALUES (
	'123456',
    'Ejemplo de cadena de caracteres',
    'Ejemplo',
    'Ejemplo de texto largo',
    123,
    1234567890,
    123,
    123.45,
    123.45,
    123.45,
    123.45,
    123.45,
    '2022-01-01',
    '2022-01-01 12:00:00',
    '2022-01-01 12:00:00',
    0x1234567890ABCDEF,
    0x1234567890ABCDEF,
    NEWID(),
    123.45
);

--- Ejercicio 6: Copiar tabla de la base de datos smcdb1 a smcdb2 ---
SELECT * INTO smcdb2.dbo.Test FROM smcdb1.dbo.Test

select * from smcdb1.dbo.Test
select * from smcdb2.dbo.Test

--- Ejercicio 7: Joins entre las tablas de la base de datos
select 
	t1.int_field,
	t1.datetime_field ,
	t2.text_field
from smcdb1.dbo.Test t1
join smcdb2.dbo.Test t2 on t1.Code = t2.Code

