filename = 'Load_profile_final.xlsx';
load_15m = readtable(filename);
%[tot_day,avg_day]=load_day(load_15m,28,09);
[tot_year,avg_year] = load_year(load_15m);