
# Base de Datos 3: Imputación

La imputación múltiple se refiere a la predicción de datos perdidos simultáneamente en más de una variable. Existen dos métodos para la solución de este problema, Modelación Conjunta o Imputación Multivariada por Ecuaciones Encadenadas (JM y MICE por sus siglas en inglés). En este trabajo se utilizó MICE debido a que JM requiere supuestos de que la base de datos distribuye normal multivariante, lo cual es un supuesto bastante fuerte para las 234 variables que presenta la base de datos (y, por esta razón, MICE es el método más ocupado en la literatura). 

Se utilizó el lenguaje de programación R, que se enfoca en el análisis estadístico, en donde se ocupó la librería *mice* y se obtuvo la tercera base de datos, la cual presenta la cantidad de filas y matrices de la base de datos original y que tiene un 14,9% de sus datos estimados.
