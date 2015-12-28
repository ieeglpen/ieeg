function EEG = BipolarMontage(EEG, groupROI )

bipolarLabels = [];
bipolarData = [];

signal = EEG.data;

for i = 1 : size(groupROI,2)
    
    channelsInGroup = groupROI(i).channelRange(1,2) - groupROI(i).channelRange(1,1);
    tempData = [];
    tempLabel = [];
        
    for j = 1 : channelsInGroup 
        tempData(j,:) = signal(channelsInGroup(1,j)) - signal(channelsInGroup(1,j + 1));
        tempLabel{j} = [groupROI(j).label ' ' int2str(channelsInGroup(1,j)) '-' int2str(channelsInGroup(1,j + 1))];
    end
        
    bipolarData = cat(1,bipolarData,tempData);
    bipolarLabels = cat(1,bipolarLabels,tempLabel);
end