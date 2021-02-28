function irr= east_west(hoek,A,ray)
intensity = ray(:,2);
azimuth = ray(:,3);
elevation = ray(:,4);
diffusion = ray(:,6);
len = size(intensity,1);
irr = zeros(len,1);
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
        incz = inc*sin(alpha);
        inc_pan = A*(incy*sin(theta)/2 +incz*cos(theta));
        if inc_pan < 0
            inc_pan = 0;
        end
        irr(n,1) = inc_pan+A*diffusion(n,1);
 end
 end

