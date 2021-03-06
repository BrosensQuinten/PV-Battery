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
solar_panel = sunpower_maxeon_3;



% load in inverters into workspace
if exist('inverter_names') == 0
    inverter_names = ["Solar_Edge_4.mat", "Solar_Edge_3.mat", "Fronius_Symo.mat"];
    for i = 1:size(inverter_names, 2) 
        load(fullfile(pwd, "Data\Inverters\",inverter_names(i)));
    end
end % two cases: directly from solar panel to the grid or from battery to grid

% load in batteries into workspace
if exist('battery_names') == 0
    battery_names = ["Tesla_powerwall.mat", "LG_RESU10.mat"];
    for i = 1:size(battery_names, 2) 
        load(fullfile(pwd, "Data\Batteries\",battery_names(i)));
    end
end
%additional safety equipment?
battery = Tesla_powerwall;
disc_rate = 0.02;
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
roof_angle = 45; %mijn dak is 45 graden aan de ene kant en 24 aan de andere 
voltage_too_high = 0; 
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

%fill = input('Is the roof entirely filled with panels (1) or just enough to compensate the load (2)?: ');
%if isempty(fill) == 1
%    return;
%elseif (fill ~= 1) && (fill ~= 2)
%    disp('That input is unvalid! Answer with "1" or "2" ');
%    return
%end
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

%% calculation roof area 
if roof == 1 
    max_area = roof_width*2*roof_height*cos(roof_angle*pi/180);
else
    if orientation == 1
        max_area = roof_width*roof_height;
    else
        max_area = 2*roof_width*roof_height;
    end
end
        
%% OPTIMIZATION PROBLEM
%%%%%%%%%%% Calculate total received power (total irradiance) %%%%%%%%%

final_NPV = -10^9;
best_NPV = -10^9;
definitive_NPV = -10^9;
solar_modules = [sunpower_maxeon_3, Panasonic, LG_Neon_5, JA_SOLAR, Canadian_solar];
invertor_list = [Fronius_Symo, Solar_Edge_3, Solar_Edge_4];

%for angle = 25:35
for invertor_index = 1:3
   inv = invertor_list(invertor_index);


%   solar_panel = solar_modules(solar_index);
%    solar_panel = Canadian_solar;

% for solar_index = 2:5
 % solar_panel = solar_modules(solar_index);
   solar_panel = Canadian_solar;

    nb_panels = 1;
%     if orientation == 1
    max_panels = floor(2*inv.input_DC_voltage/solar_panel.nominal_voltage);
%     else
%         max_panels = max_panels *2;
%     end
while nb_panels < max_panels+1

    %%
    %%%%%%%%%%% Calculate total received power (total irradiance) %%%%%%%%%



    if roof == 1 && orientation == 1 
        
        angle = 53;
        if tariff == 2 && bat == 1
            angle = 51;
        elseif tariff == 2 && bat == 2
            angle = 31;
        end
        surface_area = nb_panels*solar_panel.area;
        irr = south_face(angle,ray);
        [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
        [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures


    elseif roof == 1 && orientation == 2 
       
        angle = 30;
        if tariff == 2 && bat ==1
            angle = 29;
        end
        
        surface_area = nb_panels*solar_panel.area;
        irr = east_west(angle,ray);
        [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
        [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
        


    elseif roof == 2 && orientation == 1 
        
        surface_area = nb_panels*solar_panel.area;
        irr = south_face(roof_angle,ray);
        [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
        [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
  


    elseif roof == 2 && orientation == 2
        
        surface_area = nb_panels*solar_panel.area;
        irr = east_west(roof_angle,ray);
        [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
        [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures


    end




    %%
    %%%% efficiency calculation solar panel (needed for power flow) %%%%%
    %momenteel al hierboven berekend
    %% Reference Cost
    [ref_gen_pf,ref_pf,ref_injectie,ref_consumptie]=Power_Flow(eff,irr,load,0,inv);
    [ref_cons_dag, ref_cons_nacht, ref_net_cons_dag, ref_net_cons_nacht] = dag_nacht(ref_pf);
    [ref_total_cost,ref_capex,ref_opex] = Tariffs(2,solar_panel,inv,ref_cons_dag,ref_cons_nacht, ref_net_cons_dag, ref_net_cons_nacht, nb_panels,battery,bat);

    %% POWER FLOW CALCULATION
    if bat == 2
        [gen_pf,pf,injectie,consumptie]= Power_Flow(eff,irr, load, surface_area, inv); 
    end
    %% BATTERY FLOW
    if bat == 1
        [gen_pf, pf_bat,pf_kwhbat,injectie_bat,consumptie_bat, battery_charge] = battery_flow(eff ,inv, irr,load, surface_area, Tesla_powerwall);
    end
    %% ELECTRICITY COST CALCULATION
    if bat == 1
        [cons_dag, cons_nacht, net_cons_dag, net_cons_nacht] = dag_nacht(pf_bat);
    else
        [cons_dag, cons_nacht, net_cons_dag, net_cons_nacht] = dag_nacht(pf);
    end

    [total_cost,capex,opex] = Tariffs(tariff,solar_panel,inv,cons_dag,cons_nacht, net_cons_dag, net_cons_nacht, nb_panels,battery,bat);
     NPV = Net_present_value(disc_rate,capex,opex,ref_opex,solar_panel, inv, battery,bat);
     if NPV > final_NPV
            final_NPV = NPV;
            final_capex = capex;
            final_opex = opex;
            final_nb_panels = nb_panels;
            final_inv = inv;
     end

    nb_panels = nb_panels+1;
    roof_area = nb_panels*solar_panel.area;
    if roof_area > max_area
        roof_area = (nb_panels-1)*solar_panel.area;
        break
    end
end
if final_NPV > definitive_NPV
    definitive_NPV = final_NPV;
    definitive_capex = final_capex;
    definitive_opex = final_opex;
    definitive_nb_panels = final_nb_panels;
    definitive_solar_panel = solar_panel;
    definitive_inv = final_inv;
end
 end
if definitive_NPV > best_NPV
    best_NPV = definitive_NPV;
    best_capex = definitive_capex;
    best_opex = definitive_opex;
    best_nb_panels = definitive_nb_panels;
    best_solar_panel = definitive_solar_panel;
    best_inv = definitive_inv;
    if roof == 1
        if orientation == 1
            best_angle_south = angle;
        else
            best_angle_ew = angle;
        end
    end
end
%end
%% RUNS Once: TO SHOW DIFFERENT RESULTS AFTER OPTIMIZATION
nb_panels = best_nb_panels;
solar_panel = definitive_solar_panel;
inv = best_inv;
disp('The final roof area is');
disp(roof_area);
disp('The best solar panel is');
solar_panel = best_solar_panel;
disp(solar_panel);
disp('The used converter is');
disp(inv);

 %%
    %%%%%%%%%%% Calculate total received power (total irradiance) %%%%%%%%%



if roof == 1 && orientation == 1 
    
    angle = best_angle_south;
    surface_area = nb_panels*solar_panel.area;
    irr = south_face(angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures

elseif roof == 1 && orientation == 2 
    angle = best_angle_ew;
    surface_area = nb_panels*solar_panel.area;
    irr = east_west(angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
  
elseif roof == 2 && orientation == 1 
    
    surface_area = nb_panels*solar_panel.area;
    irr = south_face(roof_angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures



elseif roof == 2 && orientation == 2 
    irr = east_west(roof_angle,ray);
    [irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances
    [eff,Tz] = Efficiency(solar_panel,irr_monthly); %adapt efficiencies to monthly temperatures
    surface_area = nb_panels*solar_panel.area;
end




%%
%%%% efficiency calculation solar panel (needed for power flow) %%%%%
%momenteel al hierboven berekend

%% Reference Cost
[ref_gen_pf,ref_pf,ref_injectie,ref_consumptie]=Power_Flow(eff,irr,load,0,inv);
[ref_cons_dag, ref_cons_nacht, ref_net_cons_dag, ref_net_cons_nacht] = dag_nacht(ref_pf);
[ref_total_cost,ref_capex,ref_opex] = Tariffs(2,solar_panel,inv,ref_cons_dag,ref_cons_nacht, ref_net_cons_dag, ref_net_cons_nacht, nb_panels,battery,bat);

%% POWER FLOW CALCULATION
if bat == 2
    [gen_pf,pf,injectie,consumptie]= Power_Flow(eff,irr, load, surface_area, inv); 
end
%% BATTERY FLOW

if bat == 1
   
    [gen_pf, pf_bat,pf_kwhbat,injectie_bat,consumptie_bat, battery_charge] = battery_flow(eff ,inv, irr,load, surface_area, battery);


%% create plots
    plot_len = 10000;
    figure
    subplot(3,2,1)
    plot(pf_bat(1:plot_len*15));
    title('pf bat')
    subplot(3,2,2)
    plot(battery_charge(1:plot_len*15));
    title('battery charge')
    subplot(3,2,3)
    plot(irr(1:plot_len*15));
    title('irradiance')
    subplot(3,2,4)
    plot(gen_pf(1:plot_len*15));
    title('solar power')
    subplot(3,2,5)
    plot(load(1:plot_len));
    title('load')
end
%% ELECTRICITY COST CALCULATION
if bat == 1
    [cons_dag, cons_nacht, net_cons_dag, net_cons_nacht] = dag_nacht(pf_bat);
else
    [cons_dag, cons_nacht, net_cons_dag, net_cons_nacht] = dag_nacht(pf);
end

[total_cost,capex,opex] = Tariffs(tariff,solar_panel,inv,cons_dag,cons_nacht, net_cons_dag, net_cons_nacht, nb_panels,battery,bat);
%% Payback Time and NPV
payback_time = Payback_time(capex,opex,ref_opex,solar_panel, inv,battery,bat);

NPV = Net_present_value(disc_rate,capex,opex,ref_opex,solar_panel, inv, battery,bat);
disp('Calculations done.');












