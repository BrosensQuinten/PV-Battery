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
    gl = glob_rad(i,1)-diff_rad(i,1);
    
    if gl<5
        gl = 0;
    end
    
    if Elevation(i,1) > 5
    intensity(i,1) = gl/sin(pi*Elevation(i,1)/180);
    else
        intensity(i,1) = 0;
    end
end
azimuth = Azimuth(1:len,1);
elevation = Elevation(1:len,1);
diffusion = diff_rad;
ray = table(date_time, intensity, azimuth, elevation, glob_rad,diffusion);
end
