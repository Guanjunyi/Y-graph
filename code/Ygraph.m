% Please kindly cite the paper Junyi Guan; Sheng LI; Xiongxiong He; Jiajia Chen; Yangyang Zhao; Yuxuan Zhang
% "Y-graph: A max-ascent-angle graph for detecting clusters" 
% IEEE Transactions on Knowledge and Data Engineering,2024
% The code was written by Junyi Guan in 2024.

function [Y_SIM] = Ygraph(data,k)
lambda = 1;
%% deduplicate data
data_x = unique(data,'rows');
if size(data_x,1) ~= size(data,1)
    data = data_x;
end
%%
%% normalization
data=(data-min(data))./(max(data)-min(data));
data(isnan(data))=0;
%% k
    k_rho = 2*k;
%% fast search of KNN matrix based on kd-tree (when dimension is not large than 10)
[n,d]  = size(data);
%%
if d<=10
    [knn,knn_dist] = knnsearch(data,data,'k',max(k,k_rho));
else
    dist = squareform(pdist(data));
    [knn_dist,knn] = sort(dist,2);
end
%% seting of parameter k_b for our border link detection
k_b = round(2*floor(log(n)));
dc = mean(knn_dist(:,k_b));
rho = k_rho*sum(knn_dist(:,2:k_rho).^1,2).^-1;
rho = (rho-min(rho))./(max(rho)-min(rho))+1;

%% identify density peaks and calculate center-representativeness
ispeak = ones(n,1); 
[~,OrdRho]=sort(rho,'descend');


NPN = (1:n);
for i=1:n
        neighs=knn(OrdRho(i),2:k);
        rho_condition = rho(OrdRho(i))<rho(neighs);
        distance_condition = knn_dist(i,2:k)'<=2*dc;
        all_conditions = rho_condition & distance_condition;
        [max_value, max_index] = max(all_conditions);
        if max_value ~= 0
            NPN(OrdRho(i))=neighs(max_index(1));%% NPN:neigbor-based parent node, i.e., nearest higher density point within the KNN area.
            ispeak(OrdRho(i)) = 0;
        end      
end

pk = find(ispeak==1);%% find density peaks (i.e., sub-cluster centers)
n_pk = length(pk);%% the number of density peaks

%% generate sub-clsuters
sl=-1*ones(n,1); %% sl: sub-labels of points.
sl(pk) = (1:n_pk); %% give unique sub-labels to density peaks.
for i=1:n
    if (sl(OrdRho(i))==-1)
        sl(OrdRho(i))=sl(NPN(OrdRho(i)));%% inherit sub-labels from NPN
    end
end

Ords = (1:n);
Y_SIM = sparse(n,n); %similar matrix of Y-graph

YPN = (1:n); %% YPN: the other parent node to obtain the max-ascent-angle
for i = 1:n
    host = NPN(i);
        neighs=knn(i,2:k);
        distance_condition = knn_dist(i,2:k)'<=2*dc;
        rho_condition = rho(i)<rho(neighs);
        nei_condition = any(knn(neighs,2:k) == i, 2);
        all_conditions = distance_condition & rho_condition & nei_condition;
        valid_neighs = neighs(all_conditions==true);         
        OA = data(host,:)-data(i,:);
        OB = data(valid_neighs,:)-data(i,:);
        dot_OA_OB = sum(OA.*OB,2);
        AOB = sign(dot_OA_OB).*dot_OA_OB.^2./(sum(OA.*OA,2)*sum(OB.*OB,2));

        if ~isempty(AOB) & max(abs(OA))~=0
            [~, min_index] = min(AOB);
            YPN(i) = valid_neighs(min_index(1));
        end
              
end

%% NPN
t_npn = knn(NPN,1:k);
t_pts = knn((1:n),1:k);
rho_sum_npn = sum(rho(t_npn),2);

rho_sum_pts = sum(rho(t_pts),2);
p_npn = rho(t_npn)./rho_sum_npn;
p_pts = rho(t_pts)./rho_sum_pts;
     
KLsum_npn_1 = sum(p_pts.*log(p_pts./p_npn),2);
KLsum_npn_2 = sum(p_npn.*log(p_npn./p_pts),2);
PP_npn = (KLsum_npn_1+KLsum_npn_2)./2;
PP_npn_e = exp(-PP_npn*lambda); 

NPN_1 = Ords-NPN;
index_npn = find(NPN_1~=0);


%% YPN 
y_ypn = knn(YPN,1:k);
rho_sum_ypn = sum(rho(y_ypn),2);
p_ypn = rho(y_ypn)./rho_sum_ypn;

KLsum_ypn_1 = sum(p_pts.*log(p_pts./p_ypn),2);
KLsum_ypn_2 = sum(p_ypn.*log(p_ypn./p_pts),2);
PP_ypn = (KLsum_ypn_1+KLsum_ypn_2)./2;
PP_ypn_e = exp(-PP_ypn*lambda);

TPN_1 = Ords-YPN;
index_ypn = find(TPN_1~=0);

indices_npn_ypn = sub2ind(size(Y_SIM), [Ords(index_npn) Ords(index_ypn)], [NPN(index_npn) YPN(index_ypn)]);
Y_SIM(indices_npn_ypn) = PP_ypn_e([index_npn index_ypn]);


Y_SIM = Y_SIM + Y_SIM';









