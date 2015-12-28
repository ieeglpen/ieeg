function [NotchFilteredSignal] = NotchFilter(EEG,hz2Eliminate,hzWidth)

FS = EEG.srate;
canal_notch_0 = EEG.data;

%Notch
% wo=hz2Eliminate/(FS/2);
% bw=wo/10;
% [b,a]=iirnotch(wo,bw);
% canal_notch=filter(b,a,canal_notch_0);

%ALTERNATIVE
EEG = pop_iirfilt( EEG, hz2Eliminate - hzWidth, hz2Eliminate + hzWidth, [], [1]);

canal_notch = EEG.data;

PlotPowerSpectrum(canal_notch(1,:),EEG.srate,'Power Spectrum of Notch Filtered Signal')

NotchFilteredSignal = canal_notch;