function data = ReadMyCSV(folder_name,state_name,start_date,end_date)
% Reads the csv file of the temperature data for our project.
% Input:
%    - folder_name: The folder in which the data is stored in
%    - state_name : The State of the data. eg; Georgia, Illinois.
%    - start_data : The starting date of the data collection.
%    - end_date   : The ending date of the data collection.
% Output:
%    - data       : Contains the data extracted from csv file. The first column
%                   contains the year and the second column contains average
%                   temperature

filename = append(folder_name,state_name,'_',start_date,'_',end_date,'.csv');
data = readmatrix(filename);
temp1 = data(:,1);
temp1 = temp1/100;
data = [round(temp1),data(:,2)];

end