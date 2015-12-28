function GetPLVMapsForIntAndAcc(ROIInfo,EEG)

close all
clc

%cd ('C:\Users\Eugenia\Documents\INECO\GIT_INECO\Synchrony\4_Synchrony')
%cd('G:\INECO\GIT_INECO\Synchrony\4_Synchrony')

%load('Paciente4_EFP_subRois.mat');
%load('newDataEpoched.mat');
load('epochedData.mat');
load('EmpathyForPain_P8_Electrode.mat')

%datos fijos
Trange = [-500 1500];
WinSig = 256;
BinFreq = 1;
Step = 20;
%path2files = 'C:\Users\Eugenia\Documents\INECO\GIT_INECO\Synchrony\4_Synchrony';
%path2files = 'G:\INECO\GIT_INECO\Synchrony\4_Synchrony';
path2files = '';
Frange = [1:150];
%frecTitleName = '34to44';
threshold = -1; 
Fs = 1024;

data2process = epochs.acc;
titlePrefix = 'PLV Map - ACC';
Fstep = 1;
[SynchronyMap_ACC] = GetSynchronyMapForPairOfRois(ROIInfo,path2files, EEG, data2process, titlePrefix, Fs,Frange, Fstep,Trange, WinSig, BinFreq,Step);

data2process = epochs.int;
titlePrefix = 'PLV Map -INT';
Fstep = 1;
[SynchronyMap_INT] = GetSynchronyMapForPairOfRois(ROIInfo,path2files, EEG, data2process, titlePrefix, Fs,Frange, Fstep,Trange, WinSig, BinFreq,Step);

accMap = SynchronyMap_ACC.PLV;
intMap = SynchronyMap_INT.PLV;

diffMap = intMap - accMap;
titleName = ['DIFF - ' SynchronyMap_ACC.ROI1 '-' SynchronyMap_ACC.ROI2];

EjeX = SynchronyMap_ACC.EjeX;
EjeY = SynchronyMap_ACC.EjeY;

CompletePLV_ACC = SynchronyMap_ACC.CompletePLV;
CompletePLV_INT = SynchronyMap_INT.CompletePLV;

%plot
% plot(EjeX,accMap,'r',EjeX,intMap,'b')
% title(titleName)
% legend('acc','int')
%plot
figure
imagesc(squeeze(diffMap)')
title(titleName)

tickPercentage = 0.1;
%[XTickLabels XTickValues] = GetXTicksLabels(EjeX,tickPercentage);
[XTickValues XTickPosition] = CalculateXTicks(EjeX,tickPercentage);

%set(gca,'XTick',[20 40 60 80 100 120 140 160 180] ); 
set(gca,'XTick', XTickPosition); 
%set(gca,'XTickLabel',[EjeX(1,20) EjeX(1,40) EjeX(1,60) EjeX(1,80) EjeX(1,100) EjeX(1,120) EjeX(1,140) EjeX(1,160) EjeX(1,180)]);
set(gca,'XTickLabel',XTickValues);
set(gca,'YTick',[1:size(EjeY,2)] );
%set(gca,'YTickLabel',[EjeY(1,20) EjeY(1,40) EjeY(1,60) EjeY(1,80) EjeY(1,100) EjeY(1,120) EjeY(1,140) EjeY(1,160) EjeY(1,180)]);        
set(gca,'YTickLabel',EjeY);      
set(gca,'YDir','normal');
colorbar


saveas(gcf,titleName,'fig');
roi1 = SynchronyMap_ACC.ROI1;
roi2 = SynchronyMap_ACC.ROI2;
save(titleName, 'accMap','intMap','diffMap','EjeX','EjeY','roi1','roi2','CompletePLV_ACC','CompletePLV_INT');
