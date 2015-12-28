clear all
close all
clc

addpath(genpath('F:\INECO\iEEG\Procesamiento de Señales\Scripts'))

path2files = 'F:\INECO\iEEG\Procesamiento de Señales\Resultados\Paciente4_Nicolas Peirones';
filename = 'HeadInputFile.mat';
TimeWin = 180;
FreqInt = 33:44;
%function  HeadSynchPlotter(path2files, filename, TimeWin, FreqInt)

disp('in head synch plot')
filename = [path2files, '\', filename];
load(filename)

if size(TimeWin)==[1, 1];
    % Computing bins corresponding to TimeWin
    YI = INTERP1(EjeX, [1:length(EjeX)],[0, TimeWin], 'nearest');
    
    % Computing Matrix of Synch corresponding to each head to be plotted
    % MatOfLines=SumN3D(abs(CumMatdif), diff(YI),2)/diff(YI);
    
    MatOfLines=SumN3D(SignifChart, diff(YI),2)/diff(YI);
    
    % Computing Matrix of Power corresponding to each head to be plotted
    %%%%%%%%MatOfPower=SumN3D(CumRho, diff(YI),2);
    
    % Computing bins corresponding to FreqInt
    
    
    %%%%%%%FI = INTERP1(EjeF, [1:length(EjeF)],FreqInt, 'nearest');
    % Reducing Matrix of Synch to selected frequency range
%     MatOfLines=squeeze(mean(MatOfLines(:,:,FI(1):FI(2)),3));
    
%    MatOfLines=squeeze(mean(MatOfLines,3));
    
    % Reducing Matrix of Power to selected frequency range
    %%%%%%%%%%%MatOfPower=squeeze(mean(MatOfPower(:,:,FI(1):FI(2)),3));
    
    % lower limit for lines plotting
 %   [val] = p2val2(MatOfLines,.005)
 %   whos
    
%     [N,X]=hist(mat2vec(MatOfLines),21);
%     figure;
%     plot(X,N);
%     hold on
%     line([val,val],[0,max(N)]);
%     
     step = diff(YI);
%     
%    whos
    
%figure;
    for nheads= 1:size(MatOfLines,2)-1;
        nheads
        ti= (nheads-1)*(step);
        
       figure;
       %hold on
       %subplot(1,size(MatOfLines,2),nheads);
       
        CartoGamSync(MatOfPower(:,nheads),Vsy2Msy(MatOfLines(:,nheads)),Vsy2Msy(-MatOfLines(:,nheads)),'128chanPolar2D_OK.txt',0.5,10,EjeX(ti+1),EjeX(ti+step));

    end
else
end

display('DONE')