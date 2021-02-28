%                        User interface                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [irr_sf,tot_sf]  = south_face(45,1);
% [irr_ew,tot_ew] = east_west(45,1);

orientation = input('In which direction are the PV panels installed? Possible answers: 1 (South), 2 (EW): ');
if  isempty(orientation) == 1
    return;
elseif (orientation ~= 1) && (orientation ~= 2)
    disp('That input is unvalid! Answer with "1" or "2" ');
end

angle = input('Under which angle are the PV panels installed? answer in degrees: ');
surface_area = input('how much surface area? [m^2]: ');
%possible addition: which tariff is used?
%possible addition: what is the efficiency of the solar panel?
disp('Thank you. Performing calculations...');

ray = straal();

%calculate received power per minute
if orientation == 1
    irr = south_face(angle,surface_area,ray);
else
    irr = east_west(angle,surface_area,ray);
end


%Conversion to actual generated power (depends on efficiency solar panels);
%Pgen(:,1) = 10^(-3)*eta * irr(:,1); (conversion to kW)
%Compare Pgen with Pload -> net power consumption/generation?




disp('Calculations done.');












