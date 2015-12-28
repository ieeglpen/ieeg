function [epochList] = GetEpochNrFromPrechannels(prechannels,nrchannel)
epochList = [];

for i = 1 : size(prechannels,1)
    if prechannels(i,2) == nrchannel
        display('in')
        epochList = [epochList prechannels(i,1)];
    end 
end