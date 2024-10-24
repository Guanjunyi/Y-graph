% Please kindly cite the paper Junyi Guan; Sheng LI; Xiongxiong He; Jiajia Chen; Yangyang Zhao; Yuxuan Zhang
% "Y-graph: A max-ascent-angle graph for detecting clusters" 
% IEEE Transactions on Knowledge and Data Engineering,2024
% The code was written by Junyi Guan in 2024.

clear all;
close all;
clc;
load("data/Flame.mat"); 
data_answer = Flame;
data = data_answer(:,1:end-1);
answer = data_answer(:,end);
n = size(data,1);

%% parameters
NC = length(unique(answer)); %number of clusters
k = round(sqrt(n)/2); % number of neighbors

%% clustering
[Y_SIM, CL] = Ncut_Y(data,k,NC);

%% show results
G = graph(Y_SIM, 'upper', 'omitself');
n_edges = G.numedges;
% display Y-graph 
figure;
plot(G, 'XData', data(:,1), 'YData', data(:,2), 'NodeColor', [128 128 128]./255, 'MarkerSize', 1, 'LineWidth', 1, 'EdgeColor', [120 178 48]./255,'NodeLabel', {});
axis off
title('Y-graph', FontSize=15);
% display Clustering result
resultshow(data,CL);
