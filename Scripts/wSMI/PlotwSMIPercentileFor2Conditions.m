function PlotwSMIPercentileFor2Conditions(condition1,condition2,tau,fileName,channelNr,path,newFileName,percentile,color1,color2,electrodeInfoFile,anatomicFile,nodeSpecStruct)

direc = path;

cond = {condition1,condition2};
C1 = [];C2 =[];

for c = 1:2
    fileout= fullfile(direc,'Results','SMI',[fileName,'_',cond{c},'_CSD.mat']);
    load(fileout); 
        
    wSMI4Tau = wSMI.Trials{tau};
    matrixSize = channelNr;
    tempResultMatrix = nan(matrixSize);
    
    for tr =1:size(wSMI4Tau,2)
        wSMI4TauByTrial = wSMI4Tau(:,tr);       
        n = 0;
        for i = 1:matrixSize 
            for j = (i+1):matrixSize;
                n = n + 1;
                tempResultMatrix(i,j) = wSMI4TauByTrial(n);
                tempResultMatrix(j,i) = wSMI4TauByTrial(n);
            end
        end
        if c == 1
            C1 = cat(3,C1,tempResultMatrix);
        else
            C2 = cat(3,C2,tempResultMatrix);
        end
    end
end

M.C1 = C1;
M.C2 = C2;

meanC1 = mean(M.C1,3);
meanC2 = mean(M.C2,3);

%plot histogram
figure, hist(meanC1(:),100);
box off
name = [newFileName '_' condition1 '_histogram'];
title(name)
saveas(gcf,name,'png');
saveas(gcf,name,'fig');

figure, hist(meanC2(:),100);
box off
name = [newFileName '_' condition2 '_histogram'];
title(name)
saveas(gcf,name,'png');
saveas(gcf,name,'fig');

%largest values
rmeanC1 = reshape(meanC1,1,size(meanC1,1)*size(meanC1,2));
rmeanC2 = reshape(meanC2,1,size(meanC2,1)*size(meanC2,2));

percentileC1 = prctile(rmeanC1,percentile);
percentileC2 = prctile(rmeanC2,percentile);

%PLOT CONNECTIONS FOR CONDITION1
%import data of .txt - loads textdata (N x 1) with labels and coordinate data (N x 3)
elecs = importdata(electrodeInfoFile);

%create electrodes structure
x = elecs.data(:,1);
y = elecs.data(:,2);
z = elecs.data(:,3);

ch_label = elecs.textdata(:,2);

electrodes.x = x;
electrodes.y = y;
electrodes.z = z;
electrodes.labels = ch_label;

channelNr = size(x,1);

TRIAN=triu(~eye(channelNr));

pC1 = meanC1;
pC1(pC1 <= percentileC1) = 0;

SCond1 = (pC1 > percentileC1 & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.
[i,j,s] = find(SCond1);  % convert into pairs 
ParElecCond1 = [];
if length(i) > 0
    %arrow([x(i),y(i)],[x(j),y(j)],AS,'EdgeColor',color1,'FaceColor',color1,'Length',0,'BaseAngle',50,'width',AS)
    %armo un vector de ParElec de una de las condiciones
    ParElecCond1 = [i j];
end

h = figure;
h = gca;
%plot de localizacion de electrodos
scatter3(electrodes.x,electrodes.y,electrodes.z,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName','electrodes');
hold on;
xlabel('x - left to right'); ylabel('y - posterior to anterior');
zlabel('z - inferior to superior');
axis image
name = [newFileName '_' condition1];
title(name)

%plot labels
L=length(electrodes.x);

for h=1:L
    text(electrodes.x(h)+1,...
        electrodes.y(h)+1,...
        electrodes.z(h)+1,...
        electrodes.labels{h},'color','k');
end

%plot connections for Condition1
for l = 1:size(ParElecCond1,1)
    elec1 = ParElecCond1(l,1);
    elec2 = ParElecCond1(l,2);
    xValues = [electrodes.x(elec1) electrodes.x(elec2)];
    yValues = [electrodes.y(elec1) electrodes.y(elec2)];
    zValues = [electrodes.z(elec1) electrodes.z(elec2)];
    %line(xValues,yValues,zValues,'Color',colorMax,'LineWidth',2,'DisplayName',['Series #' j]); 
    line(xValues,yValues,zValues,'Color',color1,'LineWidth',2); 
end
ftitleName = [name '.fig'];
saveas(gcf,ftitleName,'fig');
jtitleName = [name '.jpg'];
saveas(gcf,jtitleName,'jpg');

%PLOT CONNECTIONS FOR CONDITION2
%import data of .txt - loads textdata (N x 1) with labels and coordinate data (N x 3)
pC2 = meanC2;
pC2(pC2 <= percentileC2) = 0;

SCond2=(pC2 > percentileC2 & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.
[i,j,s] = find(SCond2);  % convert into pairs 
ParElecCond2 = [];
if length(i) > 0
    %arrow([x(i),y(i)],[x(j),y(j)],AS,'EdgeColor',color2,'FaceColor',color2,'Length',0,'BaseAngle',50,'width',AS)
    %armo un vector de ParElec de una de las condiciones
    ParElecCond2 = [i j];
end

h = figure;
h = gca;
%plot de localizacion de electrodos
scatter3(electrodes.x,electrodes.y,electrodes.z,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'DisplayName','electrodes');
hold on;
xlabel('x - left to right'); ylabel('y - posterior to anterior');
zlabel('z - inferior to superior');
axis image

name = [newFileName '_' condition2];
title(name)

%plot labels
L=length(electrodes.x);

for h=1:L
    text(electrodes.x(h)+1,...
        electrodes.y(h)+1,...
        electrodes.z(h)+1,...
        electrodes.labels{h},'color','k');
end

%plot connections for Condition2
for l = 1:size(ParElecCond2,1)
    elec1 = ParElecCond2(l,1);
    elec2 = ParElecCond2(l,2);
    xValues = [electrodes.x(elec1) electrodes.x(elec2)];
    yValues = [electrodes.y(elec1) electrodes.y(elec2)];
    zValues = [electrodes.z(elec1) electrodes.z(elec2)];
    %line(xValues,yValues,zValues,'Color',colorMax,'LineWidth',2,'DisplayName',['Series #' j]); 
    line(xValues,yValues,zValues,'Color',color2,'LineWidth',2); 
end
ftitleName = [name '.fig'];
saveas(gcf,ftitleName,'fig');
jtitleName = [name '.jpg'];
saveas(gcf,jtitleName,'jpg');

%Print Files For Brain Net
pC1(isnan(pC1)) = 0;
pC2(isnan(pC2)) = 0;
pC2 = pC2 * (-1);

%plot files for BrainNetViewer
PrintEdgeFile([newFileName '_' condition1 '_weighted'],pC1);
PrintEdgeFile([newFileName '_' condition2 '_weighted'],pC2);

%PrintNodeFile(electrodeInfoFile,anatomicFile,pC1,newFileName,nodeSpecStruct,'condition');

