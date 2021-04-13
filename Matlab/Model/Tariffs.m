function [total_cost,capex,opex] = Tariffs(tariff,solar_panel,inverter,cons_dag,cons_nacht,net_cons_dag, net_cons_nacht,nb_panels,battery,bat)

%capex = just sum of all installation costs
capex = solar_panel.price*nb_panels + inverter.price+installation_cost(nb_panels); %batterijkost+installatiekost hier nog bij 
if bat == 1
    capex = capex + battery.price;
end


%opex -> depends on tariff used (1 = prosumer/netmetering, 2 = capacity)
%don't forget, together with TSO/DSO tariff also additional costs are payed
%maintenance, replace expanses

MAX_AC_INVERTER = inverter.rated_power; %aanpassen


%DSO_cost per year! (2020)
if tariff == 1
    tot_net_con = net_cons_dag + net_cons_nacht;
    DSO_prosum = 65.82*MAX_AC_INVERTER; %EUR/year
    DSO_perkwh = (0.0022583+0.0004138+0.0020559+0.0446218+0.0002022)*tot_net_con;
    DSO_gen = 98; %just a price per year to measure data
    DSO_day = 0.0401085 *net_cons_dag;
    DSO_night = 0.0240651*net_cons_nacht;
    DSO_tot_cost = (DSO_prosum + DSO_perkwh + DSO_gen + DSO_day + DSO_night) * 1.21; % BTW
    
else
    tot_con = cons_dag + cons_nacht;
    DSO_perkwh = (0.0022583+0.0004138+0.0020559+0.0446218+0.0002022)*tot_con;
    DSO_gen = 98; %just a price per year to measure data
    DSO_day = 0.0401085 *cons_dag;
    DSO_night = 0.0240651*cons_nacht;
    DSO_tot_cost = (DSO_perkwh + DSO_gen + DSO_day + DSO_night) * 1.21; % BTW
    
end

%TSO cost (2020)
tot_con = cons_dag + cons_nacht;
TSO_withBTW =  0.0171844*1.21; %EUR/kwh with BTW
TSO_noBTW = 0.00329; %EUR/kwh
TSO_total = (TSO_withBTW + TSO_noBTW)*tot_con;

%Average electricity cost energy supplier (4 different suppliers)
ES_fixed_cost = 47.72; 
ES_day = 0.085375 *cons_dag;
ES_night = 0.067275 * cons_nacht;
ES_tot_cost = ES_fixed_cost + ES_day + ES_night;

%total_cost = cap + opex -> to be minimized. 
opex = TSO_total + DSO_tot_cost + ES_tot_cost;


total_cost = opex + capex; 


























end