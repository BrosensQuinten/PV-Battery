filename = 'Load_profile_final.xlsx';
load_15m = readtable(filename);
%[tot_day,avg_day]=load_day(load_15m,28,09);
%[tot_year,avg_year] = load_year(load_15m);
%[pf,injectie,consumptie]=Power_Flow(sunpower_maxeon_3,irr, load_15mpl);
%straal()


%
irr_15m = transpose(mean(reshape(irr, [15, 525600/15]),1));%takes the 15m average of the irradiance data

eff = 0.17;

power_diff_15m = eff*irr_15m/1000 - load_15m.Load_kW; %positive = power into grid, negative = power drawn from grid

%this code averages the irradiance over each of the months.
% month_indices = [1 2977 5666 8641 11521 14497 17377 20353 23329 26209 29185 32065 35041]; %indices in load/irr matrix of the start of each month
month_indices = [1 44641 84961 129541 172741 217381 260581 305221 349861 393061 437761 480961 525601];
irr_monthly = zeros(1,1);


for i = 1:size(month_indices,2)-1
    irr_monthly = vertcat(irr_monthly, mean(nonzeros(irr(month_indices(i): month_indices(i+1)-1))));
end
irr_monthly(1,:) = [];


[eff,T]=Efficiency(LG_Neon_5,irr_monthly);
T = T -273.15;
