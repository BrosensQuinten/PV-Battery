
    startdate1 = datetime(2018,03,13,15,39,00);
    enddate1 = datetime(2018,03,26,08,03,00);
    missingperiod1 = startdate1:minutes(1):enddate1;
    missingperiod1 = transpose(missingperiod1);
    index1 = find(irradiance_data.DateTime == datetime(2018,03,13,15,38,00));
    
    %%
    globrad = irradiance_data.GlobRad;
    diffrad = irradiance_data.DiffRad;
    
    for i = 1:length(missingperiod1)
        nextmonth = missingperiod1(i,1) + calmonths(1);
        prevmonth = missingperiod1(i,1) - calmonths(1);
        nextindex = find(irradiance_data.DateTime == nextmonth);
        previndex = find(irradiance_data.DateTime == prevmonth);
        missingperiod(i,1) = (globrad(nextindex) + globrad(previndex))/2;
        missingperiod(i,2) = (diffrad(nextindex) + diffrad(previndex))/2;
    end
    
    %%
    period1 = table(missingperiod1,missingperiod(:,1),missingperiod(:,2));
    
    %%
    startdate2 = datetime(2018,06,20,12,43,00);
    enddate2 = datetime(2018,07,02,12,27,00);
    missingperiod2 = startdate2:minutes(1):enddate2;
    missingperiod2 = transpose(missingperiod2);
    index2 = find(irradiance_data.DateTime == datetime(2018,06,20,12,42,00));
    
    %%
    for i = 1:length(missingperiod2)
        nextmonth = missingperiod2(i,1) + calmonths(1);
        prevmonth = missingperiod2(i,1) - calmonths(1);
        nextindex = find(irradiance_data.DateTime == nextmonth);
        previndex = find(irradiance_data.DateTime == prevmonth);
        radinterpolate(i,1) = (globrad(nextindex) + globrad(previndex))/2;
        radinterpolate(i,2) = (diffrad(nextindex) + diffrad(previndex))/2;
    end
    %%
    period2 = table(missingperiod2,radinterpolate(:,1),radinterpolate(:,2));