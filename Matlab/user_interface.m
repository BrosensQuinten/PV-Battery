%                        User interface                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%!!!IMPORTANT!!! current directory has to be  ..\PV_battery\Matlab or the
%code doesnt work. Also all subfolders have to be added to the path.


%%%%%%% Which technical components are used? %%%%%%%%%%%%%%%%%
%these are data classes (import possibly necessary)
if exist('solar_name') == 0
    solar_name = ["sunpower_maxeon_3.mat", "Panasonic.mat", "LG_Neon_5.mat", "JA_SOLAR.mat", "Canadian_solar.mat"];
    for i = 1:size(solar_name, 2) 
        load(fullfile(pwd, "Data\Solar module data\",solar_name(i)));
    end
end
solar_panel = JA_SOLAR;

% load in inverters into workspace
if exist('inverter_names') == 0
    inverter_names = ["Solar_Edge_4.mat", "Solar_Edge_3.mat", "Fronius_Symo.mat"];
    for i = 1:size(inverter_names, 2) 
        load(fullfile(pwd, "Data\Inverters\",inverter_names(i)));
    end
end % two cases: directly from solar panel to the grid or from battery to grid

DC_converter = ''; % used for battery
battery = '';
%additional safety equipment?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% RUN ONE TIME TO SAVE TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('ray') == 0
    ray = straal(); % kan je 1 keer runnen en dan scenario's vergelijken.
end

if exist('Loadprofilefinal') == 0
    load(fullfile(pwd, "Data\Load_profile.mat")); % kan je 1 keer runnen en dan scenario's vergelijken.
    load = Loadprofilefinal{:,2};
end
% filename = 'Load_profile_final.xlsx';
% load_15m = readtable(filename);
% load = load_15m{:,2};

% USEFULL DECLARATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

roof_width = 12.37; % updaten met merijn
roof_height = 4.42; %schuine hoogte van dak
roof_angle = 30; %only used for gable roof 
%surface_area = roof_area; %oppervlakte aan zonnepanelen, kan later nog variabel worden miss?


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% DEFINE USER INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

roof = input('Flat (1) or gable roof (2)?: '); 
if  isempty(roof) == 1
    return;
elseif (roof ~= 1) && (roof ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
    return
end

orientation = input('In which direction are the PV panels installed? Possible answers: 1 (South), 2 (EW): ');
if  isempty(orientation) == 1
    return;
elseif (orientation ~= 1) && (orientation ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
    return
end

fill = input('Is the roof entirely filled with panels (1) or just enough to compensate the load (2)?: ');
if isempty(fill) == 1
    return;
elseif (fill ~= 1) && (fill ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
    return
end
tariff = input('Which tariff is used? Prosumer (1) or self_consuming (2)?: ');
if  isempty(tariff) == 1
    return;
elseif (tariff ~= 1) && (tariff ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
    return
end

bat = input('Is a battery included? YES (1) or NO (2)?: ');
if  isempty(bat) == 1
    return;
elseif (bat ~= 1) && (bat ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
    return
end

disp('Thank you. Performing calculations...');
%%
%%%%%%%%%%% Calculate total received power (total irradiance) %%%%%%%%%



if roof == 1 && orientation == 1 && fill == 1
    disp('The most optimal angle is 43 degrees. Angle_Optimization.m');
    angle = 43;
    roof_area = roof_width*2*roof_height*cos(roof_angle*pi/180);
    nb_panels = floor(roof_area/solar_panel.area);
    inv = Fronius_Symo;
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
    end
    surface_area = nb_panels*solar_panel.area;
    irr = south_face(angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
elseif roof == 1 && orientation == 1 && fill == 2
    disp('The most optimal angle is 43 degrees. Angle_Optimization.m');
    angle = 43;
    inv = Solar_Edge_4;
    roof_area = roof_width*2*roof_height*cos(roof_angle*pi/180);
    irr = south_face(angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    surface_area = minimum_area(eff,irr,load,solar_panel);
    nb_panels = floor(surface_area/solar_panel.area);
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
        surface_area = nb_panels*solar_panel.area;
    end
    if surface_area > roof_area
        surface_area = roof_area;
        disp('The entire roof is used.')
    else
        disp('The used roof area is ');
        disp(surface_area);
    end
    
elseif roof == 1 && orientation == 2 && fill == 1
    disp('The most optimal angle is 35 degrees. Angle_Optimization.m')
    angle = 35;
    inv = Fronius_Symo;
    roof_area = roof_width*2*roof_height*cos(roof_angle*pi/180);
    irr = east_west(angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    nb_panels = floor(roof_area/solar_panel.area);
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
    end
    surface_area = nb_panels*solar_panel.area;
elseif roof == 1 && orientation == 2 && fill == 2
    disp('The most optimal angle is 35 degrees. Angle_Optimization.m')
    angle = 35;
    inv = Solar_Edge_3;
    roof_area = roof_width*2*roof_height*cos(roof_angle*pi/180);
    irr = east_west(angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    surface_area = minimum_area(eff,irr,load,solar_panel);
    nb_panels = floor(surface_area/solar_panel.area);
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
        surface_area = nb_panels*solar_panel.area;
    end    
    if surface_area > roof_area
        surface_area = roof_area;
        disp('The entire roof is used.')
    else
        disp('The used roof area is ');
        disp(surface_area);
    end
    
elseif roof == 2 && orientation == 1 && fill ==1
    irr = south_face(roof_angle,ray);
    inv = Fronius_Symo;
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    roof_area = roof_width*roof_height;
     nb_panels = floor(roof_area/solar_panel.area);
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
    end
    surface_area = nb_panels*solar_panel.area;
elseif roof == 2 && orientation == 1 && fill ==2
    irr = south_face(roof_angle,ray);
    inv = Solar_Edge_4;
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    roof_area = roof_width*roof_height;
    surface_area = minimum_area(eff,irr,load,solar_panel);
    nb_panels = floor(surface_area/solar_panel.area);
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
        surface_area = nb_panels*solar_panel.area;
    end
    if surface_area > roof_area
        surface_area = roof_area;
        disp('The entire roof is used.')
    else
        disp('The used roof area is ');
        disp(surface_area);
    end
    
elseif roof == 2 && orientation == 2 && fill ==1
    irr = east_west(roof_angle,ray);
    inv = Fronius_Symo;
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    roof_area = 2*roof_width*roof_height;
    nb_panels = floor(roof_area/solar_panel.area);
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
    end
    surface_area = nb_panels*solar_panel.area;
else
    irr = east_west(roof_angle,ray);
    inv = Solar_Edge_3;
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    roof_area = 2*roof_width*roof_height; %is dit oke?
    surface_area = minimum_area(eff,irr,load,solar_panel);
    nb_panels = floor(surface_area/solar_panel.area);
    while nb_panels*solar_panel.nominal_voltage/2 > inv.input_DC_voltage
        disp('The voltage is too high.');
        nb_panels = nb_panels-1;
        surface_area = nb_panels*solar_panel.area;
    end    
    if surface_area > roof_area
        surface_area = roof_area;
        disp('The entire roof is used.')
    end
    disp('The used roof area is ');
    disp(surface_area);
end



%%
%%%% efficiency calculation solar panel (needed for power flow) %%%%%
%momenteel al hierboven berekend

%% POWER FLOW CALCULATION

[pf,injectie,consumptie]= Power_Flow(eff,irr, load, surface_area, Solar_Edge_3 ); 

%% BATTERY FLOW
battery_capacity = 13.5; %in kwh

[pf_bat,injectie_bat,consumptie_bat, battery_charge] = battery_flow(eff ,Solar_Edge_3, irr,load, surface_area, battery_capacity, 0.97);

%% create plots
plot_len = 35040;
figure
subplot(2,2,1)
plot(pf_bat(1:plot_len*15));
title('pf bat')
subplot(2,2,2)
plot(battery_charge(1:plot_len*15));
title('battery charge')
subplot(2,2,3)
plot(irr(1:plot_len*15));
title('irr')
subplot(2,2,4)
plot(load(1:plot_len));
title('load')
%% ELECTRICITY COST CALCULATION
[cons_dag, cons_nacht, net_cons_dag, net_cons_nacht] = dag_nacht(pf);
[total_cost,capex,opex] = Tariffs(tariff,solar_panel,inv,cons_dag,cons_nacht, net_cons_dag, net_cons_nacht, nbpanels);


disp('Calculations done.');












