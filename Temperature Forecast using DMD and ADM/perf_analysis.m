function result = perf_analysis(target,prediction)
% Provides RMSE, MSE, MAE, Relative Error and Correlation Coefficient for
% target and predictions

result.cc = corrcoef(target,prediction);
result.cc = result.cc(1,2);
result.rmse = CalcRMSE(target,prediction);



end