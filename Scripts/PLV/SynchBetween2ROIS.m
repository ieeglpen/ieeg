function [SynchedUnifiedResults resultDiffRois] = SynchBetween2ROIS(ROI1,ROI2,path2files, EEG, data2process, Fs,Frange, Trange, WinSig, BinFreq,Step,threshold)
%calculates de phase diference between two rois
%INPUT
%ROI1: 1xN vector where N is the number of channels that belong to the ROI
%ROI2: 1xM vector where M is the number of channels that belong to the ROI
%OUTPUT
%struct containing the PLV Synch between the two ROIs
%that exceeds the threshold value
%It contains the following properties:
%channels: Mx2 vector containing the values of the pair of channels
%PLV: Mxtx1 matrix where M is the number of pair of channels that exceeded
%the threshold value, t is the time lenght and the third dimension is the
%PLV value
%time: the values corresponding to the time (x) axis

%get number of channels in ROI1
ROI1ChannelNr = size(ROI1,2);
%get number of channles in ROI2
ROI2ChannelNr = size(ROI2,2);
%get total number of channels
TotalChannelNr = ROI1ChannelNr + ROI2ChannelNr;

%vector that stores the value of the channel, the position is now its new
%value
channelReferenceVector = zeros(1,TotalChannelNr);
%matrix that stores the signal values of the channels of the ROIs
ROIdata2process = zeros(TotalChannelNr,size(data2process,2),size(data2process,3));
size(ROIdata2process)
%obtaining reference to ROI 1 channels and data
for i = 1 : ROI1ChannelNr
    channelNr = ROI1(1,i);
    %store channel number for reference
    channelReferenceVector(1,i) = channelNr;
    %store channel´s signal
    ROIdata2process(i,:,:) = data2process(channelNr,:,:);
end

%obtaining reference to ROI2 channels and data
for j = ROI1ChannelNr + 1 : TotalChannelNr
    channelNr = ROI2(1,j-ROI1ChannelNr);
    %store channel number for reference
    channelReferenceVector(1,j) = channelNr;
    %store channel´s signal
    ROIdata2process(j,:,:) = data2process(channelNr,:,:);
end

[SynchedResults result] = GetSynchedChannels(path2files, EEG, ROIdata2process, Fs,Frange, Trange, WinSig, BinFreq,Step,threshold);
display 'after synched channels - size plv'
size(SynchedResults(1).PLV)

display 'after synched channels - size result'
size(result)
%unifiedChannels = zeros(size(SynchedResults,2),2);
%unifiedPLV = zeros(size(SynchedResults,2),size(SynchedResults(1).time,2),1);
%generate result structure
h = 0; %counter of valid items
unifiedChannels =zeros(1,2);
unifiedPLV = zeros(1,size(SynchedResults(1).PLV,2));

resultDiffRois = zeros(1,size(result,2),size(result,3));
label{1} = '';
for i=1:size(SynchedResults,2)
    chan1 = channelReferenceVector(SynchedResults(i).channels(1,1));
    chan2 = channelReferenceVector(SynchedResults(i).channels(1,2));
    %if channels do not belong to the same roi results are included as
    %valid
    if(sum(ismember([chan1 chan2], ROI1)) ~= 2 && sum(ismember([chan1 chan2], ROI2))~= 2)
        h = h + 1;
        unifiedChannels(h,1) = chan1;
        unifiedChannels(h,2) = chan2;    
        label{h} = [int2str(chan1) '-' int2str(chan2)];
        unifiedPLV(h,:) = SynchedResults(i).PLV;
        resultDiffRois(h,:,:) = result(i,:,:);
    end
end

SynchedUnifiedResults.channels = unifiedChannels;
SynchedUnifiedResults.PLV = unifiedPLV;
SynchedUnifiedResults.time = SynchedResults(1).time;
SynchedUnifiedResults.labels = label;