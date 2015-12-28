clear,clc,close all
azul=[0 .26 .62];
rojo=[.9 .1 0];


dir='/home/pablo/disco2/eeg/resting_rasgos_autistas';
clc
cd(dir)
sublist;

colores={'b','r'};
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

load(fullfile(dir,'Resultados','metricas','metricas_broadband_degreefijo.mat'));

medida = SRStotal;

[a ord]=sort(medida);


grupo_bajo= ord([1:floor(length(medida)/2)]);
grupo_alto=ord(floor(length(medida)/2) + 1  :end);


%% degree y modularidad

for i=1:length(grupo_bajo)
    ALTO_degree(i,:) = mean(metricas.subject(grupo_alto(i)).degree)';
    BAJO_degree(i,:) = mean(metricas.subject(grupo_bajo(i)).degree)';    

    ALTO_L(i,:) = (metricas.subject(grupo_alto(i)).L)';
    BAJO_L(i,:) = (metricas.subject(grupo_bajo(i)).L)';    

    ALTO_C(i,:,:) = mean(metricas.subject(grupo_alto(i)).C,2);
    BAJO_C(i,:) = mean(metricas.subject(grupo_bajo(i)).C,2);

    ALTO_MOD(i,:) = (metricas.subject(grupo_alto(i)).modularity)';
    BAJO_MOD(i,:) = (metricas.subject(grupo_bajo(i)).modularity)';    

end

ALTO_S  = ALTO_C ./ ALTO_L;
BAJO_S  = BAJO_C./ BAJO_L;

%% k
err_ALTO=std(ALTO_degree,0,1)/sqrt(length(grupo_alto));
err_BAJO=std(BAJO_degree,0,1)/sqrt(length(grupo_bajo));

umbral=1:20:128*128;
figure
niceBars(umbral,mean(ALTO_degree,1),err_ALTO, rojo,.2);hold on
niceBars(umbral,mean(BAJO_degree,1),err_BAJO, azul,.2); hold on

%% C
figure
C_err_ALTO = nanstd(ALTO_C,0,1) / sqrt(length(grupo_alto));
C_err_BAJO = nanstd(BAJO_C,0,1) / sqrt(length(grupo_bajo));
niceBars(umbral,nanmean(ALTO_C,1),C_err_ALTO, rojo,.4);hold on
niceBars(umbral,nanmean(BAJO_C,1),C_err_BAJO, azul,.4); hold on

%% L
figure
L_err_ALTO = nanstd(ALTO_L,0,1) / sqrt(length(grupo_alto));
L_err_BAJO = nanstd(BAJO_L,0,1) / sqrt(length(grupo_bajo));
niceBars(umbral,nanmean(ALTO_L,1),L_err_ALTO, rojo,.4);hold on
niceBars(umbral,nanmean(BAJO_L,1),L_err_BAJO, azul,.4); hold on

%% M
figure
mod_err_ALTO=nanstd(ALTO_MOD,0,1)/sqrt(length(grupo_alto));
mod_err_BAJO=nanstd(BAJO_MOD,0,1)/sqrt(length(grupo_bajo));
niceBars(umbral,nanmean(ALTO_MOD,1),mod_err_ALTO, rojo,.4);hold on
niceBars(umbral,nanmean(BAJO_MOD,1),mod_err_BAJO, azul,.4); hold on

%% S 
figure
S_err_ALTO = nanstd(ALTO_S,0,1) / sqrt(length(grupo_alto));
S_err_BAJO = nanstd(BAJO_S,0,1) / sqrt(length(grupo_bajo));
niceBars(umbral,nanmean(ALTO_S,1),S_err_ALTO, rojo,.4);hold on
niceBars(umbral,nanmean(BAJO_S,1),S_err_BAJO, azul,.4); hold on

figure, hold on
a = nanmean(ALTO_S(:,60:90),2);
b = nanmean(BAJO_S(:,60:90),2);

bar([mean(b) mean(a)],'FaceColor','w')
hold on
errorbar([mean(b) mean(a)] , [std(b)/sqrt(length(b)) std(a)/sqrt(length(a))],'linestyle','none','Color','k')

ylim([.127 .14]);set(gca,'Xtick',[])
set(gca,'Ytick',[.13 .14])



cd /home/pablo/Dropbox/dropbox_pablob/autistic_traits/figuras/S
