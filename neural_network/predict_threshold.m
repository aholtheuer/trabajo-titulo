function [pred_t, matriz_prob] = predict_threshold(nn_params, X, arr, tshd)

m = size(X, 1);
L = size(arr, 1);
Thetas = reform_thetas(nn_params, arr);

pred_t = zeros(size(X, 1), 1);

h{1} = sigmoid([ones(m, 1) X] * Thetas{1}');

for l = 2:L-1
  h{l} = sigmoid([ones(m, 1) h{l-1}] * Thetas{l}');
endfor

matriz_prob = h{L-1};

#Criterio de selección actual etiqueta 2 > 0.5
pred_t = (matriz_prob(:,2) >= tshd) * 2 + (matriz_prob(:,1) > 1 - tshd);


#h2: es una matriz de (m x num_labels) que te da algo así como la probabilidad
#     de que quede el ejemplo quede en cada rango.
# dummy: variable que elige la mayor probabilidad para cada ejemplo. 
# p: variable que guarda la posición de en que columna (y por lo tanto etiqueta)
#     está la que obtuvo mayor probabilidad. 
% =========================================================================


end
