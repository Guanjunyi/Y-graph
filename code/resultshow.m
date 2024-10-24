function resultshow(data,CL)


PtSize = 2;

NC = length(unique(CL));
label_set = unique(CL);


[N,M] = size(data);

figure;
cmap = UiGetColormap(NC);

for i=1:NC
    l=label_set(i);
    if M~=3
        if l~=0
            scatter(data((CL==l),1),data((CL==l),2),PtSize+8,'o','filled','MarkerFaceColor',cmap(l,:),'MarkerEdgeColor',cmap(l,:));
        else
            scatter(data((CL==l),1),data((CL==l),2),PtSize+50,'x','MarkerEdgeColor','k');
        end
    else
        if l~=0
            scatter3(data((CL==l),1),data((CL==l),2),data((CL==l),3),PtSize+5,'o','filled','MarkerFaceColor',cmap(l,:),'MarkerEdgeColor',cmap(l,:));
        else
            scatter3(data((CL==l),1),data((CL==l),2),data((CL==l),3),PtSize+5,'x','filled','MarkerEdgeColor','k');
        end
    end
    hold on
end

axis off
title('Clustering result',FontSize=15);

function [cmap]=UiGetColormap(NC)

colormap hsv
cmap=colormap;
cmap=cmap(round(linspace(1,length(cmap),NC+1)),:);
cmap=cmap(1:end-1,:);

