function [significantMat] = wSMIStats4SelChanPairs(path,prefix,cond1,cond2,taus,tau,channelNr,selectedChanPairs,method,alpha,print2edgeFile,path2save)
%returns channelNr*channelNr statistical matrix with t values for selected
%channel pairs only of a wSMI matrix
condition1 = [prefix cond1];
[C1] = LoadwSMIConnectivityMatrix(path,condition1,tau,channelNr);

condition2 = [prefix cond2];
[C2] = LoadwSMIConnectivityMatrix(path,condition2,tau,channelNr);

significantMat = zeros(channelNr,channelNr);

for pair = 1 : size(selectedChanPairs,1)  
    
    chan1 = selectedChanPairs(pair,1);
    chan2 = selectedChanPairs(pair,2); 
    
    data1 = C1(chan1,chan2,:);
    data2 = C2(chan1,chan2,:);
    
    switch method    
        case 'ttest'
            %TTEST
            [h,p,ci,stats] = ttest2(data1,data2);
            t = stats.tstat;
        case 'boot'
            %BOOTSTRAP
            [t, df, p] = statcond( {data1,data2}, 'method','bootstrap','naccu',500 );
        case 'perm'
            %PERMUTATIONS
            [t, df, p] = statcond( {data1,data2}, 'method','perm','naccu',500 );
    end
    
    %if p < alpha
        significantMat(chan1,chan2) = t;
        significantMat(chan2,chan1) = t;
    %end
    
end

if print2edgeFile == 1
    fileName = [path2save cond1 '-' cond2 '_tau' num2str(taus(tau))];
    PrintEdgeFile(fileName,significantMat);
end