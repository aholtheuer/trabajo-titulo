## Modelo Selección de Acciones

El modelo de selección de acciones (MSA) fue creado con el objetivo de generar un algoritmo que elija en qué acciones incorporar en el portafolio para superar al mercado considerando un periodo de tenencia de 3 o 5 años. Se ocupa como estrategia el mantener en tenencia el portafolio por 3 o 5 años, sin rebalanceos, sin ventas cuando los precios están muy altos y sin compras para aprovechar nuevas oportunidades de ocasión. 

Para decidir cuando una empresa es sobresaliente se observó el alfa futuro que presentaría esta, es decir, el alfa que la compañía tendrá en el período de tenencia que se desea mantener. Entonces, si el alfa pertenece al percentil 66,6 o mayor de la muestra, 󠇝se 󠇝le 󠇝confiere 󠇝la 󠇝etiqueta 󠇝“1”, 󠇝en 󠇝caso 󠇝contrario, 󠇝la 󠇝etiqueta 󠇝“0”. Estos umbrales tomaron los valores de 0,170 y 0,154 para los periodos de tenencia de 3 y 5 años, respectivamente.  

### Separación Base de Datos

Como conjunto de testeo se dejaron los últimos tres años con información disponible; lo que equivale los años fiscales de 2011, 2012 y 2013 para el periodo de tenencia de 5 años, y los años 2013, 2014 2015 para el periodo de tenencia de 3 años. El resto de la base de datos fue dejada para el set de entrenamiento y validación; que se utilizarán para realizar el entrenamiento y *grid search*, con el objetivo de elegir la configuración de modelo para cada año de testeo que minimice el error de clasificación. 

### Entranamiento y *Grid Search*

La MLP red neuronal que se decidió entrenar se aplicó regularización L2 para prevenir el *overfitting* y se utilizó el método del gradiente a través de *backpropagation*. La función objetivo sería la siguiente:

![Figura 1: Función objetivo MLP-NN]()

Para ajustar los hiper parámetros de la red se ocupó el método de *grid search*. Específicamente se ajustaron los parámetros de la cantidad de capas escondidas, el parámetro de regularización y la base de datos a ocupar. En este proyecto se decidió fijar la cantidad de unidades de activación fue fijado en 50 en todas las capas escondidas.

La métrica a utilizar para el *grid search* fue el *F1 Score* debido a que lo verdaderamente importante en este problema de clasificación es seleccionar un portafolio de empresas sobresalientes (entonces tener buena precisión) pero al mismo tiempo generar un portafolio diversificado (entonces tener buena cobertura de las empresas sobresalientes). Por lo que se decidió utilizar el promedio armónico de estas dos métricas, el *F1 Score*, y así intentar de seleccionar los modelos que obtengan buena precisión y cobertura. 

El set de validación cruzada viene cronológicamente después del set de entrenamiento. La técnica utilizada para realizar la validación cruzada, llamada encadenamiento hacia adelante, realiza varias iteraciones de entrenamiento y validación. En cada iteración se divide el conjunto de entrenamiento en estos dos sets, a condición de que el set de validación siempre esté por delante del set de entrenamiento. En la primera iteración, se entrena el modelo desde el principio de la base de datos hasta el año j, para así hacer la validación en el año j+1. Luego en la siguiente se entrena desde el inicio de la base de datos hasta el año j+1, para validar en el año j+2. Así sucesivamente hasta el último año del conjunto de entrenamiento; respetando así la dependencia temporal. En este proyecto se hicieron tres iteraciones de entrenamiento/validación para cada configuración de modelo que será testeado en un año particular, para cada periodo de tenencia.

Entonces, para cada año que se desea testear de ambos periodos de tenencia, se elige la configuración de hiper parámetros que obtuvo el mejor promedio de *F1 Score* en los tres años utilizados en el entrenamiento/validación. Entonces se puede seleccionar configuraciones distintas de hiper parámetros en los años de testeo.

> **Nota a mejorar:**
>
> En este trabajo de título se tenía como objetivo personal entender una red neuronal. Pero en al construir un modelo de clasificación, es una mejor práctica probar diferentes modelos de *Machine Learning*, y dejar un modelo como *baseline* (tengo la costumbre de ocupar a *Naive Bayes* para esto, para quizás se podría utilizar una regresión logística), y después entrenar varios modelos distintos para comprobar cuál de todos se ajusta mejor a los datos y obtiene una mejor generalización. También se podría probar técnicas de *ensamble* para mejorar la clasificación.
