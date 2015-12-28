function [sym ,count ] = SymbolicTransfer(signal,kernel, Fs, taus,data_sel,path,fileName)

cfg.kernel = kernel; %% kernel (cantidad de muestras que se utiliza para realizar la transformación) 
                    %%, para poner/cambiar el kernel == 4 hay que corregir PE_paralel!
cfg.chan_sel = 1:size(signal,1);  %% all channels
cfg.sf = Fs; %% sampling frequency
cfg.taus = taus; % Ver taus en do_MI_final.m // ultimos dos agregados por mi - Eze
cfg.data_sel = data_sel;

direc = path;
data = signal;

[sym ,count ] = S_Transf(data,cfg);
            
save(fullfile(direc,'Results','ST',[fileName,'_CSD.mat']),'sym','count');
