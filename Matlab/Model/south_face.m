function irr= south_face(hoek,A,ray)
    intensity = ray{:,2};
    azimuth = ray{:,3};
    elevation = ray{:,4};
    diffusion = ray{:,6};

    len = size(intensity,1);
    irr = zeros(len,1);
    W = 0;
    for n=1:len
        alpha = elevation(n,1)*pi/180;
        beta = azimuth(n,1)*pi/180;
        inc = intensity(n,1);
        theta = hoek*pi/180;
        
        
        incx = inc_yz*cos(alpha);
        incz = inc_yz*sin(alpha);
        inc_pan = A*(incy*sin(theta) + incz*cos(theta));
        if inc_pan < 0
            inc_pan = 0;
        end
        irr(n,1) = inc_pan+A*diffusion(n,1);
    end
end