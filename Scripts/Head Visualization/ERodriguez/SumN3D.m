
function  [Mr] = SumN3D(M, n, dim)

% SumN3D(M, n, dim); sum matrix 'M' on a 'n' succesive rows basis 
% The summing procedes on the 'dim' dimension, by taking the  
% first 'n' elements, then the following 'n' rows an so on.
%
% Ej:  M =[ 1  2
%           1  2      ----> SumN(M,2) =  [2 4
%           3  4                          6 8]
%           3  4]
%
% IF THE NUMBER OF ROWS IN 'M' IS NOT DIVISIBLE BY 'n', THEN
% THE LAST ROWS ARE USED TO PADD IT TO A DIVISIBLE NUMBER OF ROWS
% AND A WARNING MESSAGE IS DISPLAYED.
%
%  See also 'WinSum' and 'Wmean'
%  E. Rodriguez 2002

[rows, cols, layers] = size (M);
M=permute(M,[dim, setdiff([1 2 3], dim)]);
rows= size(M,1);

% If the number of rows is divisible by 'n' => do nothing.
if rows/n == fix(rows/n)
    % do nothing
% if the number of rows is not divisible by 'n' but closer to n+1    
elseif ceil(rows/n) - rows/n < rows/n - floor(rows/n)
    warning(['!! The last ',num2str(ceil(rows/n)*n - rows) ,' rows have been added to the ',num2str(rows),' rows of the matrix to make it divisible by ',num2str(n),' !!'])
    M = [M; M(2*rows - ceil(rows/n)*n + 1:rows,:,:)];
    [rows, cols, layers] = size (M);
else %% if the number of rows is not divisible by 'n' but closer to n
    warning(['!! The last ',num2str(rows - floor(rows/n)*n) ,' rows have been discarded of the ',num2str(rows),' rows of the matrix to make it divisible by ',num2str(n),' !!'])
    floor(rows/n)*n;
    M = [M(1:floor(rows/n)*n,:,:)];
    [rows, cols, layers] = size (M);
end
    
%% submuestreo por suma de f puntos a 1. 
Mr=squeeze(sum(reshape(M, n, rows/n, cols, layers),1));

Mr=ipermute(Mr,[dim, setdiff([1 2 3], dim)]);
