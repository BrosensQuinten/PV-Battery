%% this script plots interesting figures after running of the user interface
%plotting of the given irradiance and load profile

%load in given irradiance profile
filename2 = 'Irradiance_data_final.xlsx';
irr_data = readtable(filename2);
date_time = irr_data{:,1};
glob_rad = irr_data{:,2};
diff_rad = irr_data{:,3};
%% global and diffuse irradiation

len1 = size(glob_rad,1);

%figure
subplot(1,2,1)
plot(date_time(1:len1), glob_rad(1:len1));
ylabel('Direct Global Irradiance in W/m�')
subplot(1,2,2)
plot(date_time(1:len1),diff_rad(1:len1));
ylabel('Diffuse Global Irradiance in W/m�')

%% load profile
len2 = 1000;
loadlen = size(load,1);
date_time_quarter = date_time(1:15:size(glob_rad,1));

%%
figure
subplot(1,2,1)
plot(date_time_quarter(1:len2), load(1:len2));
ylabel('Load per quarter in kW')
subplot(1,2,2)
plot(date_time_quarter(1:loadlen),load(1:loadlen));
ylabel('Load per quarter in kW')