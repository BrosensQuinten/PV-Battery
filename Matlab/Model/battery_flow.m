function [pf,injectie,consumptie, battery_charge] = battery_flow(Efficiency,inverter, irr,load, surface_area, battery)
%load in KW, battery charge in kwh

month_indices = [1 44641 84961 129541 172741 217381 260581 305221 349861 393061 437761 480961 525601];


length = size(irr,1);
pf = zeros(length,1);
battery_charge = zeros(length+1,1); %first index gets cut of at the end

index = 1;

injectie = 0;
consumptie = 0;
    
for i=1:12
    
    eff = Efficiency(i)*inverter.efficiency;
    gen = surface_area*eff*irr/1000; % gedeeld door 1000 om in kW te zetten
    
    j = 0;
    counter = 0; % dit moet nul zijn
    
    while j == 0

        pf(index,1) = (gen(index,1) - load(counter+1,1))/60; %/60 to convert from kwmin to kwh
        
        
        if pf(index,1) > 0
            if pf(index, 1) + battery_charge(index, 1) < battery_capacity
                battery_charge(index+1,1) = battery_charge(index,1) + battery_efficiency*pf(index,1);
                pf(index,1) = 0;
            else
                pf(index,1) = pf(index,1) + (battery_charge(index,1) - battery_capacity)/battery_efficiency;
                battery_charge(index+1) = battery_capacity;
            injectie = injectie + pf(index,1); 
            end
        else 
            if pf(index, 1) + battery_charge(index, 1) > 0
                battery_charge(index+1,1) = battery_charge(index,1) + pf(index,1)/battery_efficiency;
                pf(index,1) = 0;
            else
                pf(index,1) = pf(index,1) + battery_charge(index,1)*battery_efficiency;
                battery_charge(index+1) = 0;  
            end
            consumptie = consumptie - pf(index,1);
        end
        counter = floor(index/15);
        index = index + 1;
        if ismember(index,month_indices)
            j = 1;
        end    
    end
   
    
end
battery_charge(1) = [];
end

