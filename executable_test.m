#Entrenamiento y testeo del modelo seleccionado

# Año a testear 
yr      = 2011; 
alp     = 3;  #opción entre 2 o 3 

# Resultados MS
BdD      = 2;
q        = 1;
lambda   = 0.64;

# Opciones
max_iter = 1000;


alp_id     = [1,3,5];


# GetData

if BdD == 1
 [X,alphas, L_years, ID, Feature] = getData();
elseif BdD == 2 
 [X,alphas, L_years, ID, Feature] = getDatav2();
else 
 [X,alphas, L_years, ID, Feature] = getDatav3();
endif

# Particiona Data

[test_end test_init L_ut_for_year] = get_test_set_idx(L_years, yr);

train_init = test_end + 1;
X_test  = X(test_init : test_end, :);
X_train = X(train_init:end, :);


y_mat       = get_dummies(alphas, test_end);


alp_year   = alp_id(alp);
y          = y_mat(:,alp);
str_num    = num2str(alp_year);


y_train = y(train_init:end, :);
y_test  = y(test_init : test_end, :); 

ID_test = ID(test_init : test_end, :);

# Arquitectura red

input_layer_size  = size(X,2);     % Debe estar en función de X
hidden_layer_size = 50;            % Buscar forma de definir esto (Thumb rule)
num_labels        = 2;             % Decidirlo con el profesor.   

#Strings
str1 = strjoin({'HP=', num2str(alp_year)}, '');
str3 = strjoin({'TY=', num2str(yr)}, '');
str_num    = strjoin({str1, str3},'_');

% Setup array with the sizes

arr = getarr(q, input_layer_size);

[nn_params, cost_vector, iter] = nn_train(X_train, y_train, arr, ...
                                               max_iter, lambda);
                                               
                                               

## Cantidad de empresas elegidas; Función Objetivo Entrenamiento; 
## Función Objetivo Testeo; Precisión; Cobertura; F Score. 

    
    
    e_train = nnOnlyCostFunction(nn_params, arr, X_train  , y_train , 0);
    e_test  = nnOnlyCostFunction(nn_params, arr, X_test  , y_test , 0);
       
      tshd       = 0.5;
      [pred_test, mat_prob] = predictThreshold(nn_params, X_test, arr, tshd);
      TP = sum(pred_test == 2 & y_test == 2);
      TN = sum(pred_test == 1 & y_test == 1);
      FN = sum(pred_test == 1 & y_test == 2);
      FP = sum(pred_test == 2 & y_test == 1);
      
      
      tot_2_pred = TP + FP;
      if TP + FP == 0
        prec_test = 0;
      else 
        prec_test  = TP / (TP + FP); 
      endif
      rcal_test  = TP / (TP + FN);
      FScr_test  =  2 * ( prec_test * rcal_test / ( prec_test + rcal_test ) );
      accy_test  = mean(double(pred_test == y_test))*100;

    #Crear inputs para el analisis financiero y graham 
    
    idx_firm = [];
    for i = 1:size(pred_test,1)
      if pred_test(i) == 2
        idx_firm = [idx_firm; i];
      endif
    endfor
   
    ID_output   = ID_test(idx_firm, :);
    wb_name     = strjoin( {'Ticker n Dates ', str_num}, ' ');
    xlswrite(wb_name, [{'Year Start', 'Alpha year' } ...
                          ;{yr, alp_id(alp)}], 1);
    xlswrite(wb_name, ID_output, 2);

    xlswrite(wb_name, mat_prob(idx_firm, 2), 3);   
    
    wb_name     = strjoin( {'NN params ', str_num}, ' ');
    xlswrite(wb_name, nn_params, 1);
    
    #Escribir resultados del testeo
    wb_name     = strjoin( {'R Test ', str_num}, ' ');
    RT = [e_train, e_test, accy_test, tot_2_pred, prec_test, rcal_test, FScr_test];
    xlswrite(wb_name, RT, 1);
    
    
