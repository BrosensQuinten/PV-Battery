function ray=straal()
filename1 = 'Solar_Pos_Final.xlsx';
solar_position = readtable(filename1);
Azimuth = solar_position{:,2};
Elevation = solar_position{:,3};

filename2 = 'Irradiance_data_final.xlsx';
irr_data = readtable(filename2);
date_time = irr_data{:,1};
glob_rad = irr_data{:,2};
diff_rad = irr_data{:,3};


len = size(date_time,1);
intensity = zeros(len,1);
for i=1:len
    intensity(i,1) = glob_rad(i,1)/sin(pi*Elevation(i,1180);
end
azimuth = Azimuth(1:len,1);
elevation = Elevation(1:len,1);
diffusion = diff_rad;
ray = table(date_time, intensity, azimuth, elevation, glob_rad,diffusion);
end
