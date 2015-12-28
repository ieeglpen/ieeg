function window = GetBaselineWindow(time)
%returns the index of the first and last negative value of a vector 
%with values of times pre and post an event
%if no values are negative returns -1
%INPUT
%time: 1xN vector with values indicating time. Negative values are
%considered values previous to an event. Positive values indicate time
%values after an event ocurred.
%OUTPUT
%window: a 1x2 vector with the index of the initial negative value and the 
%index of the last negative value. If no negative values are present
%returns scalar value -1.

window = -1;

if time(1) < 0
    initWindow = 1;
    endWindow = 1;
    
    for i = 2: size(time,2)
        if time(i) < 0
            endWindow = i;
        else
            break;
        end
    end
    
    window = [initWindow endWindow];
end