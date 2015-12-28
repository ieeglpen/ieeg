function [matdif, matdifshuffle, ParElec] = difphaser3NSH(matphase, matphaseshuffle, step)

% [matdif, ParElec] = difphaser3(matphase, matphaseshuffle, step)
% Similar to difphaser 3 but also computes shuffle values of synchorny
%
% INPUT
%   matphase : 3D Matrix of phase information. 1D electrodes, 2D timepoints, 3D 
%   
%   matphaseshuffle: 3D Matrix of shuffle phase info.
%
%   step     : subsampling factor. 
%
% METHOD
%       The phase difference is computed as:				
%	    delta(THETAij) = THETAi - THETAj =  matphase(i,:)*conj(matphase(j,:) 
%	    for any given electrode pair i, j
%
% OUTPUT
%	matdif: Matrix of phase difference between electrode pairs. It has as many 
%           rows as electrode pairs exist (2016 for 64 channels) and as many 
%           columns as temporal bins. 
%
%   matdifshuffle: Matrix of phase difference between shuffled electrode pairs.
%
%	ParElec: Matrix index of compared pairs. It has as many rows as
%	         compared electrodes, and two columns with the electrode
%	         number (here between 1-64)
%
% Eg:
%   [matdif, matdifshuffle, ParElec] = difphaser3NSH(MatPhi, MatSH, 10);
%
%  E.Rodriguez 2012



[nelec,npts,nfreqs]= size(matphase);

% if matphase is real ( it means it is an angle) transform it to complex
% unitary vector. Else do nothing
if isreal(matphase) == 1
    % constructing a unitary phase information turning vector for each signal
    matphase=cos(matphase)+sqrt(-1)*sin(matphase);
end

if isreal(matphaseshuffle) == 1
    % constructing a unitary phase information turning vector for each signal
    matphase=cos(matphaseshuffle)+sqrt(-1)*sin(matphaseshuffle);
end


% subsamples the 'matphase' matrix by 'step' points
matphase = matphase(:,1:step:npts,:);

matphaseshuffle = matphaseshuffle(:,1:step:npts,:);

%Computes the combination of electrodes 'ParElec'
count=0;
for ei = 2 : nelec
   for ej = 1 : ei-1
      count=count + 1;
      ParElec(count,:) = [ei,ej];
   end
end

% Computes the matrix of phase differences
matdif(:,:,:) = matphase(ParElec(:,1),:,:).*conj(matphase(ParElec(:,2),:,:));

% Computes the matrix of phase differences for shuffled data
matdifshuffle(:,:,:) = matphaseshuffle(ParElec(:,1),:,:).*conj(matphase(ParElec(:,2),:,:));

