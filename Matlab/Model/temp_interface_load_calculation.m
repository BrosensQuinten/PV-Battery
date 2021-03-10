filename = 'Load_profile_final.xlsx';
load_15m = readtable(filename);
%[tot_day,avg_day]=load_day(load_15m,28,09);
%[tot_year,avg_year] = load_year(load_15m);
[pf,injectie,consumptie]=Power_Flow(sunpower_maxeon_3,irr, load_15mpl);
%straal()


%%
temp = transpose(mean(reshape(irr, [15, 525600/15]),1));

power_diff_15m = temp - load_15m.Load_kW; %positive = power into grid, negative = power drawn from grid