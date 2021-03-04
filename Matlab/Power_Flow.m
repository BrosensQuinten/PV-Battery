function [pf,injectie,consumptie] = Power_Flow(Solar_panel,irr,load)
eff = Solar_panel.efficiency;
gen = eff*irr/1000; % gedeeld door 1000 om in kW te zetten
length = size(gen,1);
pf = zeros(length,1);
injectie = 0;
consumptie = 0;
for i = 1:length-1
    pf(i,1) = (gen(i,1) - load(floor(i/15)+1,1))/60;%verschil in kWh
    if pf(i,1) > 0
        injectie = injectie + pf(i,1);
    else 
        consumptie = consumptie - pf(i,1);
    end
    
end

