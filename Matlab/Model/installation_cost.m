function cost = installation_cost(nb_panels)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
data = [3 339; 6 569; 9 679; 12 779; 16 919; 20 999];
X = data(:,1);
Y = data(:,2);
mdl = fitlm(X,Y);
cost = predict(mdl,nb_panels);
end

