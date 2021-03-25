%                        User interface                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Which technical components are used? %%%%%%%%%%%%%%%%%
%these are data classes (import possibly necessary)

solar_name = ["sunpower_maxeon_3.mat", "Panasonic.mat", "LG_Neon_5.mat", "JA_SOLAR.mat", "Canadian_solar.mat"];
for i = 1:size(solar_name, 2) 
    load(fullfile(pwd, "Data\Solar module data\",solar_name(i)));
end

inverter = ''; % two cases: directly from solar panel to the grid or from battery to grid
DC_converter = ''; % used for battery
battery = '';
%additional safety equipment?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% RUN ONE TIME TO SAVE TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('ray') == 0
    ray = straal(); % kan je 1 keer runnen en dan scenario's vergelijken.
end

if exist('Load_profile') == 0
    load(fullfile(pwd, "Data\Load_profile.mat")); % kan je 1 keer runnen en dan scenario's vergelijken.
    load = Loadprofilefinal{:,2};
end
% filename = 'Load_profile_final.xlsx';
% load_15m = readtable(filename);
% load = load_15m{:,2};

% USEFULL DECLARATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

roof_area = 15; % updaten met merijn
roof_angle = 30; %only used for gable roof update
surface_area = roof_area; %oppervlakte aan zonnepanelen, kan later nog variabel worden miss?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% DEFINE USER INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

roof = input('Flat (1) or gable roof (2)?: '); 
if  isempty(roof) == 1
    return;
elseif (roof ~= 1) && (roof ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
end

orientation = input('In which direction are the PV panels installed? Possible answers: 1 (South), 2 (EW): ');
if  isempty(orientation) == 1
    return;
elseif (orientation ~= 1) && (orientation ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
end

tariff = input('Which tariff is used? Prosumer (1) or self_consuming (2)?: ');
if  isempty(tariff) == 1
    return;
elseif (tariff ~= 1) && (tariff ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
end

bat = input('Is a battery included? YES (1) or NO (2)?: ');
if  isempty(bat) == 1
    return;
elseif (bat ~= 1) && (bat ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
end

disp('Thank you. Performing calculations...');
%%
%%%%%%%%%%% Calculate total received power (total irradiance) %%%%%%%%%

if roof == 1 && orientation == 1
    disp('The most optimal angle is 43 degrees. Angle_Optimization.m');
    angle = 43;
    irr = south_face(angle,ray);
elseif roof == 1 && orientation == 2
    disp('The most optimal angle is 35 degrees. Angle_Optimization.m')
    angle = 35;
    irr = east_west(angle,ray);
elseif roof == 2 && orientation == 1
    irr = south_face(roof_angle,ray);
else
    irr = east_west(roof_angle,ray);
end



%%
%%%% efficiency calculation solar panel (needed for power flow) %%%%%
[irr_monthly] = monthly_irr(irr); %convert to mean monthly irradiances

[eff,Tz] = Efficiency(JA_SOLAR,irr_monthly); %adapt efficiencies to monthly temperatures

%%

[pf,injectie,consumptie]= Power_Flow(eff,irr, load, surface_area); 

%[Efficiency,Tz] = Efficiency(LG_Neon_5,irr_monthly,load, solar_area);

%Conversion to actual generated power (depends on efficiency solar panels);
%Pgen(:,1) = 10^(-3)*eta * irr(:,1); (conversion to kW)
%Compare Pgen with Pload -> net power consumption/generation?




%%

disp('Calculations done.');











