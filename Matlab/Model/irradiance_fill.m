function filled_irradiance = irradiance_fill(irradiance)
    %%this function takes the irradiance data and fills in the missing
    %%dates from 14-mar-2018 to 26-mar-2018 and from 20-jun-2018 to
    %%02-jul-2018.
    
    startdate1 = datetime(2018,03,13,15,39,00);
    enddate1 = datetime(2018,03,26,08,03,00);
    missingperiod1 = startdate1:minutes(1):enddate1;
    missingperiod1 = transpose(missingperiod1);
    index1 = find(irradiance_data.DateTime == datetime(2018,03,13,15,38,00));
    
    startdate2 = datetime(2018,06,20,12,43,00);
    enddate2 = datetime(2018,07,02,12,27,00);
    missingperiod2 = startdate2:minutes(1):enddate2;
    missingperiod2 = transpose(missingperiod2);
    index2 = find(irradiance_data.DateTime == datetime(2018,06,20,12,42,00));
end

