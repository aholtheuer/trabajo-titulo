function [A, B, C]  = reform_thetas(nn_params, arr_layer_size)
  
  [L,c] = size(arr_layer_size);
  contador = 1;
  for j = 1:L-1
    fila = arr_layer_size(j+1);
    col = arr_layer_size(j) + 1; 
    T = reshape(nn_params(contador : (fila * col) + contador - 1), ... 
                fila, col); 
    contador = contador + fila * col;
    A{j} = T;
    [m,n] = size(T); 
    B{j} = zeros(m,n);
    C{j} = zeros(m,n);
    
  endfor 
end
