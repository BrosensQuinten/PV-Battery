function t = Payback_time(capex,opex,ref_opex,solar_panel, invertor, battery,bat)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
cost = capex;
t=0;
savings = (ref_opex - opex);
while cost > savings*t
    t = t+1;
end
if t > solar_panel.lifetime || t>invertor.lifetime
    disp("lifetime exceeded");
   return
elseif bat == 1
    if t > battery.lifetime
        disp("lifetime exceeded");
        return
    end
end
end

