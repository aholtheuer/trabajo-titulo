# INVESTIGACIÓN, ANÁLISIS Y MODELACIÓN APLICADA EN EL ESTUDIO DE INGENIERÍA FINANCIERA EN 󠇝"VALUE INVESTING"

> Trabajo de Título para optar al título de Ingeniero Civil de Industrias, Diploma en Ingeniería Ambiental en la Pontificia Universidad Católica de Chile.

### Consideraciones

- Este repositorio fue creado una vez terminado el trabajo de título.
- Los Datos fueron extraídos de la terminal Bloomberg disponible en el Laboratorio de Finanzas de la Universidad Católica; por temas legales no pueden ser compartidos.
- El propósito del estudiante en esta investigación fue entender el funcionamiento de una *multilayer perceptron nural network* por lo que esta fue desarrollada completamente por el estudiante (a excepción del método de descenso del gradiente) para luego probarla en la predicción de rentabilidad de acciones de empresas miembros del SP500. 
- La red neuronal fue programada en *Octave* debido a su buen manejo con vectores y matrices. Se eligió *Octave* sobre *Matlab* debido a que este último no es un software libre.
 
## Resumen Ejecutivo

Este Trabajo de Título tiene como objetivo el desarrollo de un **modelo predictivo basado en Inteligencia Artificial, que genere automáticamente un portafolio de acciones que supere el índice de mercado**, en base a los parámetros financieros claves según la filosofía de inversión Value 󠇝Investing.

Este trabajo se puede dividir en tres procesos. En primer lugar, se trabajó en la recolección de datos, que incluye la revisión bibliográfica de la filosofía de inversión en valor, la extracción de los parámetros claves del software financiero Bloomberg y el manejo de los datos faltantes de la matriz obtenida. Luego, se construyó el modelo de selección de acciones (MSA) ocupando métodos de Machine Learning. Específicamente se generó una red neuronal artificial, la cual fue entrenada, validada y testeada para clasificar las empresas sobresalientes de las no sobresalientes. Por último, se realizaron evaluaciones financieras, midiendo la rentabilidad y el alfa del portafolio versus el S&P 500.

Los resultados mostraron qué, si bien los portafolios creados obtuvieron bajos resultados de clasificación, generalmente obtienen resultados positivos de rentabilidad frente al índice de mercado. Desafortunadamente, no existe suficiente evidencia estadística para asegurar que estos resultados no se dieron por chance.

En conclusión, no se recomienda invertir en el portafolio que genera el MSA por sobre el índice de mercado; ya que las diferencias obtenidas no son lo suficientemente robustas para poder pensar que se mantendrán en el tiempo. 

# Resumen Informe

A continuación se presenta un resumen del informe del trabajo de título con la información de las principales decisiones que se tuvieron que tomar en la investigación, en donde se agregan notas a mejorar. 

Si se desea mayor información, se recomienda visitar el informe completo disponible en el repositorio.

## Recolección de Datos

**FALTA EXPLICAR QUE LOS PARÁMETROS SE SACARON DE GRAHAM**
Los datos fueron obtenidos de la terminal Bloomberg. Se obtuvo la información financiera de los miembros del índice S&P 500 desde 1990 hasta 2017. Para cada una de las empresas se obtuvo el valor de los 234 parámetros para el año fiscal correspondiente, es decir, la extracción de la información para un miembro del S&P 500 en un año en particular se hace en el mes que esa empresa específica liberó su reporte anual de ese año. Siguiendo así fielmente el año fiscal de cada empresa para hacer la clasificación apenas se tenga la información. Como resultado se obtuvo una matriz que cuenta con 234 columnas y 13.977 filas, donde cada columna representa un parámetro y cada fila representa una observación de un miembro del S&P 500 para un año específico.

Por temas legales no se puede subir la información obtenida de Bloomberg.

> **Nota a mejorar:**
>
> No se hizo un buen manejo de *feature engineering*, se tenía la idea de que la red neuronal iba a ser capaz de seleccionar los parámetros relevantes para la clasificación, por lo que se seleccionó una cantidad importante de parámetros relacionados sin considerar el efecto en la red. **Que se debería hacer?**

## Preprocesamiento

### Datos Faltantes

La literatura especializada recomienda dos posibles estrategias para solucionar este problema: imputar la matriz o eliminar los datos faltantes de manera óptima. Como no existe concenso en la literatura se optó por considerar la Base de Datos como un un hyper parámetro y decidir cuál de estas genera un mejor modelo a través del proceso de validación. Se construyeron tres bases de datos:

**1. Base de Datos 1: Eliminación óptima**

Se decidió crear un modelo de optimización que maximizara el tamaño de la matriz bajo la restricción de que no hubiera ningún dato faltante, teniendo como variables el poder eliminar filas y columnas de esta. La formulación matemática del problema de optimización se muestra en el Anexo F del informe disponible en el repositorio.

El problema de optimización fue resuelto ocupando el solver Gurobi. El modelo fue programado en Python, el cual accede a Gurobi a través de una licencia académica. Se obtuvo como resultado una matriz óptima de 10.311 empresas y 140 parámetros.

**2. Base de Datos 2: Eliminación óptima con parámetros fijos**

La Base de Datos 1 presenta el problema de que se eliminan variables que eran fundamentales para la inversión en valor. Por esta razón se decidió modificar el problema de minimización del Anexo F, agregando restricciones que fijan 8 variables relevantes en la matriz resultante que, según Graham en su libro *The Intelligent Investor*, son las fundamentales que un inversor defensivo debiera evaluar para invertir en una empresa. En el Anexo F se muestra el cambio a la formulación matemática del modelo.

El modelo también fue programado en Python y resuelto con el solver Gurobi. La matriz resultante quedó de un tamaño de 4.976 empresas y 165 parámetros. Estos últimos se muestran en el Anexo D. 

**3. Base de Datos 3: Imputación**

La imputación múltiple se refiere a la predicción de datos perdidos simultáneamente en más de una variable. Existen dos métodos para la solución de este problema, Modelación Conjunta o Imputación Multivariada por Ecuaciones Encadenadas (JM y MICE por sus siglas en inglés). En este trabajo se utilizó MICE debido a que JM requiere supuestos de que la base de datos distribuye normal multivariante, lo cual es un supuesto bastante fuerte para las 234 variables que presenta la base de datos (y, por esta razón, MICE es el método más ocupado en la literatura). 

Se utilizó el lenguaje de programación R, que se enfoca en el análisis estadístico, en donde se ocupó la librería *mice* y se obtuvo la tercera base de datos, la cual presenta la cantidad de filas y matrices de la base de datos original y que tiene un 14,9% de sus datos estimados.

### Escalar los datos

Se escalaron los datos ocupando el método MAX-MIN.

> **Nota a mejorar:**
>
> Se escaló la base de datos total en vez de escalar los datos sólo en el set de entrenamiento y luego transformar el set de testeo; lo cual puede ser una fuente de *data leakage*. La literatura propone hacer lo último.

## Modelo Selección de Acciones

El modelo de selección de acciones (MSA) fue creado con el objetivo de generar un algoritmo que elija en qué acciones incorporar en el portafolio para superar al mercado considerando un periodo de tenencia de 3 o 5 años. Esto es un problema de clasificación, ya que se le está pidiendo al modelo contestar a la pregunta si se debe invertir en una empresa en particular con un 󠇝“sí” 󠇝o 󠇝un 󠇝“no”. Se ocupa como estrategia el mantener en tenencia el portafolio por 3 o 5 años, sin rebalanceos, sin ventas cuando los precios están muy altos y sin compras para aprovechar nuevas oportunidades de ocasión. 

Para decidir cuando una empresa es sobresaliente se observó el alfa futuro que presentaría esta, es decir, el alfa que la compañía tendrá en el período de tenencia que se desea mantener. Entonces, si el alfa pertenece al percentil 66,6 o mayor de la muestra, 󠇝se 󠇝le 󠇝confiere 󠇝la 󠇝etiqueta 󠇝“1”, 󠇝en 󠇝caso 󠇝contrario, 󠇝la 󠇝etiqueta 󠇝“0”. Estos umbrales tomaron los valores de 0,170 y 0,154 para los periodos de tenencia de 3 y 5 años, respectivamente.  

### Separación Base de Datos

Para el subconjunto de testeo se debe ocupar datos que ocurren cronológicamente después de los datos utilizados para entrenar el modelo. Entonces, para este subconjunto se dejan los últimos tres años con información disponible; lo que equivale los años fiscales de 2011, 2012 y 2013 para el periodo de tenencia de 5 años, y los años 2013, 2014 2015 para el periodo de tenencia de 3 años. El resto de la base de datos fue dejada para el set de entrenamiento y validación; que se utilizarán para realizar el entrenamiento y *grid search*, con el objetivo de elegir la configuración de modelo para cada año de testeo que minimice el error de clasificación. 

### Entranamiento y *Grid Search*

La MLP red neuronal que se decidió entrenar se aplicó regularización L2 para prevenir el *overfitting* y se utilizó el método del gradiente a través de *backpropagation*. La función objetivo sería la siguiente:

![Figura 1: Función objetivo MLP-NN]()

Además para ajustar los hiper parámetros de la red se ocupó el método de *grid search*. Específicamente se ajustaron los parámetros de la cantidad de capas escondidas, el parámetro de regularización y la base de datos a ocupar. En este proyecto se decidió fijar la cantidad de unidades de activación fue fijado en 50 en todas las capas escondidas. **Porqué?**

La métrica a utilizar para el *grid search* fue el *F1 Score* debido a que lo verdaderamente importante en este problema de clasificación es seleccionar un portafolio de empresas sobresalientes (entonces tener buena precisión) pero al mismo tiempo generar un portafolio diversificado (entonces tener buena cobertura de las empresas sobresalientes). Por lo que se decidió utilizar el promedio armónico de estas dos métricas, el *F1 Score*, y así intentar de seleccionar los modelos que obtengan buena precisión y cobertura. 

Cuando hay datos de serie de tiempo, no se puede separar el set de entrenamiento y validación cruzada de manera aleatoria. Por lo que, al igual que en el conjunto de testeo, el set de validación cruzada viene cronológicamente después del set de entrenamiento. La técnica utilizada para realizar la validación cruzada, llamada encadenamiento hacia adelante, realiza varias iteraciones de entrenamiento y validación. En cada iteración se divide el conjunto de entrenamiento en estos dos sets, a condición de que el set de validación siempre esté por delante del set de entrenamiento. En la primera iteración, se entrena el modelo desde el principio de la base de datos hasta el año j, para así hacer la validación en el año j+1. Luego en la siguiente se entrena desde el inicio de la base de datos hasta el año j+1, para validar en el año j+2. Así sucesivamente hasta el último año del conjunto de entrenamiento; respetando así la dependencia temporal. En este proyecto se hicieron tres iteraciones de entrenamiento/validación para cada configuración de modelo que será testeado en un año particular, para cada periodo de tenencia.

Entonces, para cada año que se desea testear de ambos periodos de tenencia, se elige la configuración de hiper parámetros que obtuvo el mejor promedio de *F1 Score* en los tres años utilizados en el entrenamiento/validación. Entonces se puede seleccionar configuraciones distintas de hiper parámetros en los años de testeo.

> **Nota a mejorar:**
>
> En este trabajo de título se tenía como objetivo personal entender una red neuronal. Pero en al construir un modelo de clasificación, es una mejor práctica probar diferentes modelos de *Machine Learning*, y dejar un modelo como *baseline* (tengo la costumbre de ocupar a *Naive Bayes* para esto, para quizás se podría utilizar una regresión logística), y después entrenar varios modelos distintos para comprobar cuál de todos se ajusta mejor a los datos y obtiene una mejor generalización. También se podría probar técnicas de *ensamble* para mejorar la clasificación.

A continuación se muestra los hiper parámetros seleccionados con sus respectivos resultados. 

![Tabla 1: Resultados selección de modelos período de tenencia 3 años]()

![Tabla 1: Resultados selección de modelos período de tenencia 5 años]()

## Resultados Testeo y Discución

Para los modelos seleccionados se testeará la generalización que obtuvieron en cuanto a las métricas de clasificación anteriormente mencionadas, pero también su performance financiero y si se cumplen los criterios de Graham.

El objetivo de la evaluación financiera es calcular la rentabilidad y el alfa que obtuvieron los portafolios elegidos en los diferentes años de testeo y mantenidos por un periodo de tenencia de 3 o 5 años, según corresponda. Los supuestos que se utilizaron para obtener estas métricas fueron que: (i) se puede comprar una cantidad continua de acciones; (ii) los datos del reporte anual de una empresa están disponibles en Bloomberg un mes después del final de su respectivo año fiscal; y (iii) no existen costos de transacción ni impuestos.
 
*Mostrar tablas con los resultados*

![Tabla 1: Resultados testeo período de tenencia 3 años]()

![Tabla 1: Resultados testeo período de tenencia 5 años]()

*Para un análisis más completo de los resultados se recomienda vistar el informe disponible en el repositorio.* 

Las métricas de clasificación, en general, sufrieron bajas significativas en comparación a la validación. El *F1* disminuyó en promedio un 59,1% para el periodo de tenencia de 3 años y un 65,5% para el de 5. Estos cambios se deben, en general, a un menor rendimiento en las dos métricas relevantes, precisión y cobertura. Ahora bien, la disminución de la cobertura es más grande que la disminución en la precisión. 

Estos resultados son una clara señal del *underfitting*, ya que la red mostró un rendimiento deficiente que empeoró en el testeo. La red no se ajusta bien al conjunto de entrenamiento y tampoco es capaz de generalizar bien con datos que no ha visto. Ahora bien, es relevante recordar que la clasificación es entre empresa sobresaliente y empresa no sobresaliente; por lo que existe la posibilidad de que las empresas seleccionadas que no fueron sobresalientes aún sean lo suficientemente buenas como para que el portafolio creado obtenga resultados mejores que el mercado. 

En cuanto a las métricas financieras, los portafolios obtuvieron resultados relativamente satisfactorios para los alfas. En dos de los tres años de testeo se obtuvo un alfa positivo, acompañado de una rentabilidad superior a la del mercado, para ambos periodos de tenencia. Lamentablemente, el valor p no fue menor 0,05 en ninguno de los casos de alfa positivo, lo cual se traduce en que los resultados en donde los alfas son mayores a cero no son estadísticamente significativos con un intervalo de confianza de 95%. Por lo que existe una probabilidad importante que estos resultados se hayan realizado por chance en vez de por el buen manejo de cartera del MSA. Sin embargo, en dos casos se estuvo cerca de tener significancia estadística, para el año 2013 en el periodo de tenencia de 3 años y en el 2011 para el periodo de tenencia de 5 años, con un valor p de 0,067 y 0,114, respectivamente. 

## Conclusión

Con todo lo mencionado en este reporte, ¿se debería ocupar el portafolio creado por el MSA o invertir en el índice de mercado? Si bien el modelo no clasifica con una precisión aceptable a las empresas sobresalientes, el portafolio automatizado igual obtiene un mejor rendimiento que el mercado en la mayoría de los años de testeo; y cuando pierde es por poco. A pesar de esto, no se tiene un nivel de confianza lo suficientemente estricto como para pensar que estos resultados no fueron aleatorios. Además, se debe considerar que en la evaluación de resultados no se está considerando los costos por transacción; que la intuición dice que deberían ser mayores para la compra de acciones individuales que para un fondo que sigue el índice de mercado. Con estos dos argumentos, la decisión tendería a ser invertir en el índice de mercado. Ahora bien, si con las líneas de acción propuestas, se puede replicar con mayor frecuencia las rentabilidades obtenidas para el 2013 en el periodo de tenencia de 3 años, entonces si sería recomendable invertir en el portafolio.
