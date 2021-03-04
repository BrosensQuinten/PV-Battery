function [tot_kWh,avg] = load_year(load_15m)
tot = 900*sum(load_15m{:,2});
tot_kWh = tot/3600;
avg = tot_kWh/24/365;
end

