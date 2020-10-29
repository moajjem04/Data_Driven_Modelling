%% Load
clear all; close all; clc;
tic

a = [-0.5572 -0.7814;0.7814  0];
b = [1 -1;0 2];
c = [1.9691  6.4493];
sys1 = ss(a,b,c,0);

t = linspace(0,100,10000);
f = impulse(sys1,t); % creating initial impulse response
dt = t(2)-t(1);

%% Hankel Matrix
H1 =[ f(1:end-2);f(2:end-1)]; 
H2 =[ f(2:end-1); f(3:end)]; 

%% ERA
[U,S,V]=svd(H1,'econ'); 
r = rank(S);

% Reconfiguring Data for the ERA function
YY(1,1,:) = f(:,1,1); 
YY(1,2,:) = f(:,1,2);

% Applying ERA to get reduced order model
[Ar,Br,Cr,Dr,HSVs] = ERA(YY,200,200,2,1,r);

% Creating state-space model from ERA
sys = ss(Ar,Br,Cr,Dr,dt);

%% Designing Inputs
temp = zeros(length(t),1);
unitstep = t>=0; % unit step input
ramp = t.*unitstep/100; % ramp input
impu = temp; impu(1,1) = 1; % impulse input
rand1 = rand(length(t),1);
rand2 = rand(length(t),1);

%% Testing Model
u = zeros(length(t),2);
u(:,1) = impu;
u(:,2) = impu;

y = lsim(sys,u,t);      %response from new system
f_org = lsim(sys1,u,t); %response from original system

%% RMSE
yfit = normalize(y);
Y_test = normalize(f_org);
error = yfit-Y_test;
error_squared = error.^2;
SSE = sum(error_squared); % sum of squared error
MAE = sum(abs(error)/length(error));
MSE = SSE/length(error);
RMSE = sqrt(MSE);
R2 = 1 - (MSE)/(sum((Y_test-mean(Y_test)).^2)/length(error));
%% Plots
figure()
hold on
grid on
plot(t,normalize(f_org))
plot(t,normalize(y),'--r')
xlabel('Time(s)'), ylabel('State')
legend('Data ','ERA Model')
title('Output Comparison')
figure()
hold on
grid on
plot(t,u(:,1))
xlabel('Time(s) '), ylabel('State')
title('Input in Channel 1')

figure()
hold on
grid on
plot(t,u(:,2))
xlabel('Time(s)'), ylabel('State')
title('Input in Channel 2')

%% States
% fprintf('The size of A is %d X %d \n',size(Ar,1),size(Ar,2))
% fprintf('The size of B is %d X %d \n',size(Br,1),size(Br,2))
% fprintf('The size of C is %d X %d \n',size(Cr,1),size(Cr,2))
% fprintf('The size of D is %d X %d \n',size(Dr,1),size(Dr,2))

%% DONE
toc
disp('DONE!')
















