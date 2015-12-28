function [result CumRho CumPhi EjeX EjeF ParElec] = CalculatePLV(path2files, EEG, data2process, Fs,Frange, Trange, WinSig, BinFreq,Step)

%SynchChannels
[CumRho, CumPhi,  CumMatdif, EjeX, EjeF, ParElec]  = SynchAnalizer(path2files, EEG, data2process, Fs,Frange, Trange, WinSig, BinFreq,Step);

% OUTPUT :
%
%    Rho    = Matrix of signal amplitudes. 
%             1D electrodes, 2D time-points/step, 3D frequencies.
%    Phi    = Matrix of phase information. (as unitary complex vectors) 
%             1D electrodes, 2D time-points/step, 3D frequencies.
%    EjeX   = Time axis for plotting (in ms)
%    EjeF   = Frequency axis for plotting (in Hz)

result = abs(CumMatdif);
