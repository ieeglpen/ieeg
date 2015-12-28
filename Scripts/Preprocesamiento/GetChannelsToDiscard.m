function [channels2Discard prechannels2Discard jumps nr_jumps] = GetChannelsToDiscard(signal,doplot)

signal = signal';

signalvariance=var(signal);
aboveSV=find(signalvariance>(5*median(signalvariance)));
belowSV=find(signalvariance<(median(signalvariance)/5));
if ~isempty([aboveSV belowSV])
    disp(['Channels to discard: ' int2str([aboveSV belowSV])]); 
end 
prechannels2Discard = union(aboveSV,belowSV);

nr_jumps=zeros(1,size(signal,2));
for k=1:size(signal,2);
    nr_jumps(k)=length(find(diff(signal(:,k))>200)); % find jumps>80uV
end

if doplot
    figure,plot(nr_jumps);
    title('Jumps')
end

jumps = find(nr_jumps>0);

channels2Discard = union(prechannels2Discard,jumps);