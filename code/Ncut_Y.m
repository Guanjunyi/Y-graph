function [Y_SIM,CL] = Ncut_Y(data,k,NC)
close all
tic
[Y_SIM] = Ygraph(data,k);
graphbuildingtime = toc;
W = sparse(Y_SIM);

tic
[NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(W,NC);
solvertime = toc;
tic
for i=1:NC
    id = find(NcutDiscrete(:,i));
CL(id) = i;
end
time3 = toc;
runtime = graphbuildingtime+solvertime+time3;
edges=length(find(Y_SIM(:)~=0))/2;

G = graph(Y_SIM, 'upper', 'omitself');
n_edges = G.numedges;


result=struct;

%% clustering result

result.solvertime = solvertime;
result.graphbuildingtime = graphbuildingtime;
result.runtime = runtime;

result


end