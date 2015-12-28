function [SynchedResults result] = GetSynchedChannels(path2files, EEG, data2process, Fs,Frange, Trange, WinSig, BinFreq,Step,threshold)
%calculates PLV for every pair of channels
%INPUT
%path2files: path where values can be saved (??? TODO CHECK)
%EEG: struct from eeglab
%data2process: matrix that contains the data Nxtxtr, where N is the number
%of channels, t is time, tr is trials
%Fs: sampling frequency
%Frange: frequency range 
%Trange: temporal range
%WinSig
%BinFreq
%Step

%OUTPUT
%SynchedResults: struct that contains the information of the electrodes with PLV values 
%above the threshold values . It has the following properties:
%channels: a 1x2 vector with the pair of electrodes
%PLV: a 1xtx1 signal, where t is time, with the PLV values of the pair of electrodes

display 'IN GetSynchedChannels - size data2process'
size(data2process)
[result CumRho CumPhi EjeX EjeF ParElec] = CalculatePLV(path2files, EEG, data2process, Fs,Frange, Trange, WinSig, BinFreq,Step);
display 'result '
size(result)

%synched channel counter
i=0; 
for j = 1:size(result,1)
    largerThanThreshold = find(result(j,:,1)>threshold, 1);
    if(~isempty(largerThanThreshold))
        i = i + 1;
        SynchedResults(i).channels = ParElec(j,:);
        SynchedResults(i).PLV = result(j,:);
        SynchedResults(i).time = EjeX;
    end
        
end

