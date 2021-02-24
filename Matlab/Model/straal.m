function [ray,date_time,intensity,azimuth,elevation,glob_rad,diffusion,len]=straal()
filename1 = 'Solar_Pos_Final.xlsx';
solar_position = readtable(filename1);
Azimuth = solar_position{:,2};
Elevation = solar_position{:,3};

filename2 = 'Irradiance_data.xlsx';
irr_data = readtable(filename2);
date_time = irr_data{:,1};
glob_rad = irr_data{:,2};
diff_rad = irr_data{:,3};


len = size(date_time,1);
intensity = zeros(len,1);
for i=1:len
    gl = glob_rad(i,1);
    ang = Elevation(i,1);
    intensity(i,1) = gl/sin(pi*ang/180);
end
azimuth = Azimuth(1:len,1);
elevation = Elevation(1:len,1);
diffusion = diff_rad;
ray = table(date_time, intensity, azimuth, elevation, glob_rad,diffusion);
end
