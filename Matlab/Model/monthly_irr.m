function [irr_monthly] = monthly_irr(irr)
%this function calculates the average irradiance per month
%this code averages the irradiance over each of the months.
% month_indices = [1 2977 5666 8641 11521 14497 17377 20353 23329 26209 29185 32065 35041]; %indices in load/irr matrix of the start of each month
month_indices = [1 44641 84961 129541 172741 217381 260581 305221 349861 393061 437761 480961 525601];
irr_monthly = zeros(1,1);


for i = 1:size(month_indices,2)-1
    irr_monthly = vertcat(irr_monthly, mean(nonzeros(irr(month_indices(i): month_indices(i+1)-1))));
end
irr_monthly(1,:) = [];

end

