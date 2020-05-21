function [mat_cv L_ut_for_year] = get_cv_set_idx(L_years,alp_year)
                                                 


m = size(L_years,1);
L_ut_for_year = [];
for i=1:m-1
  if L_years(i) ~= L_years(i+1)
    L_ut_for_year = [L_ut_for_year; i L_years(i)];
  endif
endfor

L_ut_for_year = [L_ut_for_year; m L_years(m)];

test_init = L_ut_for_year(alp_year  - 1, 1) + 1;

test_end  = L_ut_for_year(alp_year ,1);
test_year = L_ut_for_year(alp_year ,2);

mat_cv = [];
init       = test_end;
for j = 1:5
  cv_init   = init + 1;
  cv_end    = L_ut_for_year(alp_year + j    ,1);
  y         = L_ut_for_year(alp_year + j    ,2);
  mat_cv    = [mat_cv; cv_init cv_end y]; 
  init      = cv_end;
endfor
mat_cv = flipud(mat_cv);
end
