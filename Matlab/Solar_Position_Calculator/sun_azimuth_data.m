disp(' ')
disp('WARNING:')
disp('Skipping any field, with a hyphen before it, will result ')
disp('in termination of execution of this script. Fields with ')
disp('some value, in square brackets after them, represent their')
disp('default values.')
disp(' ')

%extra declarations
sun_list = cell(1,365);
sun_tab = cell(35040,3);
flag = 1;

% Input the Location of the Observer
locstr = input('- Enter the Location of the Observer: ','s');
if  isempty(locstr) == 1
    return
end

% Input the Country of the Observer
countrystr = input('  Enter the Country of the Observer: ','s');
if  isempty(countrystr) == 1
    country_set = 0;
else
    country_set = 1;
end

% Input the Name of the GPS Receiver Set used for determining
% the Observer's Geodetic Coordinates
gpsstr = input('  Enter the GPS Receiver Set Title: ','s');
if  isempty(gpsstr) == 1
    gps_set = 0;
else
    gps_set = 1;
end

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% The Geodetic Coordinates of the Observer.
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
disp(' ')

% Input the Longitude in dd.dddddd° Format
location.longitude = input('- Enter the Longitude (in dd.dddddd° Format) : E ');
if  isempty(location.longitude) == 1
    return
end

% Input the Latitude in dd.dddddd° Format
location.latitude = input('- Enter the Latitude (in dd.dddddd° Format) : N ');
if  isempty(location.latitude) == 1
    return
end

% Input the Altitude in Meters
location.altitude = input('  Enter the Altitude (in meters) [0] : ');
if  isempty(location.altitude) == 1
    location.altitude = 0;
end

% Save the Longitude in ddd° mm' ss.s" Format
[long_format2(1),long_format2(2),long_format2(3)] = formatchange(location.longitude);

% Save the Latitude in ddd° mm' ss.s" Format
[lat_format2(1),lat_format2(2),lat_format2(3)] = formatchange(location.latitude);

% Input the Time Zone of the Observer
offset_utc = input('- Enter the Time Zone (+GMT Zone) : ');
if  isempty(offset_utc) == 1
    return
end
disp(' ')

time.UTC = offset_utc;

% Input the Date for which the Sun Azimuth Position Data is to be generated
% Date Format : dd-Mmm-yyyy
%     data_date = input('- Enter the Date (in dd-Mmm-yyyy format) : ','s');
%     if  isempty(data_date) == 1
%     return
%     end
data_date = '01-Jan-2018';
    data_date_sdn = datenum(data_date);             % Serial Date Number from 1-Jan-0000
    date_mat = datevec(data_date_sdn);              % Date components
    


datentime(1) = date_mat(1);							% 'datentime' holds the value of starting time.
datentime(2) = date_mat(2);
datentime(3) = date_mat(3);
day_amount = 365;
for j=1:day_amount
    
% Input the Starting Time, Number of Intervals and Duration of Interval
% for which the Sun Azimuth Position Data is to be generated.
% data_time = input ('- Enter the Starting Time (in HH:MM:SS [24 Hours] format) : ','s');
% if  isempty(data_time) == 1
% return
% end
data_time = '00:00:00';

data_time_sdn = datenum(data_time);
time_mat = datevec(data_time_sdn);

datentime(4) = time_mat(4);
datentime(5) = time_mat(5);
datentime(6) = time_mat(6);

% Ensure time values to be valid
[time.year,time.month,time.day,time.hour,time.min,time.sec] = validate(datentime(1),datentime(2),datentime(3),datentime(4),datentime(5),datentime(6));

% Input the Duration and Number of Intervals for Sun Position calculation
% dur_interval = input ('  Enter the Duration of Interval (in minutes) [5] : ');
% if  isempty(dur_interval) == 1
%     dur_interval = 5;
% end
dur_interval = 1;
dur_interval_sdn = dur_interval / (24 * 60);

% time_span = input ('  Enter the Total Time Span (in hours) [24 Hours] : ');
% if  isempty(time_span) == 1
%     time_span = 24;
% end
time_span = 24;
num_interval = (time_span * 60 / dur_interval);

sunaz_timesdn(1) = data_time_sdn;                   % The Serial Date Number of the Time Values are stored for printing purposes.



% Calculate the Sun Azimuth/elevation for given times

for i = 1 : num_interval,
%     sunaztime(1,i) = time.month;
%     sunaztime(2,i) = time.day;
%     sunaztime(3,i) = time.hour;
%     sunaztime(4,i) = time.min;
%     sunaztime(5,i) = time.sec;

  if (time.month == 3) && (time.day == 25) && (time.hour == 2)
      disp('hey');
        time.UTC = offset_utc +1;
        time.hour = 3;
  elseif (time.month == 10) && (time.day == 28) && (time.hour == 3)
      if flag == 1
          disp('hoy');
        flag = 0;
        time.UTC = offset_utc;
        time.hour = 2;
      end
  end
  
DateVector = [time.year,time.month,time.day,time.hour,time.min,time.sec];
test = datestr(DateVector);
sun_tab{i+(j-1)*1440,1} = test;



    
    sunaztime(i,1) = time.month;
    sunaztime(i,2) = time.day;
    sunaztime(i,3) = time.hour;
    sunaztime(i,4) = time.min;
    sunaztime(i,5) = time.sec;
    
  
        
    sun(i) = sun_position(time,location);
    

    sun_az_format1(i,1) = sun(i).azimuth;           % Result in ddd.dddd° Format
    
                                                    % Result in ddd° mm' ss.s" Format
    [sun_az_format2(i,1),sun_az_format2(i,2),sun_az_format2(i,3)] = formatchange(sun_az_format1(i));
    
    sun_el_format1(i,1) = sun(i).elevation;

    time.min = time.min + dur_interval;
    sunaz_timesdn(i+1) = sunaz_timesdn(i) + dur_interval_sdn;   % Generate the Serial Date Number for the next time value
    [time.year,time.month,time.day,time.hour,time.min,time.sec] = validate(time.year,time.month,time.day,time.hour,time.min,time.sec);
end

% Create a 'sun_azdata' variable, to store Sun Azimuth results in both formats.
% To be used while printing the results.

sun_azdata = horzcat(sunaztime,sun_az_format1,sun_az_format2,sun_el_format1);
sec_temp = round(sun_azdata(7,:));					% The seconds in the Sun Azimuth are rounded off.
sun_azdata(7,:) = sec_temp;

start = 1 +(j-1)*1440;

for k=1:1440
sun_tab{start+k-1,2} = sun_azdata(k,6);
sun_tab{start+k-1,3} = sun_azdata(k,10);
end
sun_list{1,j} = sun_azdata; %for ascii file

datentime(2) = date_mat(2);
date_mat(3) = date_mat(3)+1;
datentime(3) = date_mat(3);

% disp(datentime(3));

end
% Store last time value in 'time' structure.
time.min = time.min - dur_interval;

%write an excel file
head = ["DateTime","Azimuth","Elevation"];
filename = 'Solar_Position3.xlsx';

writematrix(head,filename,'Sheet',1,'Range','A1:C3')
writecell(sun_tab,filename,'Sheet',1,'Range','A2:C525601')




% % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% % Generate an ASCII Text File (Report) containing Sun Azimuth Data.
% % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% 
% % Derive the Filename from the given information.
% % The nomenclature pattern is as follows:
% % It contains the Date for which data is generated, and Location of the observer.
% % ddMmmyyyyLocation
% 
% % Extract Date without any hyphen. 
% ndatestr = [];
% for i = 1:max(size(data_date))
%     if data_date(i) ~= '-'
%         ndatestr = [ndatestr data_date(i)];
%     end
% end
% 
% % Extract Location without any comma or space. 
% loctitle = [];
% for i = 1:max(size(locstr))
%     if ([locstr(i) ~= ','] & [locstr(i) ~= ' '])
%         loctitle = [loctitle locstr(i)];
%     end
% end
% 
% % Generate the name of the Output file.
% namestr = strcat(ndatestr,loctitle,'.doc');
% 
% % Write the Output ASCII File.
% fid = fopen(namestr,'w');
% 
% % Write the Header of the Output.
% fprintf(fid,'Output File is generated on ');
% fprintf(fid,datestr(clock,1));
% fprintf(fid,' at ');
% fprintf(fid,datestr(clock,13));
% fprintf(fid,' hours.\n\n------------------------------------------------------------------------------\n');
% 
% fprintf(fid,'Data Generated for:\t');
% fprintf(fid,data_date);
% fprintf(fid,'\n');
% fprintf(fid,'Location:\t\t\t');
% fprintf(fid,locstr);
% fprintf(fid,'\n');
% 
% if country_set == 1;
%     fprintf(fid,'Country:\t\t\t');
%     fprintf(fid,countrystr);
%     fprintf(fid,'\n');
% end
% 
% fprintf(fid,'------------------------------------------------------------------------------\n\n');
% 
% if gps_set == 1;
%     fprintf(fid,'Using ');
%     fprintf(fid,gpsstr);
%     fprintf(fid,' Receiver Set, the');
% elseif gps_set == 0
%     fprintf(fid,'The');
% end
% 
% fprintf(fid,' geodetic coordinates of the observer location have been determined as:\n\n');
% fprintf(fid,'Latitude:\t N ');
% fprintf(fid,'%3.6f',location.latitude);
% fprintf(fid,'°\t\tN ');
% fprintf(fid,num2str(lat_format2(1)));
% fprintf(fid,'° ');
% fprintf(fid,num2str(lat_format2(2)));
% fprintf(fid,'m ');
% fprintf(fid,'%2.1f',lat_format2(3));
% fprintf(fid,'"\nLongitude:\t E ');
% fprintf(fid,'%3.6f',location.longitude);
% fprintf(fid,'°\t\tE ');
% fprintf(fid,num2str(long_format2(1)));
% fprintf(fid,'° ');
% fprintf(fid,num2str(long_format2(2)));
% fprintf(fid,'m ');
% fprintf(fid,'%2.1f',long_format2(3));
% fprintf(fid,'"\nAltitude:\t ');
% fprintf(fid,num2str(location.altitude));
% fprintf(fid,'m\n\n');
% 
% fprintf(fid,'Time Zone:\t GMT ');
% if sign(time.UTC)
%     fprintf(fid,'+');
% end
% fprintf(fid,num2str(time.UTC));
% fprintf(fid,' Hours\n\n');
% 
% fprintf(fid,'The readings are taken from ');
% fprintf(fid,datestr(sunaz_timesdn(1),13));
% fprintf(fid,' to ');
% fprintf(fid,datestr(sunaz_timesdn(num_interval),13));
% fprintf(fid,' Local Standard Time.\n\nTime Interval:\t\t');
% fprintf(fid,datestr(dur_interval_sdn,13));
% fprintf(fid,'\nTotal Time Span:\t\t');
% fprintf(fid,datestr((sunaz_timesdn(num_interval)-sunaz_timesdn(1)),13));
% fprintf(fid,' Hours\nData Values Count:\t');
% fprintf(fid,num2str(num_interval));
% fprintf(fid,'\n\n');
% 
% fprintf(fid,'------------------------------------------------------------------------------');
% fprintf(fid,'\tTime\t\t|\t\tSun Azimuth\t\t\t\t|\tElevation\n');
% fprintf(fid,'\t\t\t\t|-----------------------------------------------------------\n');
% fprintf(fid,'Mm:dd:HH:MM:SS\t|\tddd.dddd°\t|\tddd°  mmm  ss"\t|\n');
% fprintf(fid,'------------------------------------------------------------------------------');
% fprintf(fid,'\n\t\t\t|\t\t\t|\n');
% 
% i = 1;
% while i <= 365
% fprintf(fid,'%2.0f:%2.0f:%2.0f:%2.0f:%2.0f\t|\t%3.4f°\t|\t%3.0f°  %2.0fm  %2.0f\t|\t%3.4f°\n',sun_list{1,i});
% i = i + 1;
% end
% 
% fprintf(fid,'\t\t\t|\t\t\t|\n');
% fprintf(fid,'------------------------------------------------------------------------------');
% status = fclose(fid);
% 
% % Print the destination folder of the output file.
% folder_path = cd;
% comp_path = strcat(folder_path,'\',namestr);
% result_path = strcat('The output file is saved as -',comp_path);
% disp(result_path)
% disp(' ')
% 
% % Delete unnecessary variables from the Workspace.
% clear offset_utc opt_prompt
% clear i num_interval dur_interval
% clear date_mat
% clear data_date_sdn data_time_sdn datentime time_mat
% clear fraction_part degree_part minute_part second_part
% clear locstr