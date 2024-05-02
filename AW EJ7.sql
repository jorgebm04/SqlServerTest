--- Ejercicio 7 ---
/*
Este bloque de c�digo comienza con un bloque TRY que contiene la l�gica de la transacci�n. 
Dentro de este bloque, comienza una transacci�n utilizando BEGIN TRANSACTION. Luego se realiza la actualizaci�n de la tabla. 
Si la actualizaci�n tiene �xito, la transacci�n se confirma utilizando COMMIT TRANSACTION.

Si ocurre un error durante la actualizaci�n, el control se transfiere al bloque CATCH. 
En este bloque, primero se verifica si existe una transacci�n activa y, si es as�, se deshace con ROLLBACK TRANSACTION. 
Luego, se captura informaci�n sobre el error utilizando las funciones ERROR_MESSAGE(), ERROR_SEVERITY() y ERROR_STATE(), 
que se pueden usar para registrar detalles del error en una tabla de registro de errores o para mostrar un mensaje de error personalizado.

El bloque CATCH tambi�n ofrece la oportunidad de lanzar una nueva excepci�n utilizando la instrucci�n THROW, 
si es necesario. Si no, simplemente se puede imprimir un mensaje de error utilizando PRINT.

*/
BEGIN TRY
    BEGIN TRANSACTION;

    -- La consulta de actualizaci�n aqu�
    UPDATE MiTabla
    SET MiColumna = 'NuevoValor'
    WHERE Condicion = 'Algo';

    -- Si todo va bien, confirmamos la transacci�n
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Si ocurre un error, deshacemos la transacci�n
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Manejo del error
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Se pueden realizar acciones seg�n el tipo de error, su gravedad, etc.
    -- Por ejemplo, registrar el error en una tabla de registro de errores.
    INSERT INTO ErrorLog (ErrorMessage, ErrorSeverity, ErrorState)
    VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState);

    -- Tambi�n se puede lanzar una nueva excepci�n, si es necesario
    -- THROW;

    -- O simplemente devolver un mensaje de error
    PRINT 'Se ha producido un error: ' + @ErrorMessage;
END CATCH;
