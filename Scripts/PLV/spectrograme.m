function [Samp, Sph, EjeX, EjeF] = spectrograme( SIG, FE, FRANGE, TRANGE, WinSig, ResHz, step)
% [Rho, Phi, EjeX, EjeF] = spectrograme( SIG, FE, FRANGE, TRANGE, WinSig, ResHz, step)
% uses a FFT transform to compute the spectral power and phase values, of a matrix of signals 'SIG'. 
% The smaller dimension of 'SIG' is considered to contain the electrodes and
% the longer one, the timepoints.
%
% INPUT :
%    SIG      = Matrix of signals. 
%	 FE       = Sampling frequency in Hz.
%  FRANGE     = Range of analized frequencies in Hz. eg [10:2:100]
%  TRANGE     = Range of trial time in ms.  eg [-300 700]            
%   WinSig    = windows of signal (number of points) to be used in each fft computation.
%   ResHz     = resolution in bins per Hz, 2 means  2 bins per Hz.
%    step     = number of time points between succesive computation windows 'WinSig'
%  
% OUTPUT :
%
%    Rho    = Matrix of signal amplitudes. 
%             1D electrodes, 2D time-points/step, 3D frequencies.
%    Phi    = Matrix of phase information. (as unitary complex vectors) 
%             1D electrodes, 2D time-points/step, 3D frequencies.
%    EjeX   = Time axis for plotting (in ms)
%    EjeF   = Frequency axis for plotting (in Hz)
%      
% Eg:
%       [Rho, Phi, EjeX, EjeF] = spectrograme( MatSig, 1000, [11:70],[-300 700], 256, 1, 10);
%
%       E.Rodriguez 2008



% If columns are not signals, transpose
[rows, columns]=size(SIG);
if rows < columns
    SIG = SIG';
end
Npts = max(rows, columns); %time
Nsig = min(rows, columns); %channels

% transforming a 2D signal matrix in a 3D matrix of
% 1D: time points(in one window), 2D: channels, 3D: Nwindows
[wsM] = WinMat(SIG, WinSig, step);

% the 2D signal matrix is no longer needed
clear SIG

[WinSig, Nsig, Nwins] = size(wsM);

% Computing the time axis
EjeX = TRANGE(1) + (1000/FE)* cumsum([fix(WinSig/2),repmat(step,1,Nwins-1)]);


for i = 1 : Nwins
    % a single time window of signal to be procesed at a time
    % it is a layer of wsM smoothed with a hamming window
    MATSIG = wsM(:,:,i).*repmat(jphamm(WinSig),[1 Nsig]);
    
    % Spectral amplitude and phase of MATSIG
    [Samp(:,:,i), Sph(:,:,i), EjeF] = spctr(MATSIG, ResHz, FE, FRANGE);
    
end

Samp = permute(Samp,[2 3 1]);
Sph = permute(Sph,[2 3 1]);

% constructing a unitary phase information turning vector for each signal
Sph=cos(Sph)+sqrt(-1)*sin(Sph);


%-------------- Subroutines ---------------

function w = jphamm(n)
%HAMMING HAMMING(N) returns the N-point Hamming window.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1994/01/25 17:59:14 $

w = .54 - .46*cos(2*pi*(0:n-1)'/(n-1));


