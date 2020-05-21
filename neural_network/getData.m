function [X,y, L_years, ID, Features] = getData()
pkg load io;
idx_fil           = csvread('Base_De_Datos/BdD1/fil_relevantes.csv');
idx_col           = csvread('Base_De_Datos/BdD1/col_relevantes.csv');
X_na              = csvread('Base_De_Datos/data_na.csv');
[L_years str cel] = xlsread('Base_De_Datos/years_features.xlsx', 1);
[Feat str1 cel1]  = xlsread('Base_De_Datos/years_features.xlsx', 2);

ut_fil   = size(idx_fil);
ut_col   = size(idx_col);
X2       = X_na(idx_fil, idx_col);
L_years  = L_years(idx_fil, 1);
ID       = str(2:end,:);
ID       = ID(idx_fil, [1 5]);
Features = str1(:, idx_col); 

y       = X2(:, ut_col - 2 : ut_col);
X       = X2(:, 1: ut_col - 3);

%%Información en <https://octave.sourceforge.io/io/function/xlsread.html> 
end