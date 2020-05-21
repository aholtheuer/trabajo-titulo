# Recolección de Datos

La obtención de parámetros se basó en los conceptos más relevantes encontrados en el libro 󠇝“*The Intelligent Investor*”, escrito por Benjamin Graham, los que se detallan en el Anexo C del informe. Siguiendo estos conceptos, se consideraron 234 parámetros relacionados, los cuales se enlistan en el Anexo D. 

Los datos fueron obtenidos de la terminal Bloomberg. Se obtuvo la información financiera de los miembros del índice S&P 500 desde 1990 hasta 2017. Para cada una de las empresas se obtuvo el valor de los 234 parámetros para el año fiscal correspondiente, es decir, la extracción de la información para un miembro del S&P 500 en un año en particular se hace en el mes que esa empresa específica liberó su reporte anual de ese año. Siguiendo así fielmente el año fiscal de cada empresa para hacer la clasificación apenas se tenga la información. Como resultado se obtuvo una matriz que cuenta con 234 columnas y 13.977 filas, donde cada columna representa un parámetro y cada fila representa una observación de un miembro del S&P 500 para un año específico.

> **Nota a mejorar:**
>
> No se hizo un buen manejo de *feature selection*, se tenía la idea de que la regularización iba a ser capaz de seleccionar los parámetros relevantes para la clasificación, por lo que se utilizó una cantidad importante de parámetros relacionados sin considerar el efecto en la red. Se recomienda probar otros algoritmos de *feature selection* para reducir los parámetros y también métodos de *feature engineering* que podrían dar mejores resultados de clasificación. 

## Consideraciones

Por temas legales no se puede subir la información obtenida de Bloomberg, la que se encontraría disponible en el archivo `data_na.csv`.
