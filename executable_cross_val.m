%% Algoritmo Selección de Modelos Neural Network TT Andrés Holtheuer
%% (Basado en: "Machine Learning Online Class 
%%                              - Exercise 4 Neural Network Learning")

%  Parametros
%  ------------ 
%  BdD        = Cual BdD se va a ocupar. 1 = Optimizada, 2 = Optimizada con parametros
%               relevantes fijos, 3 = Imputada
%  year       = Representa el periodo de tenencia. 2 = 3 años, 3 = 5 años. 
%  q          = Cantidad de capas escondidas de la red
%  max_iter   = Cantidad de iteraciones. Máximo 1000.

%% Inicialización
clc
pkg load io;
addpath("neural_network")

%% INPUTS
BdD        = 1;
year       = 3;
q          = 1;
max_iter   = 10;

%& Recuperar datos de la base de datos

if year == 2
  years = [2013 2014 2015];
else 
  years = [2011 2012 2013];
endif

if BdD == 1
 [X,alphas, L_years, ID, Feature] = getData();
elseif BdD == 2 
 [X,alphas, L_years, ID, Feature] = getDatav2();
else 
 [X,alphas, L_years, ID, Feature] = getDatav3();
endif


%% Parámetros usados para esta corrida

[m, n]      = size(X);
input_layer_size  = n;    % Debe estar en función de X
hidden_layer_size = 50;   % Buscar forma de definir esto 
num_labels        = 1;    % Decidirlo con el profesor.   
%q_hidden_layers   = 1;   % Se elije, en model selection.

alp_id     = [1 3 5];
alp_year   = alp_id(year);
str1 = strjoin({'HP=', num2str(alp_year)}, '');
str3 = strjoin({'BdD=', num2str(BdD)}, '');
str_num    = strjoin({str3, str1},'_');

%% Feature Normalization

X = feature_norm (X);

%%  Model Selection 

[error_mat, A, B, C] =  model_selection(year, alp_year, X, alphas,L_years, ...
                                           max_iter, q, input_layer_size)
        

%% RESULTADOS
        
%% Arreglar formato matriz resultado
 
[fil col] = size(error_mat);
mat_R = [];
for row = 1:fil
    q = error_mat(row, 1);
    l = error_mat(row, 2);
    for i = 3:5
      yr = years(i-2);
      FScr_v = error_mat(row, i:i+2);
      prom   = mean(FScr_v);
      mat_R  = [mat_R; alp_year BdD q l yr FScr_v prom];
    endfor
endfor
        
%% Guardar resultados en archivos csv
        
wb_name  = strjoin( {'MS F Score ', str_num}, '');
xlswrite(wb_name, mat_R, 1);

str4     = strjoin({'QHL=', num2str(q)}, '');
str_num1 = strjoin({str_num, str4},"_");
wb_name = strjoin( {'MS NN Params ', str_num1}, '');
xlswrite(wb_name, A{q}, 1);
xlswrite(wb_name, B{q}, 2);

[a c_mat] = size(C);
wb_name  = strjoin( {'MS Other Params Unordened ', str_num1}, '');
for i = 1:c_mat
    xlswrite(wb_name, C{i}, i);
endfor
