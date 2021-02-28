function [irr,W] = east_west(hoek,A)
[ray,date_time,intensity,azimuth,elevation,glob_rad,diffusion,len]=straal();
 irr = zeros(len,1);
 W=0;
 for n=1:len
        alpha = elevation(n,1)*pi/180;
        beta = azimuth(n,1)*pi/180;
        inc = intensity(n,1);
        theta = hoek*pi/180;
        if beta<pi
            inc_yz = inc*sin(beta);
        else 
            inc_yz = -inc*sin(beta);
        end
           incy = inc_yz*cos(alpha);
        incz = inc_yz*cos(alpha); %waarom niet inc*sin(alpha)?
        inc_pan = A*(incy*sin(theta) + incz*cos(theta)); %zcomponenet for whole A, tangential for A/2?
        if inc_pan < 0
            inc_pan = 0;
        end
        irr(n,1) = inc_pan+A*diffusion(n,1);
        W = W + irr(n,1);
    
 end
 end

