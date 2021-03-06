function PlotIntracranealsConnectionsForConditions(electrodes,ParElec,values2Plot,titleName)

%INPUT:
%electrodes: structure with x,y,z,labels
%               x,y,z: cartesian coordinates of each electrode
%               labels: name of each electrode
%ParElec: combination of all electrode pair comparison
%values2Plot: structure with 3 variables
%                   * binarizedArray: Nx1 vector with the positions in ParElc of the electrode pair that have
%                                     to be connected
%                   * conditionName: condition name
%                   * color: plot color format
%titleName: title of figure 

h = figure;
h = gca;
%plot de localizacion de electrodos
scatter3(electrodes.x,electrodes.y,electrodes.z,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName','electrodes');
hold on;
xlabel('x - left to right'); ylabel('y - posterior to anterior');
zlabel('z - inferior to superior');
axis image

title(titleName)

%plot labels
L=length(electrodes.x);

for i=1:L
    text(electrodes.x(i)+1,...
        electrodes.y(i)+1,...
        electrodes.z(i)+1,...
        electrodes.labels{i},'color','k');
end

%legendValues{1} = 'electrodes';

%plot connections for each condition
for j = 1:size(values2Plot,2)
    values = values2Plot(j).binarizedArray;         
    %legendValues{j+1} = values2Plot(j).conditionName;
    for i = 1:length(values)
        elec1 = ParElec(values(i),1);
        elec2 = ParElec(values(i),2);
        xValues = [electrodes.x(elec1) electrodes.x(elec2)];
        yValues = [electrodes.y(elec1) electrodes.y(elec2)];
        zValues = [electrodes.z(elec1) electrodes.z(elec2)];
        if i == 1
            h(j) = line(xValues,yValues,zValues,'Color',values2Plot(j).color,'LineWidth',2);                
        else
            line(xValues,yValues,zValues,'Color',values2Plot(j).color,'LineWidth',2,'DisplayName',['Series #' j]);                
        end
    end
end
legend(h,values2Plot.conditionName);

ftitleName = [titleName '.fig'];
saveas(gcf,ftitleName,'fig');
jtitleName = [titleName '.jpg'];
saveas(gcf,jtitleName,'jpg');
%saveas(h,titleName,'fig')
%saveas(h,titleName,'jpg')