clear all
close all
clc

load 'resultPLVMaps_ACC_lowgamma.mat'
electrodes = importdata('Peirone_LocalizacionElectrodos.txt');

x = electrodes.data(:,1);
y = electrodes.data(:,2);
z = electrodes.data(:,3);

ch_label = electrodes.textdata;

plvMap = result;
threshold = 0.7;

plvMapMean = mean(plvMap,3);
timeWindow = GetColumnIndexOfTimeWindow(EjeX,0,500);
timeWindowsPLVMap  = plvMapMean(:,timeWindow(1):timeWindow(2));
timeWindowsMeanPLVMap = mean(timeWindowsPLVMap,2);

binarizedVector = BinarizeMatrixByThreshold(timeWindowsMeanPLVMap, threshold);

values2Plot = find(binarizedVector == 1);

%plot de todos los electrodos y de las conexiones con umbral mayor a...
%ver myHeadPlot.m

figure
%plot de localizacion de electrodos
scatter3(x,y,z,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
hold on;
xlabel('x - left to right'); ylabel('y - posterior to anterior');
zlabel('z - inferior to superior');
axis image

%plot labels
L=length(x);

for i=1:L
    text(x(i)+1,...
        y(i)+1,...
        z(i)+1,...
        ch_label{i},'color','k');
end

%plot connections
AS = 0.9;

for i = 1:length(values2Plot)
    elec1 = ParElec(values2Plot(i),1);
    elec2 = ParElec(values2Plot(i),2);
    xValues = [x(elec1) x(elec2)];
    yValues = [y(elec1) y(elec2)];
    zValues = [z(elec1) z(elec2)];
    line(xValues,yValues,zValues,'LineWidth',2);
end