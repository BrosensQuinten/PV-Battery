%% This script adds the missing rows in the irradiance data file
path = [pwd , '\Data\Irradiance_data.mat'];
irradiance_data = load(path);
irradiance_data = irradiance_data.Irradiancedata;

%% Create missing datetimes
Y = 2018;

M = 03;
missingperiod1 = datetime([Y M 14 0 0 0]);

for D = 14:25
    for H = 0:24
        for MI = 0:60
            datevector = [Y M D H MI 0];
            missingperiod1 = vertcat(missingperiod1 , datetime(datevector));
        end
    end
end


date_time = irradiance_data(1,1);