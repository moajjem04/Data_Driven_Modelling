function mse = CalcMSE(target,prediction)
err = (target-prediction); 
sq_err = err.^2;
mse = mean(sq_err,'all');
end