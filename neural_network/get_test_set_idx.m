function [test_end test_init L_ut_for_year] = get_test_set_idx(L_years, yr);
                                                


m = size(L_years,1);
L_ut_for_year = [];
for i=1:m-1
  if L_years(i) ~= L_years(i+1)
    L_ut_for_year = [L_ut_for_year; i L_years(i)];
  endif
endfor

L_ut_for_year = [L_ut_for_year; m L_years(m)];

a = find(L_ut_for_year(:, 2) == yr); #indice donde termina el ano que se desea testear

test_init = L_ut_for_year(a - 1, 1) + 1;
test_end  = L_ut_for_year(a, 1);

end
