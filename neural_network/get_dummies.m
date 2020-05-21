function [mat_y] = get_dummies(alphas, test_end)

ut_fil  = size(alphas,1);
mat_y   = zeros(ut_fil, 3);
#st_desv = std(alphas);
#prom    = mean(alphas);
valores = prctile(alphas((test_end + 1) : end,:), 66);

for i = 1:ut_fil
  for j = 1:3
    if alphas(i,j) < valores(j) 
      mat_y(i,j) = 1;
    else 
      mat_y(i,j) = 2;
    endif
endfor
end