function [X,y, L_years, ID, Features] = getDatav3()
pkg load io;

X2                = csvread('Base_De_Datos/BdD3/data_imp.csv');
X2(:, [10 11 106 107 108 112 113 114 160 208]) = [];
[L_years str cel] = xlsread('Base_De_Datos/years_features.xlsx', 1);
[Feat str1 cel1]  = xlsread('Base_De_Datos/years_features.xlsx', 2);


[ut_fil ut_col]   = size(X2);
ID       = str(2:end,:);
ID       = ID(:, [1 5]);
Features = str1; 

y       = X2(:, ut_col - 2 : ut_col);
X       = X2(:, 1: ut_col - 3);


%%Información en <https://octave.sourceforge.io/io/function/xlsread.html> 
end