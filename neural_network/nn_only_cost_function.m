function [J, grad, J_wo_reg] = nn_only_cost_function(nn_params, ...
                                   arr, X, y, lambda)
% nn_only_cost_function entrega sólo el costo J de la funión.
[Thetas, Thetas_grad, Deltas] = reform_thetas(nn_params, arr);

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
  
endfor


grad = [];
suma1 = 0;

J_wo_reg = (1/m) * suma;
J = J_wo_reg + (lambda/(2*m)) * (suma1);

end
