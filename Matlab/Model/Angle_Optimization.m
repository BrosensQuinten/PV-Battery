% This script calculates the optimal angle for your PV panel if you have a
% flat roof for two scenarios (south and east-west orientation)
% assumption -> between 25 - 35 degrees

ray = straal();

angle = 10;
opt_angle_S = 0;
opt_angle_WE = 0;

highest_energy_S = 0;
highest_energy_WE = 0;

for i=1:60
irr_S = south_face(angle,ray);
irr_WE = east_west(angle,ray);

int_S = sum(irr_S, 'all'); int_WE = sum(irr_WE, 'all');

if int_S > highest_energy_S
   highest_energy_S = int_S;
   
   opt_angle_S = angle;
end
if int_WE > highest_energy_WE
   highest_energy_WE = int_WE; 
   opt_angle_WE = angle;
end
angle = angle + 1;
end

