function [Efficiency,Tz] = Efficiency(zonnepaneel,irr_monthly)
%this function calculated the adapted efficiency based on the monthly
%temperatures and irradiances and estimates the PV temperature using a natural
%convection iteration.

eff_nom = zonnepaneel.efficiency/100; %dit moest omgevormd worden naar een kommagetal onder 1!

A = 1;
L = 1;
k = 0.026;
v = 1.5497*10^(-5);
Pr = 0.71;
g = 9.81;
Ta =[6,0.8,5.4,13,16.3,18.1,22,19.4,15.4,12.6,7.4,5.8]+273.15;
Tz= [10,30,10,18,18,19,23,22,18,15,10,8]+273.15;
Tz= Tz;
Efficiency= [0,0,0,0,0,0,0,0,0,0,0,0];
temp_coef = zonnepaneel.power_temperature_coef/100; %moest ook omgevormd worden naar kommagetal onder 1.

for i = 1:12
%     Tz(i) = 25+273.15;
    T_prev = 100;
    while abs(Tz(i)-T_prev) > 5
        dT = Tz(i)-Ta(i);
        b = 1/Ta(i);
        Gr = g*b*dT*L^3/v^2;
        Ra = Gr*Pr;
        Nu = 0.15*Ra^(1/3);
        h = Nu*k/L; 
        T_prev = Tz(i);
        
         Q_out = (Tz(i) - Ta(i))*(h*A)+(Tz(i)^4-Ta(i)^4)*5.669*10^(-8)*A; %convectie + radiatie
         eff = 1-Q_out/irr_monthly(i);
    
%         Tz(i)= ((eff-eff_nom)/temp_coef)+298.15;
        if eff < 0
            Tz(i) = Tz(i) - 5;
        else
            
            rad = (Tz(i)^4-Ta(i)^4)*5.669*10^(-8)*A;
            Tz(i) = ((1-(1/irr_monthly(i))*(-Ta(i)*(h*A)+rad)-eff_nom)/temp_coef +298.15)/(1+(h*A)/(irr_monthly(i)*temp_coef));
            T_test = Tz(i);
        end
        a = abs(Tz(i)-T_prev);
    end
    Efficiency(i) = eff;
end 
end

