function [irr,W] = south_face(hoek,A)
[ray,date_time,intensity,azimuth,elevation,glob_rad,diffusion,len]=straal();
    irr = zeros(len,1);
    W = 0;
    for n=1:len
        alpha = elevation(n,1)*pi/180;
        beta = azimuth(n,1)*pi/180;
        inc = intensity(n,1);
        theta = hoek*pi/180;
        
        inc_yz = -inc*cos(beta);
        incy = inc_yz*cos(alpha);
        incz = inc_yz*sin(alpha); %inc_yz -> inc zijn?
        inc_pan = A*(incy*sin(theta) + incz*cos(theta));
        if inc_pan < 0
            inc_pan = 0;
        end
        irr(n,1) = inc_pan+A*diffusion(n,1);
        W = W + irr(n,1); %vermogens optellen heeft geen betekenis? 
    end
end

