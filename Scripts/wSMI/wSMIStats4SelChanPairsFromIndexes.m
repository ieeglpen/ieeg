function [significantMat] = wSMIStats4SelChanPairsFromIndexes(path,prefix,cond1,cond2,csdFile,taus,tau,indexes1,indexes2,channelNr,selectedChanPairs,method,alpha,print2edgeFile,path2save)

%returns channelNr*channelNr statistical matrix with t values for selected
%channel pairs only of a wSMI matrix
condition1 = [prefix csdFile];
[C1] = LoadwSMIConnectivityMatrix(path,condition1,tau,channelNr);
C1 = C1(:,:,indexes1);

condition2 = [prefix csdFile];
[C2] = LoadwSMIConnectivityMatrix(path,condition2,tau,channelNr);
C2 = C2(:,:,indexes2);

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
    path2save
    fileName = [path2save cond1 '-' cond2 '_tau' num2str(taus(tau))]
    PrintEdgeFile(fileName,significantMat);
end