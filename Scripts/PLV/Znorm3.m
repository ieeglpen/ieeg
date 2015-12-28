function [Mz] = Znorm3(M, v, dim)
% This is a generalization of Znorm2 to include 3D matrices
% Znorm3(M,v, dim) uses the elements of matrix 'M', specified by vector 'v'  
%  and dimension 'dim' to compute the Z normalization of 'M', such that:
%
%                                                M(v,:,:) if dim = 1
%    Given 'M' let 'Mv' be equal to M(dim, v)= { M(:,v,:) if dim = 2
%                                                M(:,:,v) if dim = 3
%    then 
%         Mz = (M - mean(Mv, dim))/sdt(Mv,0, dim) (0 for a N-1 estimate of SD)
%
%  Note that normalization procceds on DIMENSION GIVEN BY 'dim'
%
%  Note that 'NaN' are replaced by '0'
%  E.Rodriguez 2003


[r,c,p] = size(M);

switch dim
case 1
    Mz = (M - repmat(mean(M(v,:,:),dim),[r 1 1]))./repmat(std(M(v,:,:),0,dim), [r 1 1]);
case 2
    Mz = (M - repmat(mean(M(:,v,:),dim),[1 c 1]))./repmat(std(M(:,v,:),0,dim), [1 c 1]);
case 3
    Mz = (M - repmat(mean(M(:,:,v),dim),[1 1 p]))./repmat(std(M(:,:,v),0,dim), [1 1 p]);
end
    
% replaces NaN by zeros
[I] = find(isnan(Mz));
Mz(I)=0;