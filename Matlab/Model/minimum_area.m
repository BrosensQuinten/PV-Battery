function [Optimal_area] = minimum_area(Efficiency,irr,load,solar_panel)


month_indices = [1 44641 84961 129541 172741 217381 260581 305221 349861 393061 437761 480961 525601];

opp = solar_panel.area;
length = size(irr,1);
pf = zeros(length,1);
error = 100;
surface_area = 0;
while error > 20
surface_area = surface_area+opp;
index = 1;

injectie = 0;
consumptie = 0;
    
for i=1:12
    
    eff = Efficiency(i);
    gen = surface_area*eff*irr/1000; % gedeeld door 1000 om in kW te zetten
    
    j = 0;
    counter = 0; % dit moet nul zijn, right?
    
    while j == 0

        pf(index,1) = (gen(index,1) - load(counter+1,1)); 

        if pf(index,1) > 0
            injectie = injectie + pf(index,1)/60; 
        else 
            consumptie = consumptie - pf(index,1)/60;
        end
        counter = floor(index/15);
        index = index + 1;
        if ismember(index,month_indices)
            j = 1;
        end
            
    end
end
error = consumptie - injectie; %Het verschil wordt nu geoptimaliseerd, maar de absolute waarden kunnen
%nog steeds zeer groot zijn. Misschien een minimum som bepalen? (cons + inj
%minimaliseren)

end
Optimal_area = surface_area;
end
