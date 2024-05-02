--- Ejercicio 7 ---
/*
Este bloque de código comienza con un bloque TRY que contiene la lógica de la transacción. 
Dentro de este bloque, comienza una transacción utilizando BEGIN TRANSACTION. Luego se realiza la actualización de la tabla. 
Si la actualización tiene éxito, la transacción se confirma utilizando COMMIT TRANSACTION.

Si ocurre un error durante la actualización, el control se transfiere al bloque CATCH. 
En este bloque, primero se verifica si existe una transacción activa y, si es así, se deshace con ROLLBACK TRANSACTION. 
Luego, se captura información sobre el error utilizando las funciones ERROR_MESSAGE(), ERROR_SEVERITY() y ERROR_STATE(), 
que se pueden usar para registrar detalles del error en una tabla de registro de errores o para mostrar un mensaje de error personalizado.

El bloque CATCH también ofrece la oportunidad de lanzar una nueva excepción utilizando la instrucción THROW, 
si es necesario. Si no, simplemente se puede imprimir un mensaje de error utilizando PRINT.

*/
BEGIN TRY
    BEGIN TRANSACTION;

    -- La consulta de actualización aquí
    UPDATE MiTabla
    SET MiColumna = 'NuevoValor'
    WHERE Condicion = 'Algo';

    -- Si todo va bien, confirmamos la transacción
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Si ocurre un error, deshacemos la transacción
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

    -- Se pueden realizar acciones según el tipo de error, su gravedad, etc.
    -- Por ejemplo, registrar el error en una tabla de registro de errores.
    INSERT INTO ErrorLog (ErrorMessage, ErrorSeverity, ErrorState)
    VALUES (@ErrorMessage, @ErrorSeverity, @ErrorState);

    -- También se puede lanzar una nueva excepción, si es necesario
    -- THROW;

    -- O simplemente devolver un mensaje de error
    PRINT 'Se ha producido un error: ' + @ErrorMessage;
END CATCH;
