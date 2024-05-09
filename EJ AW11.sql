/*
Supongamos que tenemos una tabla llamada employees con columnas para el nombre del empleado, 
el departamento y el responsable. Esto se muestra en la siguiente tabla, donde cada registro incluye un empleado y a quién reporta dentro de la organización.

id      name            department	    manager_id	    manager_name
124     John Doe        IT	            135	            Jane Miller
135     Jane Miller	    HR	            146	            Sarah Smith
146     Sarah Smith	    CEO	            NULL	        NULL

De un vistazo, es bastante fácil ver quién depende de quién y cómo es esta jerarquía organizativa. Sin embargo, si tuviéramos cientos de empleados, sería mucho más difícil dar sentido a los datos.

Podemos utilizar un CTE recursivo para generar un árbol jerárquico de los empleados de la empresa. Para ello, ejecutaríamos esta consulta:

WITH employee_manager_cte AS (
  SELECT
    id,
    name,
    department,
    manager_id,
    manager_name,
    1 AS level
  FROM employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT
    e.id,
    e.name,
    e.department,
    e.manager_id,
    e.manager_name,
    level + 1
  FROM employees e
  INNER JOIN employee_manager_cte r
    ON e.manager_id = r.id
)
SELECT *
FROM employee_manager_cte;

Desglosemos esta consulta paso a paso.

En primer lugar, definimos la ETC recursiva con el nombre employee_manager_cte. Seleccionamos las columnas que queremos incluir en la consulta: id, name, department, manager_id, manager_name, y level. 

La columna level se utiliza para seguir la profundidad del árbol. Empezaremos por el nivel 1; a medida que avancemos en el bucle, este número irá aumentando.

Esta sección antes de UNION ALL se denomina miembro ancla. En el miembro ancla, comenzamos nuestro bucle. En nuestro ejemplo, seleccionamos todos los empleados cuyo manager es NULL. 
En nuestro organigrama, serán los empleados de la parte superior. En este caso, sólo hay un empleado en este nivel: Sarah Smith, la directora general.

La parte que sigue a UNION ALL se denomina miembro recursivo. En el miembro recursivo, añadimos nuevas filas a las filas que ya se han calculado. 
En nuestro ejemplo, unimos la tabla employees con el CTE employee_manager_cte en la columna manager_id. Esto crea un bucle que recorre el árbol de arriba hacia abajo. 
Añadimos 1 a la columna level para registrar la profundidad de cada nodo.

Por último, seleccionamos todas las columnas de employee_manager_cte CTE.

Al ejecutar esta consulta, SQL Server procesa primero el miembro de anclaje, que selecciona a Sarah Smith como raíz del árbol. 
A continuación, procesa el miembro recursivo, que une a Sarah Smith con su informe directo (Jane Miller). A continuación, une a Jane Miller con su subordinado directo (John Doe) y a John Doe con su subordinado directo (ninguno). 
Como no hay más filas que añadir al conjunto de resultados, SQL Server deja de procesar la CTE y devuelve el resultado final.

Este es el aspecto del conjunto de resultados:

id	    name	        department	    manager_id	    manager	        level
146	    Sarah Smith	    CEO	            NULL	        NULL	        1
135	    Jane Miller	    HR	            146	            Sarah Smith	    2
124	    John Doe	    IT	            135	            Jane Miller	    3    
*/
