function zeroedMat = ZeroConnMat4ChansNotInList(connMat, chanList)

zeroedMat = connMat;

allchans = 1 : size(connMat,1);

chans2zero = setdiff(allchans,chanList);

for chan = 1 : length(chans2zero)
    zeroedMat(chans2zero(chan),:) = 0;
    zeroedMat(:, chans2zero(chan)) = 0;
end
