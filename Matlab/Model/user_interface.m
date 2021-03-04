%                        User interface                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ray = straal(); % kan je 1 keer runnen en dan scenario's vergelijken.
filename = 'Load_profile_final.xlsx';
load_15m = readtable(filename);
load = load_15m{:,2};

roof = input('Flat (1) or gable roof (2)?: '); 
if  isempty(roof) == 1
    return;
elseif (roof ~= 1) && (roof ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
end

roof_area = 60; % updaten met merijn
roof_angle = 30; %only used for gable roof update
surface_area = roof_area; %oppervlakte aan zonnepanelen, kan later nog variabel worden miss?

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


if roof == 1 && orientation == 1
    disp('The most optimal angle is 43 degrees. Angle_Optimization.m');
    angle = 43;
    irr = south_face(angle,surface_area,ray);
elseif roof == 1 && orientation == 2
    disp('The most optimal angle is 35 degrees. Angle_Optimization.m')
    angle = 35;
elseif roof == 2 && orientation == 1
    irr = south_face(roof_angle,surface_area,ray);
else
    irr = east_west(roof_angle,surface_area,ray);
end

disp('Thank you. Performing calculations...');


[pf,injectie,consumptie]=Power_Flow(LG_Neon_5,irr, load);


%Conversion to actual generated power (depends on efficiency solar panels);
%Pgen(:,1) = 10^(-3)*eta * irr(:,1); (conversion to kW)
%Compare Pgen with Pload -> net power consumption/generation?




disp('Calculations done.');












