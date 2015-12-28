function [epochList] = GetEpochNrFromNrJumps(nr_jumps,nrchannel)

epochList = [];

for i = 1: size(nr_jumps,1)
    
    if nr_jumps(i,3) == nrchannel
        if nr_jumps(i,2) > 0
            epochList = [epochList nr_jumps(i,1)];
        end
    end
end
