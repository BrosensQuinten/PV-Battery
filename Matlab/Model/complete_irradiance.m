% filename = 'Irradiance_data_with_timejump.xlsx';
filename2 = 'Irradiance_data_final.xlsx';

missing1 = period1; %put in missing data first period
missing2 = period2; %put in missing data from second period

% %Add change in timezone at 28 Oct. 03:00 in original data set (already
% done)
% start_read = readcell(filename,'Range','A394332:C487750'); %onderliggende data to be shifted
% second_read = readcell(filename,'Range','A394272:C394331'); %uur dat gekopieerd moet worden
% disp('readings done');
% writecell(start_read,filename,'Range','A394392:C487810'); %vorige index + 60 
% writecell(second_read,filename,'Range','A394332:C394391'); %fill in extra hour

%first data shift
read1 = readcell(filename2,'Range','A103181:C487810');
disp('Read1 done');
writecell(read1,filename2,'Range','A121386:C506015'); %vorige index + 18205 (aantal elementen in period1)
disp('first shift done');

%put in first period of missing data
writetable(missing1,filename2,'Range','A103181:C121385','WriteVariableNames',0); 
disp('first period done');

%second data shift
read2 = readcell(filename2,'Range','A243184:C506015'); %determine place for second insert (is shifted!)
disp('Read2 done');
writecell(read2,filename2,'Range','A260449:C523280'); %vorige index + 17265 (aantal elementen in period2)
disp('second shift done');

%put in second period of missing data
writetable(missing2,filename2,'Range','A243184:C260448','WriteVariableNames',0); 
disp('second period done');

