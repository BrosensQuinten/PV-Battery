function [cons_dag, cons_nacht, net_cons_dag, net_cons_nacht] = dag_nacht(pf)
reshaped_pf = reshape(pf, 60*24, []);
pf_dag = reshaped_pf/60;
pf_nacht = reshaped_pf/60;



for i = 1:420
    pf_dag(i,:) = 0;
end
for i = 421:1320
    pf_nacht(i,:)=0;
end
for i = 1321:1440
    pf_dag(i,:) = 0;
end
for i = 1:52
    pf_dag(:,6+(i-1)*7) = 0;
    pf_dag(:,7+(i-1)*7) = 0;
    pf_nacht(:,6+(i-1)*7) = reshaped_pf(:,6+(i-1)*7)/60;
    pf_nacht(:,7+(i-1)*7) = reshaped_pf(:,7+(i-1)*7)/60;
end
% cons_list_dag = zeros(365,1);
% cons_list_nacht = zeros(365,1);
% for i = 1:365
%     cons_list_dag(i,1) = sum(pf_dag(:,i));
%     cons_list_nacht(i,1) = sum(pf_nacht(:,i));
% end
% cons_dag = -sum(cons_list_dag(:,1));
% cons_nacht = -sum(cons_list_nacht(:,1));

net_cons_dag = -sum(sum(pf_dag));
net_cons_nacht = -sum(sum(pf_nacht));

%now for gross consumption tariff: not with net meter
pf_dag(pf_dag>0)=0;
pf_nacht(pf_nacht>0)=0;

cons_dag = -sum(sum(pf_dag));
cons_nacht = -sum(sum(pf_nacht));
end

