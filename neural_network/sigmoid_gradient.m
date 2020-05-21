function g = sigmoid_gradient(z)

g = zeros(size(z));

unos = ones(size(z)); 
g = sigmoid(z) .* (unos - sigmoid(z));


end
