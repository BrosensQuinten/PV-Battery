function [tot_kWh,avg] = load_year(load_15m)
tot = 0;
load = load_15m{:,2};
len = size(load,1);
for i = 1:len
    tot = tot+load(i,1)*900;
end
tot_kWh = tot/3600;
avg = tot_kWh/24/365;
end

