function [nn_params, cost_vector, iter] = nn_train(X, y, arr, max_iter, lambda) 
                                                   
## Algoritmo de entrenamiento

#arr:      n�mero de unidades en cada capa.
#max_iter: iteraciones m�ximas permitidas.
#lambda:   par�metro de regularizaci�n
#X:        Parametros. Sin los par�metros x_0 1's (m * n)
#y:        etiquetas correctas (mx1)

## Generar pesos iniciales

initial_nn_params = rand_init_weights(arr);


## Entrenar 
options = optimset('MaxIter', max_iter);

% Crear "atajo" para minimizar la funci�n de costo
costFunction = @(p) nn_cost_function(p, arr, X, y, lambda);

% Ahora, costFunction es una funci�n que toma solo un argumento (el
% de par�metros de la red neuronal)
[nn_params, cost_vector, iter] = fmincg(costFunction, initial_nn_params, ...
                                           options);
                                                                                                                                                

end