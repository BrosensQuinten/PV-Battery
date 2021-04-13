function [outputArg1,outputArg2] = Reference_cost(load)
reshaped_load = reshape(load,4*24, []);
load_dag = reshaped_load/4;
load_nacht = reshaped_load/4;



for i = 1:28
    load_dag(i,:) = 0;
end
for i = 29:88
    load_nacht(i,:)=0;
end
for i = 89:96
    load_dag(i,:) = 0;
end
for i = 1:52
    load_dag(:,6+(i-1)*7) = 0;
    load_dag(:,7+(i-1)*7) = 0;
    load_nacht(:,6+(i-1)*7) = reshaped_load(:,6+(i-1)*7);
    load_nacht(:,7+(i-1)*7) = reshaped_load(:,7+(i-1)*7);
end
ref_cons_dag = sum(sum(load_dag));
ref_cons_nacht = sum(sum(load_nacht));

%energy supplier cost
%zelfde dag/nacht tarief als in tarrifs
ES_fixed_cost = 47.72; 
ES_day = 0.085375 ref_cons_dag;
ES_night = 0.067275 * ref_cons_nacht;
ES_tot_cost = ES_fixed_cost + ES_day + ES_night;

%TSO cost (2020)
tot_con = cons_dag + cons_nacht;
TSO_withBTW =  0.0171844*1.21; %EUR/kwh with BTW
TSO_noBTW = 0.00329; %EUR/kwh
TSO_total = (TSO_withBTW + TSO_noBTW)*tot_con;


end

