function [total_cost,capex,opex] = Tariffs(tariff,solar_panel,inverter,tot_day_con,tot_night_con,surface_area)

%capex = just sum of all installation costs
capex = solar_panel.price*surface_area/solar_panel.area + inverter.price; %batterijkost+installatiekost hier nog bij 




%opex -> depends on tariff used (1 = prosumer/netmetering, 2 = capacity)
%don't forget, together with TSO/DSO tariff also additional costs are payed
%maintenance, replace expanses

MAX_AC_INVERTER = invertor.rated_power; %aanpassen
tot_con = tot_day_con + tot_night_con;

%DSO_cost per year! (2020)
if tariff == 1
    DSO_prosum = 65.82*MAX_AC_INVERTER; %EUR/year
    DSO_perkwh = (0.0022583+0.0004138+0.0020559+0.0446218+0.0002022)*tot_con;
    DSO_gen = 98; %just a price per year to measure data
    DSO_day = 0.0401085 *tot_day_con;
    DSO_night = 0.0240651*tot_night_con;
    DSO_tot_cost = (DSO_prosum + DSO_perkwh + DSO_gen + DSO_day + DSO_night) * 1.21; % BTW
    
else
    
    
    
end

%TSO cost (2020)
TSO_withBTW =  0.0171844*1.21; %EUR/kwh with BTW
TSO_noBTW = 0.00329; %EUR/kwh
TSO_total = (TSO_withBTW + TSO_noBTW)*tot_con;

%Average electricity cost energy supplier (4 different suppliers)
ES_fixed_cost = 47.72; 
ES_day = 0.085375 *tot_day_con;
ES_night = 0.067275 * tot_day_night;
ES_tot_cost = ES_fixed_cost + ES_day + ES_night;

%total_cost = cap + opex -> to be minimized. 
opex = TSO_total + DSO_tot_cost + ES_tot_cost;


total_cost = opex + capex; 


























end