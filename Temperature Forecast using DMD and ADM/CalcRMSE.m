function rmse = CalcRMSE(target,prediction)
mse = CalcMSE(target,prediction);
rmse = mse^0.5;

end