function [J, grad, J_wo_reg] = nn_cost_function(nn_params, ...
                                   arr, X, y, lambda)
% nn_cost_function implementa la función de costo de la red neuronal de "q" 
% capas escondidas que realiza la clasificación (que viene implicito en el "arr")
% [J, grad, J_wo_reg] = nn_cost_function(nn_params, arr, X, y, lambda) 
% calcula el costo, el gradiente de la red neuronal y el costo sin regularización
% Los parámetros de la red neuronal esta "desenrollado" en el vector
% nn_params y deben volver a convertirse en las matrices de pesos.
%
% El parámetro grad devuelto debe ser un vector "desenrollado" del
% derivadas parciales de la red neuronal.

[Thetas, Thetas_grad, Deltas] = reform_thetas(nn_params, arr);

% Iniciar variables utiles
m = size(X, 1);
L = size(arr,1);      
J = 0;
y_inicial = zeros(arr(L,1),1);
X = [ones(m,1) X]; #Acá se agregan 1s
suma = 0;
unos = ones(arr(L,1),1);

for i = 1:m
  
  #FeedFoward
  
  a{1} = (X(i,:))';
  for j = 2:L 
    z{j} = Thetas{j-1}*a{j-1};
    a{j} = sigmoid(z{j});
    
    
    if j ~= L
      a{j} = [1; a{j}];
    endif
  endfor  
  
  
  yi = y_inicial;
  yi(y(i)) = 1;
  suma = suma + (-yi' * log(a{L}) - (unos - yi)' * log(unos - a{L}));
  
  #BackProp
  d{L} = a{L} - yi;
  Deltas{L-1} = Deltas{L-1} + d{L}*a{L-1}';
  for j = L-1:-1:2
    z{j} = [1;z{j}];
    d{j} = Thetas{j}' * d{j+1} .* sigmoid_gradient(z{j}) ; 
    d{j} = d{j}(2:end); 
    Deltas{j-1} = Deltas{j-1} + d{j}*a{j-1}';
  endfor 
endfor


grad = [];
suma1 = 0;
for l = 1:L-1
  [f,c] = size(Thetas{l});
  T = zeros(f,c);
  T(:,2:end) = Thetas{l}(:,2:end);
  Thetas_grad{l} = (1/m) * Deltas{l} + (lambda/m) * T;
  grad =  [grad; Thetas_grad{l}(:)];
  T = T.**2;
  suma1 = suma1 + sum(T(:));
  
endfor

J_wo_reg = (1/m) * suma;
J = J_wo_reg + (lambda/(2*m)) * (suma1);
end
