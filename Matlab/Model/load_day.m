function [tot_kWh,avg] = load_day(load_15m,day,month)
tot = 0;
date_time = load_15m{:,1};
load = load_15m{:,2};
index_start = find(date_time == datetime(2018,month,day,00,00,00));
index_end = index_start + 96;
for i = index_start:index_end
    tot = tot+ 900*load(i,1); %totale load op een dag in kJ
end
tot_kWh = tot/3600; %totale load in kWh
avg = tot_kWh/24;
end

