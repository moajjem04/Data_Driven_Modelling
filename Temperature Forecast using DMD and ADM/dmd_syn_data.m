clc; clear all; close all;
%% Description
% Using a synthetic data ,f(x,t) = 0.5 sin(x) + 2 csch(x)
% tanh(x) exp(i2.8t), we will add white noise to it. We will then denoise
% it and use DMD to reconstruct the data.

%% Define time and space discretizations
n = 200;
m = 80;
x = linspace (-15,15,n);
t = linspace (0,8*pi,m);
dt = t(2) - t(1);
[Xgrid ,T] = meshgrid(x,t);
%% Create spatiotemporal patterns
f = 0.5* cos(Xgrid)+csch(Xgrid).*tanh(Xgrid).* exp(1j*2.8*T);
subplot(221)
surfl(real(f));
shading interp; colormap(gray ); view (-20,60);
title('Synthetic Data');

%% Adding white noise
y = awgn(f,20,'measured');
subplot(222)
surfl(real(y));
shading interp; colormap(gray ); view (-20,60);
title('Adding Noise Data');
%% RPCA with ADM
[L,S] = RPCA(y);

subplot(223)
surfl(real(L))
shading interp; colormap(gray ); view (-20,60);
title('Low-Rank Version of Data');
subplot(224)
surfl(real(S))
shading interp; colormap(gray ); view (-20,60);
title('Sparse Version of Data');
%%
temp = perf_analysis(real(f),real(L));
result.rmse = temp.rmse;
result.cc = temp.cc;
%% Rank
tol = 10^-7;
rank1 = rank(f,tol);
rank2 = rank(y,tol);
rank3 = rank(L,tol);
%% DMD
dmd_model = DMD(y', t); % Initializing DMD
rank = 2;
dmd_model = dmd_model.train(rank); % Training DMD
train_pred = dmd_model.predict(t); % Reconstructing Training Data
%% DMD Plots
dmd_model.plots

%% Result
temp = perf_analysis(real(f),real(train_pred'));
result2.rmse = temp.rmse;
result2.cc = temp.cc;
%% Plot
subplot(211)
surfl(real(f));
shading interp; colormap(gray ); view (-20,60);
title('Original Synthetic Data');

subplot(212)
surfl(real(train_pred'));
shading interp; colormap(gray ); view (-20,60);
title('Reconstruction of Synthetic Data');