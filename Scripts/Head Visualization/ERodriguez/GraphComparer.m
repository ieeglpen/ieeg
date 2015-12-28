function   [SignifChart, ProbChart, avgNsd] = GraphComparer(Cond1,Cond2,pval)

% This function compares two sets of graphs (grafos!). It corrects for multiple comparisons
% and no asumption of independency is made. Instead all permutations of graph comparisons 
% is made in order to establish a distribution of results against which to compare the actual results
%
% INPUTS
% Cond1,Cond2  : two 3D matrices of synchrony. D1 elec pairs, D2 time points, D3 subjects
%
% pval : significance value to get a sync diff.  
%
% OUTPUTS
% SignifChart: Matrix of significance. Ones are ploted at points were the diference 'Cond1' - 'Cond2' 
%              is larger than expected by chance at the 'pval' level.
%
% ProbChart  : Probability chart. Probability to obtain a value larger than 'Cond1' - 'Cond2' 
%              in a distribution derived of all the permutations of the input charts (Cond1 and Cond2).
%
% avgNsd     : Matrix of avg and sd of the permutation matrices for each
%              individual pair of electrodes. D1 elec pairs, D2 mean and SD
%              in this order.
%
%  [SignifChart, ProbChart, avgNsd] = GraphComparer(Cond1,Cond2,pval);
%
% E.Rodriguez 2012

% determining the dimensions of input matrices
[Npairs,Ntimes,Nsubjs] = size(Cond1);

% numperm is the permutation number given Nsubjs subjects.
Nperm = 2^Nsubjs;

% check if the dimensions ot the input matrices match
if size(Cond1) ~= size(Cond2)
    error(['the dimensions of the input matrices must match'])
end

Mweigth = zeros([Nsubjs Nperm]);

% Matrix of diferences between conditions
MatDifCond = Cond1 - Cond2;

% This is the chart of the real results
RealChart = mean(MatDifCond,3);

% Initializing the distribution
ChartProb = zeros(Npairs,Ntimes);
AvgChart = zeros(Npairs,Ntimes,Nperm-1);


% Matrix of posible permutations to be applied on 'MatDifCond' 
% it will weigth each line of 'MatDifCond'
% the size of this matrix is [Nsubjs , 2^Nsubjs]
% each line contains the secuence of ponderation coeficients 
% Eg
%  p1 p2 p3 p4 p5 p6 p7 p8 .....
%  +  -  +  -  +  -  +  -.....
%  +  +  -  -  +  +  -  -.....
%  +  +  +  +  -  -  -  - ....
for i =1 : Nsubjs
    Mweigth(i,:) = repmat([repmat([1],1,2^(i-1)),repmat([-1],1,2^(i-1))],1,2^(Nsubjs-i));
end

const = ceil((Nperm)/100)

% cicle trough the permutations
% NOTE THAT THE FIRST PERMUTATION IS THE RESULT ITSELF AND MUST BE EXCLUDED
% FROM THE FOLLOWING COMPUTATION.

Nperm
for j = 2 :  Nperm
j

%if j/const == fix(j/const); disp([num2str(fix(j/const)),'/100']);end
    
    % J-esieme permutation, a matrix of size [Npairs,Ntimes,Nsubjs]
    % so, every subject (third dimension) is multiplied by 1 or -1
     Permj = MatDifCond .* permute(repmat(Mweigth(:,j),[1,Ntimes,Npairs]),[3 2 1]);
     % Average chart obtained by this J-esime permutation
     AvgChart(:,:,j-1) = mean(Permj,3);
end

%Chart of probability containing the probability of obtaining the values in 'RealChart'
%out of the distribution given by all the posible permutations given in 'AvgChart'.
%[ChartProb] = val2p2(AvgChart,RealChart);

% for k = 1 : Npairs
%     Mattemp = squeeze(AvgChart(k,:,:))';
%     ChartProb(k,:) = sum(binarize3(Mattemp, RealChart(k,:)))/Nperm;   
% end

Npairs
for k = 1 : Npairs
    k
	Mattemp = AvgChart(k,:,:);
    Mattemp = reshape(Mattemp, [prod(size(Mattemp)),1]);
    avgNsd(k,:)=[mean(Mattemp), std(Mattemp)];  
    Mattemp = repmat(Mattemp,1,Ntimes);
    ChartProb(k,:) = sum(binarize3(Mattemp, RealChart(k,:)))/(Nperm*Ntimes);   
end


% Significant chart at pval probability
SignifChart = binarize2(-ChartProb,-pval);

% probability that Cond1 > Cond2
ProbChart = ChartProb;
