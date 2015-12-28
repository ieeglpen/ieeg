function [significantMat] = wSMIStats4SelChanPairsFromIndexesAndDegree(path,prefix,cond1,cond2,csdFile,taus,tau,indexes1,indexes2,channelNr,selectedChanPairs,method,alpha,print2edgeFile,path2save,baseNodeFile)

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
    
    if p < alpha
        significantMat(chan1,chan2) = t;
        significantMat(chan2,chan1) = t;
    else
        significantMat(chan1,chan2) = 0;
        significantMat(chan2,chan1) = 0;
    end
    
end

if print2edgeFile == 1

    fileName = [path2save cond1 '-' cond2 '_tau' num2str(taus(tau))];
    PrintEdgeFile(fileName,significantMat);
    
    %calculate degree and print node file
    fid = fopen([baseNodeFile '.node'],'r');
    nodes = textscan(fid, '%d %d %d %d %d %s');
    fclose(fid);
    
    Bin_M = significantMat;
    Bin_M(Bin_M ~= 0) = 1;
	
	% Degrees
	Degrees = degrees_und(Bin_M);
	
	%assuming degrees is a Nx1 matrix (rescale for BrainNetViewer purposes)	
	deg_cell = rescale(Degrees,0,7);
    
    selNodes = unique(reshape(selectedChanPairs,size(selectedChanPairs,1)*size(selectedChanPairs,2),1));
    notSelNodes = setdiff(1:channelNr,selNodes); %returns the data in A that is not in B.
    
    deg_cell(notSelNodes) = 0;
    
    deg_cell = deg_cell';
    deg_cell = num2cell(deg_cell);
    
    nodes{:,4} = deg_cell;
	nodes{:,5} = deg_cell;
    
    fNodes = [num2cell(nodes{:,1})  num2cell(nodes{:,2}) num2cell(nodes{:,3}) nodes{:,4} nodes{:,5} nodes{:,6}];  
	%save Node file
	file_nameNode = [fileName '.node'];       
	dlmcell(file_nameNode,fNodes);
end