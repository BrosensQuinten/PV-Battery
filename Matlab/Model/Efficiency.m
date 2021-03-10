function [Efficiency,Tz] = Efficiency(zonnepaneel,irr_monthly)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

eff_nom = zonnepaneel.efficiency;
A = 1;
L = 1;
k = 0.026;
v = 1.5497*10^(-5);
Pr = 0.71;
g = 9.81;
Ta =[6,0.8,5.4,13,16.3,18.1,22,19.4,15.4,12.6,7.4,5.8]+273.15;
Tz= [0,0,0,0,0,0,0,0,0,0,0,0];
Efficiency= [0,0,0,0,0,0,0,0,0,0,0,0];
temp_coef = zonnepaneel.power_temperature_coef;
for i = 1:12
    Tz(i) = 25+273.15;
    T_prev = 100;
    while abs(Tz(i)-T_prev) > 0.1
        dT = Tz(i)-Ta(i);
        b = 1/Ta(i);
        Gr = g*b*dT*L^3/v^2;
        Ra = Gr*Pr;
        Nu = 0.15*Ra^(1/3);
        h = Nu*k/L; 
        T_prev = Tz(i);
        
        Q_out = (Tz(i) - Ta(i))*(h*A)+(Tz(i)^4-Ta(i)^4)*5.669*10^(-8)*A; %convectie 
        eff = 1-Q_out/irr_monthly(i);
        Tz(i)= (eff-eff_nom)/temp_coef+298.15;
    end
    Efficiency(i) = eff;
end 
end

