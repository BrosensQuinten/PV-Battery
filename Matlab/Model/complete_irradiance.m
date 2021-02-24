filename = 'Irradiance_data.xlsx';
filename2 = 'Irradiance_data_testfile.xlsx';

read1 = readmatrix(filename,'Range','A103181:C487750');
writematrix(filename2,'Range','A103181:C487750');

% writematrix(head,filename,'Sheet1',1,'Range','A1:C3')
% writecell(sun_tab,filename,'Sheet1',1,'Range','A2:C525601')