function [gen_pf,pf,injectie,consumptie] = Power_Flow(Efficiency,irr,load, surface_area, invertor)


month_indices = [1 44641 84961 129541 172741 217381 260581 305221 349861 393061 437761 480961 525601];


length = size(irr,1);
pf = zeros(length,1);
gen_pf = zeros(length,1);

index = 1;

injectie = 0;
consumptie = 0;
    
for i=1:12
    
    eff = Efficiency(i)*invertor.efficiency;
    gen = surface_area*eff*irr/1000; % gedeeld door 1000 om in kW te zetten
    
    j = 0;
    counter = 0; % dit moet nul zijn, right?
    
    while j == 0

        pf(index,1) = gen(index,1) - load(counter+1,1); 
        gen_pf(index,1) = gen(index,1);
        if pf(index,1) > 0
            if pf(index,1) < invertor.rated_power
                injectie = injectie + pf(index,1)/60; 
            else
                injectie = injectie+invertor.rated_power/60;
                pf(index,1) = invertor.rated_power;
            end
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

