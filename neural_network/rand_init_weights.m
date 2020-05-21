function initial_nn_params = rand_init_weights(arr)
% rand_init_weights Inicializa aleatoriamente los pesos de una capa con L_in
% de conexiones entrantes y L_out conexiones salientes. Que se guardan en en ell
% "arr"

initial_nn_params = [];

L = size(arr,1);
for l = 1:L-1
  epsilon_init = .12;
  W = rand(arr(l+1), 1 + arr(l)) * 2 * epsilon_init - epsilon_init; 
  initial_nn_params = [initial_nn_params; W(:)];
endfor







% =========================================================================

end
