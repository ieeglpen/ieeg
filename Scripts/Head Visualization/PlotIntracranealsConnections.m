function PlotIntracranealsConnections(electrodes,ParElec,values2Plot,titleName)

%INPUT:
%electrodes: structure with x,y,z,labels
%               x,y,z: cartesian coordinates of each electrode
%               labels: name of each electrode
%ParElec: combination of all electrode pair comparison
%values2Plot: Nx1 vector with the positions in ParElc of the electrode pair that have
%to be connected
%titleName: title of figure 

h = figure;
%plot de localizacion de electrodos
scatter3(electrodes.x,electrodes.y,electrodes.z,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
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

fileID = fopen([titleName '_Connections.txt'],'w');
formatSpec = '%s %s %d %d\r\n';

%plot connections
for i = 1:length(values2Plot)
    elec1 = ParElec(values2Plot(i),1);
    elec2 = ParElec(values2Plot(i),2);
    
    %text2Print = [num2str(i) ' ' electrodes.labels{i} ' ' num2str(electrodes.coordinates(i,1)) ' ' num2str(electrodes.coordinates(i,2)) ' ' num2str(electrodes.coordinates(i,3))];
    %fprintf(fileID,formatSpec,text2Print);
    fprintf(fileID,formatSpec,electrodes.labels{elec1},electrodes.labels{elec2},elec1,elec2);
    
    xValues = [electrodes.x(elec1) electrodes.x(elec2)];
    yValues = [electrodes.y(elec1) electrodes.y(elec2)];
    zValues = [electrodes.z(elec1) electrodes.z(elec2)];
    line(xValues,yValues,zValues,'Color','b','LineWidth',2);
end

ftitleName = [pwd '\' titleName '.fig'];
saveas(gcf,ftitleName,'fig');
jtitleName = [pwd '\' titleName '.jpg'];
saveas(gcf,jtitleName,'jpg');
%saveas(h,titleName,'fig')
%saveas(h,titleName,'jpg')