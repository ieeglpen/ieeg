clear,close all;clc, figure_defaults
color1=[0 .26 .62];
color2=[.9 .1 0];
warning off
%% carga datos
dir='/home/pablo/disco2/eeg/resting_rasgos_autistas';
cd(dir);sublist
addpath(dir)
load coord;
load largo


sujetos = [sujetos_lula(:,1);sujetos_pablob(:,1);sujetos_joa(:,1)];
sexo     = ([sujetos_lula{:,2} sujetos_pablob{:,2} sujetos_joa{:,2}]) =='M';
edad     = ([sujetos_lula{:,3} sujetos_pablob{:,3} sujetos_joa{:,3}]);

awareness = ([sujetos_lula{:,4} sujetos_pablob{:,4} sujetos_joa{:,4}]);
cognicion = ([sujetos_lula{:,5} sujetos_pablob{:,5} sujetos_joa{:,5}]);
communicacion = ([sujetos_lula{:,6} sujetos_pablob{:,6} sujetos_joa{:,6}]);
motivacion = ([sujetos_lula{:,7} sujetos_pablob{:,7} sujetos_joa{:,7}]);
manierismos = ([sujetos_lula{:,8} sujetos_pablob{:,8} sujetos_joa{:,8}]);

SRStotal = ([sujetos_lula{:,9} sujetos_pablob{:,9} sujetos_joa{:,9}]);
EQ       = ([sujetos_lula{:,10} sujetos_pablob{:,10} sujetos_joa{:,10}]);
SQ       = ([sujetos_lula{:,11} sujetos_pablob{:,11} sujetos_joa{:,11}]);

cd(fullfile(dir,'Resultados','SL'));

for suj=1:length(sujetos)
    suj
    aa = load(['SL_delta','_',sujetos{suj},'.mat']);    
    bb = load(['SL_tita','_',sujetos{suj},'.mat']);    
    cc = load(['SL_sigma','_',sujetos{suj},'.mat']);    
    dd = load(['SL_beta','_',sujetos{suj},'.mat']);    
    ee = load(['SL_gamma','_',sujetos{suj},'.mat']);    
    M(suj,:,:) = mean(cat(3,aa.SL,bb.SL,cc.SL,dd.SL,ee.SL),3);
end

%%
medida = SRStotal;
[a ord]=sort(medida);
 
grupo_bajo= ord([1:floor(length(medida)/2)]);
grupo_alto=ord(floor(length(medida)/2) +1:end);

 

%%

ALL_alto=[];ALL_bajo=[];


bajo = M(grupo_bajo,:,:);
alto = M(grupo_alto,:,:);

%%
y=[ones(size(bajo,1),1) ; ones(size(alto,1),1)*2];
X= [bajo;alto];
X = reshape(X,74,128*128);
clear x
for j=3:size(X,2)
    x = squeeze(X(:,j));
    
    try
        [area_obs(j) labels xx yy] = colAUC2(x, y,'ROC',0);
    catch
        area_obs(j)=0;
    end
end

area_obs = squeeze(reshape(area_obs,size(area_obs,1), 128,128));
imagesc(area_obs)
caxis([.5 .7])

%%

NLINKS = 50;
f=reshape(area_obs,1,128*128);
[f_sort,J] = sort(f,'descend'); % ordena el vector, los primeros n son los que quiero
index=J(1:NLINKS*2) ;
ff=zeros(size(f));
ff(index)=area_obs(index);
ff = reshape(ff,128,128);

figure;draw_arrows_scalp_mariano(ff,0,0,color2,color1);
% TT negativos son azules
%%
 

