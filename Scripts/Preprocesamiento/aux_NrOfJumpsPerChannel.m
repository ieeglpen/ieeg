combinedJumps = zeros(2,size(jumps));

for i = 1 : size(jumps,2)
    combinedJumps(1,i) = jumps(i);
    combinedJumps(2,i) = nr_jumps(jumps(i));
end