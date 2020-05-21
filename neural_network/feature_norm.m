function [Norm_X] = feature_norm(X)

Norm_X = (X .- min(X)) ./ range(X);
  
end
