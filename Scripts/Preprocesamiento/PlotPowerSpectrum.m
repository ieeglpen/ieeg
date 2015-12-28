function PlotPowerSpectrum(signal,FS,titleName)
% T = 1/FS;                     % Sample time
% LFFT = length(signal);    % Length of signal
% NFFT = 2^nextpow2(LFFT);         % Next power of 2 from length of y
% Y = fft(signal-mean(signal),NFFT)/LFFT;
% f = FS/2*linspace(0,1,NFFT/2+1);

[psd,f,NFFT] = PowerSpectrum(signal,FS);


figure;
plot(f(1:length(psd(1:NFFT/10))),2*abs(psd(1:NFFT/10)))
title(titleName)