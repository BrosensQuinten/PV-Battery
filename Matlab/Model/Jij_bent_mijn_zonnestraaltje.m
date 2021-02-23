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
for i=1:10000
    gl = glob_rad(i,1);
    ang = Elevation(i,1);
    intensity(i,1) = gl/sin(pi*ang/180);
end
azimuth = Azimuth(1:len,1);
elevation = Elevation(1:len,1);
diffusion = diff_rad;
ray = table(date_time, intensity, azimuth, elevation, glob_rad,diffusion);

function [irr,W] = south_face(hoek,A)
    irr = zeros(len,1);
    W = 0;
    for n=1:len
        alpha = elevation(n,1)*pi/180;
        beta = azimuth(n,1)*pi/180;
        inc = intensity(n,1);
        theta = hoek*pi/180;
        
        inc_yz = -inc*cos(beta);
        incy = inc_yz*cos(alpha);
        incz = inc_yz*cos(alpha);
        inc_pan = A*(incy*sin(theta) + incz*cos(theta));
        if inc_pan < 0
            inc_pan = 0;
        end
        irr(n,1) = inc_pan+A*diffusion;
        W = W + irr(n,1);
    end
end

function [irr,W] = east_west(hoek,A)
 irr = zeros(len,1);
 for n=1:len
        alpha = elevation(n,1)*pi/180;
        beta = azimuth(n,1)*pi/180;
        inc = intensity(n,1);
        theta = hoek*pi/180;
        if beta<pi
            inc_yz = inc*cos(beta-pi/4);
        else 
            inc_yz = inc*cos(beta-3*pi/4);
           incy = inc_yz*cos(alpha);
        incz = inc_yz*cos(alpha);
        inc_pan = A*(incy*sin(theta) + incz*cos(theta));
        if inc_pan < 0
            inc_pan = 0;
        end
        irr(n,1) = inc_pan+A*diffusion;
        W = W + irr(n,1);
    
 end
 end
end

