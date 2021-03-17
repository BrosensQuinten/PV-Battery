function [pf,injectie,consumptie] = Power_Flow(Solar_panel,irr,load)
eff = Solar_panel.efficiency;
L = load(:,1);
gen = eff/100*irr/1000; % gedeeld door 1000 om in kW te zetten
length = size(gen,1);
pf = zeros(length,1);
injectie = 0;
consumptie = 0;
counter = 0;

for i = 1:length
    
    pf(i,1) = (gen(i,1) - L(counter+1,1));
    
    if pf(i,1) > 0
        injectie = injectie + pf(i,1)/60; % waarom deling door 60?
    else 
        consumptie = consumptie - pf(i,1)/60;
    end
    counter = floor(i/15);
end

