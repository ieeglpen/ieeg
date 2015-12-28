clc
clear all
close all
load 10_estado1_epochs
X = rand(128,2500,30); %% datos
X = data;

cfg.kernel = 3; %% kernel , para poner el kernel == 4 hay que corregir PE_paralel! 
cfg.chan_sel = 1:128;  %% all channels
cfg.data_sel = 1:2500; %% all samples
cfg.sf = 250; %% sampling frequency
cfg.taus = [1 2 4 8];

[sym ,count ] = S_Transf(X,cfg);



