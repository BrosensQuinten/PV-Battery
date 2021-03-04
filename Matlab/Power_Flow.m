function [pf,injectie,consumptie] = Power_Flow(Solar_panel,irr,load_15m,A)
eff = Solar_panel.efficiency;
gen = eff*irr*A/1000; % gedeeld door 1000 om in kW te zetten
load = load_15m{:,2};
length = size(gen,1);
pf = zeros(length,1);
injectie = 0;
consumptie = 0;
for i = 1:length-1
    pf = (gen(i,1) - load(floor(i/15)+1,1))/60;%verschil in kWh
    if pf > 0
        injectie = injectie + pf;
    else 
        consumptie = consumptie - pf;
    end
    
end

