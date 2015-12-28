function channelList = PrintChannelsLabels(EEG,titleName)

channelNr = size(EEG.data,1);
channelList{channelNr} = '';

titleName

fileID = fopen([titleName '_ChannelLabels.txt'],'w');
formatSpec = '%d %s\r\n';

for i = 1 : channelNr
    channelList{i} = EEG.chanlocs(i).labels;    
    fprintf(fileID,formatSpec,i,EEG.chanlocs(i).labels);
end

fclose(fileID);

labels = channelList;

titleNameMat = [titleName '.mat'];

text = ['save ' titleNameMat  ' labels'];

eval(text);