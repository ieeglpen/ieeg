function TTestHeadPlot(mat,pmask,Tmax,Tmin,colorMax,colorMin,pvalue,electrodeInfoFile,titleName,anatomicFile,nodeSpecStruct)

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

Smin = (mat < Tmin & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.
[i,j,s] = find(Smin);  % convert into pairs 
ParElecMin = [];
if length(i) > 0
    %arrow([x(i),y(i)],[x(j),y(j)],AS,'EdgeColor',color1,'FaceColor',color1,'Length',0,'BaseAngle',50,'width',AS)
    %armo un vector de ParElec de una de las condiciones
    ParElecMin = [i j];
end
 
Smax=(mat > Tmax & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.
[i,j,s] = find(Smax);  % convert into pairs 
ParElecMax = [];
if length(i) > 0
    %arrow([x(i),y(i)],[x(j),y(j)],AS,'EdgeColor',color2,'FaceColor',color2,'Length',0,'BaseAngle',50,'width',AS)
    %armo un vector de ParElec de una de las condiciones
    ParElecMax = [i j];
end

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

for h=1:L
    text(electrodes.x(h)+1,...
        electrodes.y(h)+1,...
        electrodes.z(h)+1,...
        electrodes.labels{h},'color','k');
end

%plot connections for TMax
for l = 1:size(ParElecMax,1)
    elec1 = ParElecMax(l,1);
    elec2 = ParElecMax(l,2);
    xValues = [electrodes.x(elec1) electrodes.x(elec2)];
    yValues = [electrodes.y(elec1) electrodes.y(elec2)];
    zValues = [electrodes.z(elec1) electrodes.z(elec2)];
    %line(xValues,yValues,zValues,'Color',colorMax,'LineWidth',2,'DisplayName',['Series #' j]); 
    line(xValues,yValues,zValues,'Color',colorMax,'LineWidth',2); 
end

%plot files for BrainNetViewer
threshold = Tmax;
%binarizedMatrixTMax = BinarizeMatrixByThreshold(mat, threshold);

binarizedMatrixTMax = mat;
weightedMatrixTMax = mat;

binarizedMatrixTMax(binarizedMatrixTMax < threshold) = 0;
binarizedMatrixTMax(binarizedMatrixTMax ~= 0) = 1;

weightedMatrixTMax = weightedMatrixTMax.*binarizedMatrixTMax;

%shortTitleName = [titleName '-umbral-' num2str(threshold)];
% channels = binarizedMatrixTMax;
% variableNameMat = [titleName 'Max.mat'];
% str2Eval = ['save ' variableNameMat  ' channels'];
% eval(str2Eval);

 signifMatrixMax = binarizedMatrixTMax.*pmask;
% signifMatrixMax2print = GetWeightedEdgeMatrixForBrainNetViewer(signifMatrixMax,pvalue);
% signifMatNameFile = [titleName 'Max'];
% PrintEdgeFile(signifMatNameFile,signifMatrixMax2print);

connectionMatrixMax = binarizedMatrixTMax;

%PrintNodeFile(electrodeInfoFile,anatomicFile,connectionMatrix,shortTitleName);
%PrintEdgeFile(shortTitleName,connectionMatrix);

%plot connections for TMin
for m = 1:size(ParElecMin,1)
    elec1 = ParElecMin(m,1);
    elec2 = ParElecMin(m,2);
    xValues = [electrodes.x(elec1) electrodes.x(elec2)];
    yValues = [electrodes.y(elec1) electrodes.y(elec2)];
    zValues = [electrodes.z(elec1) electrodes.z(elec2)];
    %line(xValues,yValues,zValues,'Color',colorMax,'LineWidth',2,'DisplayName',['Series #' j]); 
    line(xValues,yValues,zValues,'Color',colorMin,'LineWidth',2); 
end

%plot files for BrainNetViewer
threshold = Tmin;
%binarizedMatrixTMin = BinarizeMatrixByThreshold(mat, threshold);
binarizedMatrixTMin = mat;
weightedMatrixTMin = mat;
binarizedMatrixTMin(binarizedMatrixTMin > threshold) = 0;
binarizedMatrixTMin(binarizedMatrixTMin ~= 0) = 1;

weightedMatrixTMin = weightedMatrixTMin.*binarizedMatrixTMin;

%shortTitleName = [titleName '-umbral-' num2str(threshold)];
%channels = binarizedMatrixTMin;
%variableNameMat = [shortTitleName '.mat channels'];

% variableNameMat = [titleName 'Min.mat'];
% str2Eval = ['save ' variableNameMat  ' channels'];
% eval(str2Eval);


weightedMatrixT = weightedMatrixTMax + weightedMatrixTMin;
weightedMatrixT(isnan(weightedMatrixT)) = 0;

m = weightedMatrixT;
variableNameMat = [titleName 'Weighted.mat'];
str2Eval = ['save ' variableNameMat  ' m']
eval(str2Eval);
PrintEdgeFile([titleName '_weighted'],weightedMatrixT);

% signifMatrixMin = binarizedMatrixTMin.*pmask;
% signifMatrixMin2print = GetWeightedEdgeMatrixForBrainNetViewer(signifMatrixMin,pvalue);
% signifMatNameFile = [titleName 'Min'];
% PrintEdgeFile(signifMatNameFile,signifMatrixMin2print);
% 
% weightedSignifMatrix = signifMatrixMax2print + signifMatrixMin2print;
% signifMatNameFile = [titleName 'Min'];
% PrintEdgeFile(signifMatNameFile,signifMatrixMin2print);


%connectionMatrix = binarizedMatrixTMin;
connectionMatrixMin = binarizedMatrixTMin;
connectionMatrixMax = binarizedMatrixTMax*2;

connectionMatrix = connectionMatrixMax + connectionMatrixMin;
connectionMatrix(logical(eye(size(connectionMatrix)))) = 0;

PrintNodeFile(electrodeInfoFile,anatomicFile,connectionMatrix,titleName,nodeSpecStruct,'condition');
PrintEdgeFile(titleName,connectionMatrix);

%legend(h,values2Plot.conditionName);
%legend('Tmax','Tmin')

ftitleName = [titleName '.fig'];
saveas(gcf,ftitleName,'fig');
jtitleName = [titleName '.jpg'];
saveas(gcf,jtitleName,'jpg');