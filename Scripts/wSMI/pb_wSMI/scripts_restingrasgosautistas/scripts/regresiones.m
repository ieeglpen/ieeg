clear,close all;clc, figure_defaults
addpath(genpath('/home/pablo/Documentos/toolboxes/eConnectome/'))

color1=[0 .26 .62];
color2=[.9 .1 0];
warning off
addpath /home/pablo/disco2/eeg/resting_rasgos_autistas/scripts/
addpath /home/pablo/disco2/eeg/resting_rasgos_autistas
addpath /home/pablo/Documentos/eeg/anatomias/povray/
%% carga datos
dir='/home/pablo/disco2/eeg/resting_rasgos_autistas';
cd(dir);sublist

banda = 'alfa';

load coord;
load largo
sujetos       = [sujetos_lula(:,1);sujetos_pablob(:,1);sujetos_joa(:,1)];
sexo          = ([sujetos_lula{:,2} sujetos_pablob{:,2} sujetos_joa{:,2}]) =='M';
edad          = ([sujetos_lula{:,3} sujetos_pablob{:,3} sujetos_joa{:,3}]);

awareness     = ([sujetos_lula{:,4} sujetos_pablob{:,4} sujetos_joa{:,4}]);
cognicion     = ([sujetos_lula{:,5} sujetos_pablob{:,5} sujetos_joa{:,5}]);
communicacion = ([sujetos_lula{:,6} sujetos_pablob{:,6} sujetos_joa{:,6}]);
motivacion    = ([sujetos_lula{:,7} sujetos_pablob{:,7} sujetos_joa{:,7}]);
manierismos   = ([sujetos_lula{:,8} sujetos_pablob{:,8} sujetos_joa{:,8}]);

SRStotal      = ([sujetos_lula{:,9} sujetos_pablob{:,9} sujetos_joa{:,9}]);
EQ            = ([sujetos_lula{:,10} sujetos_pablob{:,10} sujetos_joa{:,10}]);
SQ            = ([sujetos_lula{:,11} sujetos_pablob{:,11} sujetos_joa{:,11}]);


cd(fullfile(dir,'Resultados','SL'));
for suj=1:length(sujetos)
    suj
    aa = load(['SL_',banda,'_',sujetos{suj},'.mat']);
    M(suj,:,:) = aa.SL;
end

%%
for h=1:size(M,1)
    temp = squeeze(M(h,:,:));
    MM(h,:)  = temp(:);
    mmm(h,:) = mean2(temp(:));
end
MM = MM ./max(MM(:));
edad = edad ./max(edad);
SRStotal  =SRStotal ./max(SRStotal);


figure
plot(SRStotal,mmm,'.');

MM(isnan(MM)) = 0;
whichstats = {'beta','tstat'};
clear s
for i=1:length(MM)
    s(i) = regstats(MM(:,i),[SRStotal' edad' sexo'],'linear',whichstats);
end

B=[s.beta]';P=[s.tstat];P=[P(:).pval]';


%%
UM = 0.01
UMBPLOT = 0.;

n=2;
B1  = B(:,n);    B1 = reshape(B1,128,128);
P1  = P(:,n);    P1 = reshape(P1,128,128);

% save(['beta_',banda],'B1','P1');

BB = zeros(size(B1));
BB(P1<UM) = B1(P1<UM);

figure;draw_arrows_scalp_mariano(BB,UMBPLOT,-UMBPLOT,color1,color2);

%% povray
% dirfile = '/home/pablo/disco2/eeg/resting_rasgos_autistas/Resultados/plot_pov/';
% file = fullfile(dirfile,['curvas_',banda,'.pov']);
% 
% [i j] = find(BB<0);
% genera_povfile([i j],'Blue',file,'w');
% 
% [i j] = find(BB>0);
% genera_povfile([i j],'Red',file,'a+');


