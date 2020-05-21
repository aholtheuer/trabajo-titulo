function arr = getarr(q,n)

input_layer_size  = n;    % Debe estar en función de X
hidden_layer_size = 50;   % Buscar forma de definir esto (Thumb rule)
num_labels        = 2;    % Decidirlo con el profesor.   
q_hidden_layers   = q;    

% Setup array with the sizes
arr = [input_layer_size];

for l = 1:q_hidden_layers
  arr = [arr; hidden_layer_size];
endfor

arr = [arr; num_labels];
end