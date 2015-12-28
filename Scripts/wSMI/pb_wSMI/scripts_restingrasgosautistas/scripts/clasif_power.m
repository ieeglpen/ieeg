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
load chanlocs

delta   = (1:4)    *2;
tita    = (5:8)    *2;
alfa    = (9:12)   *2;
sigma   = (13:15)  *2;
beta    = (15:25)  *2;
gamma    = (25:35) *2;
broadband = (1:35) *2;

%
banda = gamma;
%
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

cd(fullfile(dir,'Resultados'));


load espectro
%%

medida = SRStotal ;

[a ord]=sort(medida);

grupo_bajo= ord([1:floor(length(medida)/2)]);
grupo_alto=ord(floor(length(medida)/2) + 1  :end);

%%
ind_nuca_izq =  [5:18];
ind_nuca_der =  [ 26:32 35:41];
ind_nuca_centro = [19:25];

ind_nuca=[ind_nuca_izq,ind_nuca_der,ind_nuca_centro];
ind_frente=[72:74 76:85 89:96]; 


ind_temporal_derecho=[42:44 45:49 56:61];
ind_temporal_izquierdo=[104:106 117:123 125:128];
ind_centro=[1:3 33:34 51:53 64:66 75 86:88 97:98 109:114];


ind_frente_centro=[76:85 89:93];
ind_frente_derecha=[55:62 69:74 78 79 80];
ind_frente_izquierda=[ 94 95 96 91 92 93 101:107 116:119];


inds_derecha = [ind_nuca_der, ind_temporal_derecho, ind_frente_derecha];
inds_izquierda= [ind_nuca_izq, ind_temporal_izquierdo, ind_frente_izquierda];



for j=1:size(spectra,1)
    Y(j) =   mean2(spectra(j,:,banda));
end


X =           [ones(length(SRStotal),1) SRStotal' edad' sexo'];
Xrestricted = [ones(length(SRStotal),1)  edad' sexo'];

[bhat bint R Rint Stats]                = regress(Y',X);
[bhatres bintres Rres Rintres Statsres] = regress(Y',Xrestricted);

Yhat = bhat(2) * SRStotal + Rres'; Y = Y - min(Y); Y = Y/max(Y);

figure
plot(SRStotal,Yhat,'.'),lsline,box off, axis tight
%%
medida = SRStotal;
[a ord]=sort(medida);
 
grupo_bajo= ord([1:floor(length(medida)/2)]);
grupo_alto=ord(floor(length(medida)/2) +1:end);


y=[ones(size(grupo_bajo,2),1) ;ones(size(grupo_alto,2),1)*2];

X= [Yhat(grupo_bajo),Yhat(grupo_alto)];
figure;
[area_obs labels xx yy] = colAUC2(X', y,'ROC',1);area_obs
patch([xx;1],[yy;0],'b','FaceAlpha',.2);


%% boot
NR = 1000;
distA = nan(1,NR);

for r =1:NR
    Y = shuffle(y);
    [distA(r) labels] = colAUC2(X', Y,'ROC',0);
end
p = length(find(distA>area_obs)) /NR
