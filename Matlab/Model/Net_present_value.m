function NPV = Net_present_value(disc_rate,capex,opex,ref_opex,solar_panel, invertor, battery,bat)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
winst_per_jaar = ref_opex - opex;
NPV = -capex;
for i = 1:solar_panel.lifetime
    NPV = NPV +winst_per_jaar/(1+disc_rate)^i;
    if i == invertor.lifetime
        NPV = NPV - invertor.price/(1+disc_rate)^i;
    end
    if bat == 1
        if i==battery.lifetime
            NPV = NPV - battery.price/(1+disc_rate)^i;
        end
    end
end    
end

