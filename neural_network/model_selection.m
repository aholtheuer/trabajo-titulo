function [error_mat, A, B, C] =  model_selection( year, alp_year, X, alphas, L_years, max_iter, q, input_layer_size)
                                      
%% Model Selection para una cantidad de capas escondidas
%% y base de datos especificas
                                      
%% Iteration variables 
t = time();
lambda_list = [];
for i = 1:8
  lambda_list = [lambda_list ; 0.01*2**i];
endfor



l = size(lambda_list,1);

tot_iter = l*5;
cant     = 0;

error_mat = [];
error_mat1 = [];
error_mat2 = [];
error_mat3 = [];
error_mat4 = [];
error_mat5 = [];
error_mat6 = [];
min_e_val = 1000000000;
A = {};
B = {};
C = {};

%Generate arr
mat_nn_params = [];
mat_idx = [];
arr = getarr(q, input_layer_size);
cost_vector_mat=[];

    
    for j = 1:l
      
        lambda = lambda_list(j);
        mat_cv = get_cv_set_idx(L_years, alp_year);
        FScr_vector = [];
        et_vector       = [];
        ev_vector       = [];
        TP_vector       = [];
        prec_vector     = [];
        rcal_vector     = [];
        tot_pred_vector = [];
        #Son 5 porque se hace el CV con 3 anos (a) y se testea con 3 (yt), entonces
        # 5 = a + yt - 1
        for yr = 1:5
          % anos correspondientes para el set de entrenamiento/validacion
          cv_init = mat_cv(yr, 1);
          cv_end  = mat_cv(yr, 2);
          
          Xval =  X(cv_init : cv_end, :);
          Xt   =  X(cv_end + 1: end, :);
          
          y_mat      = get_dummies(alphas, cv_end);  
          y          = y_mat(:, year);
 
          
          yval =  y(cv_init : cv_end, :);
          yt   =  y(cv_end + 1: end, :);
          
          % entrenar
          [nn_params, cost_vector, iter] = nn_train(Xt, yt, arr, ...
                                                     max_iter, lambda);
          
          % guardar resultados
          
          mat_nn_params = [mat_nn_params, nn_params];
          mat_idx = [mat_idx, [q; lambda; yr]];
          e_train = cost_vector(end);
          e_val = nn_cost_function(nn_params, arr, Xval  , yval , 0);
          
          
          [pred_cv, mat_prob] = predictThreshold(nn_params, Xval, arr, 0.5);
          
          TP = sum(pred_cv == 2 & yval == 2);
          TN = sum(pred_cv == 1 & yval == 1);
          FN = sum(pred_cv == 1 & yval == 2);
          FP = sum(pred_cv == 2 & yval == 1);
          
          tot_2_pred = TP + FP;
          prec_cv    = TP / (TP + FP); 
          rcal_cv    = TP / (TP + FN);
          
          FScr_cv    = 2 * ( prec_cv * rcal_cv / ( prec_cv + rcal_cv ) );
          if isnan(FScr_cv) == 1
            FScr_cv = 0;
          endif          
         
          FScr_vector  = [FScr_vector, FScr_cv];
          
          #Otros resultados interesantes 
          et_vector       = [et_vector, e_train];
          ev_vector       = [ev_vector, e_val];
          TP_vector       = [TP_vector, TP];
          prec_vector     = [prec_vector, prec_cv];
          rcal_vector     = [rcal_vector, rcal_cv] ;
          tot_pred_vector = [tot_pred_vector, tot_2_pred];
          
          cant = cant + 1;
          fprintf('Model %g / %g \n', [cant tot_iter]);           
          
        endfor
        # guardar resultados de un lambda para los diferentes anos en la matriz 
        error_mat = [error_mat; q lambda FScr_vector];
        
        #Otros resultados interesantes:
        error_mat1 = [error_mat1; q lambda et_vector];      
        error_mat2 = [error_mat2; q lambda ev_vector]; 
        error_mat3 = [error_mat3; q lambda TP_vector];       
        error_mat4 = [error_mat4; q lambda prec_vector];     
        error_mat5 = [error_mat5; q lambda rcal_vector];  
        error_mat6 = [error_mat6; q lambda tot_pred_vector];
        
        
    endfor
    
A(q) = mat_nn_params;
B(q) = mat_idx;

C(1) = error_mat1;
C(2) = error_mat2;
C(3) = error_mat3;
C(4) = error_mat4;
C(5) = error_mat5;
C(6) = error_mat6;

t = (time() - t)/60;
T = t/60;
fprintf('Time needed was %4.2f mins or %2.2f hours \n', [t T])

end

                         

                         