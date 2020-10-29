% We will use temperature data from 1960 to 2010 to train our DMD model and
% try to predict the temperature from 2011 to 2019. We will use ADM to
% denoise the data so that we get a low-rank model that captures all the
% information in the data.

clc; clear all; close all;
verbose = 0; % change it into 1 for plots
%% Read Training Data from CSV file
folder_name = 'Train Data/';
state_name = {'Alabama','Arizona','Georgia','Illinois','Virginia'};
start_date = '1960';
end_date = '2010';
temp = []; time = [];
for iter = 1:length(state_name)
a = state_name{iter};
data = ReadMyCSV(folder_name,a, start_date, end_date);
temp = [temp;data(:,2)'];
end
time = data(:,1);
%% RPCA with ADM
[L,S] = RPCA(temp);
%% Correlation Coefficient
temp_denoised = L;
corr1 = corrcoef(temp,temp_denoised);
corr1 = corr1(1,2); % correlation coefficient
%% Plot and Compare the filtered and unfiltered data
if (verbose)
    for i = 1:5
        figure(i)
            %Individual Plots
            hold on
            grid on
            plot(time, temp(i,:))
            plot(time, temp_denoised(i,:),'r--')
            xlabel('Year')
            ylabel('Average Temperature (C)')
            legend('Data','After Denoising')
            title(state_name{i})
    end

    figure()
        %Subplots to compare all
        for i = 1:5
            subplot(2,3,i)
            hold on
            grid on
            plot(time, temp(i,:))
            plot(time, temp_denoised(i,:),'r--')
            xlabel('Year')
            ylabel(['Temperature ',char(176), 'C'])
            legend('Data','After Denoising')
            xlim([1960 2010])
            title(state_name{i})    
        end
        subplot(2,3,6)
        hold on
        grid on
        plot(time, temp_denoised)
        legend(state_name)
        xlim([1960 2010])
        xlabel('Year')
        ylabel(['Temperature ',char(176), 'C'])
        title('All the Data after filtering')    
end
%% Training DMD Model
train_time = time;
temp2 = train_time-1960; % calibrating the time
dmd_model = DMD(temp_denoised, temp2); % Initializing DMD
rank = 1;% can be tuned; look at Singular Value plot in DMD plots
dmd_model = dmd_model.train(rank); % Training DMD
%% Reconstructing the Training Data
train_pred = dmd_model.predict(temp2); % Reconstructing Training Data
%% DMD Plots
if(verbose)
    dmd_model.plots
end
%% Reconstruction Plots
    state_name = {'Alabama','Arizona','Georgia','Illinois','Virginia'};
if (verbose)
    figure()
    % from 1960-2010; 3D Plot
    subplot(121)
    surfl(temp_denoised)
    yticks([1:5])
    yticklabels(state_name)
    xticks([0:10:50])
    xticklabels({'1960','1970','1980','1990','2000','2010'})
    xlabel('Year')
    ylabel('State')
    zlabel(['Temperature ',char(176), 'C'])
    title('Target Temperature')

    subplot(122)
    surfl(real(train_pred))
    yticks([1:5])
    yticklabels(state_name)
    xticks([0:10:50])
    xticklabels({'1960','1970','1980','1990','2000','2010'})
    xlabel('Year')
    ylabel('State')
    zlabel(['Temperature ',char(176), 'C'])
    title('Predicted Temperature')
    
    figure()
        %from 1960 to 2010; Error Plot
        for i = 1:5
        subplot(2,3,i)
        hold on
        grid on
        plot(train_time,temp_denoised(i,:)-real(train_pred(i,:)))
        xlabel('Year')
        ylabel(['Temperature ',char(176), 'C'])
        legend('Error')
        xlim([1960 2010])
        title(state_name{i})    
    end
end
%% Grabbing Data for 2011-2019
folder_name = 'Test Data/';
state_name = {'Alabama','Arizona','Georgia','Illinois','Virginia'};
start_date = '2011';
end_date = '2019';
test_data = []; time = [];
for iter = 1:length(state_name)
a = state_name{iter};
data = ReadMyCSV(folder_name,a, start_date, end_date);
test_data = [test_data;data(:,2)'];
end
time = data(:,1);
%% Predicting for 2011-2019
test_time = time;
temp3 = test_time-1960; % calibrating the time
test_pred = dmd_model.predict(temp3); % Predicting Future Data
%% Prediction Plots
if (verbose)
    figure()
    %from 2011-2019; 3D plots
    subplot(121)
    surfl(test_data)
    yticks([1:5])
    yticklabels(state_name)
    xticks([0:2:9])
    xticklabels({'2011','2013','2015','2017','2019'})
    xlabel('Year')
    ylabel('State')
    zlabel(['Temperature ',char(176), 'C'])
    title('Target Temperature')

    subplot(122)
    surfl(real(test_pred))
    yticks([1:5])
    yticklabels(state_name)
    xticks([0:2:9])
    xticklabels({'2011','2013','2015','2017','2019'})
    xlabel('Year')
    ylabel('State')
    zlabel(['Temperature ',char(176), 'C'])
    title('Predicted Temperature') 
    
    figure()
    %from 2011 to 2019; Error Plot
    for i = 1:5
        subplot(2,3,i)
        hold on
        grid on
        plot(test_time,test_data(i,:)-real(test_pred(i,:)))
        xlabel('Year')
        ylabel(['Temperature ',char(176), 'C'])
        legend('Error')
        xlim([2011 2019])
        title(state_name{i})    
    end    
end
%% Performance Evaluation
for i = 1:6
    if i==6
        temp = perf_analysis(temp_denoised,real(train_pred));
        train_result(i).rmse = temp.rmse;
        train_result(i).cc = temp.cc;
        
        temp = perf_analysis(test_data,real(test_pred));
        test_result(i).rmse = temp.rmse;
        test_result(i).cc = temp.cc;               
    else
        temp = perf_analysis(temp_denoised(i,:),real(train_pred(i,:)));
        train_result(i).rmse = temp.rmse;
        train_result(i).cc = temp.cc;
        
        temp = perf_analysis(test_data(i,:),real(test_pred(i,:)));
        test_result(i).rmse = temp.rmse;
        test_result(i).cc = temp.cc;
    end   
    
end
%% END
disp('DONE!')