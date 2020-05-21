# Base de Datos 2: Eliminación óptima con parámetros fijos

La Base de Datos 1 presenta el problema de que se eliminan variables que eran fundamentales para la inversión en valor. Por esta razón se decidió modificar el problema de minimización del Anexo F, agregando restricciones que fijan 8 variables relevantes en la matriz resultante que, según Graham en su libro *The Intelligent Investor*, son las fundamentales que un inversor defensivo debiera evaluar para invertir en una empresa. En el Anexo F del informe se muestra el cambio a la formulación matemática del modelo.

El modelo también fue programado en Python y resuelto con el solver Gurobi. La matriz resultante quedó de un tamaño de 4.976 empresas y 165 parámetros.
