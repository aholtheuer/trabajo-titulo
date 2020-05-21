# Base de Datos 1: Eliminación óptima

Se decidió crear un modelo de optimización que maximizara el tamaño de la matriz bajo la restricción de que no hubiera ningún dato faltante, teniendo como variables el poder eliminar filas y columnas de esta. La formulación matemática del problema de optimización se muestra en el Anexo F del informe disponible en el repositorio.

El problema de optimización fue resuelto ocupando el solver Gurobi. El modelo fue programado en Python, el cual accede a Gurobi a través de una licencia académica. Se obtuvo como resultado una matriz óptima de 10.311 empresas y 140 parámetros.
