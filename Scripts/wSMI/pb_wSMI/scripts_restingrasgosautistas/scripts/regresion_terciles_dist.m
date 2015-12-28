clear,close all;clc, figure_defaults
color1=[0 .26 .62];
color2=[.9 .1 0];
color3=[.1 .85 .3];
warning off
%% carga datos
dir='/home/pablo/disco2/eeg/resting_rasgos_autistas';
cd(dir);sublist
addpath(dir)
load coord;
load largo
load dists

dist = dist ./max(dist(:));

color= {color2,color3,color1,color2,color3,color1};


banda = 'gamma'

for zona = 1:2:3;
    clear X Y 

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

    clear M
    for suj=1:length(sujetos)
        suj
        bb = load(['SL_',banda,'_',sujetos{suj},'.mat']);
        M(suj,:,:) = bb.SL ;
    end

    %% zonas
    M = reshape(M,size(M,1),size(M,3)*size(M,3));
    dist = dist(:);

    y = prctile(dist(:),[33 66]);
    inds1 = find(dist < y(1));
    inds2 = find(dist < y(2) & dist >= y(1));
    inds3 = find(dist >= y(2));

    y = prctile(dist(:),[25 50 75]);
    inds1 = find(dist < y(1));
    inds2 = find(dist < y(2) & dist >= y(1));
    inds3 = find(dist < y(3) & dist >= y(2));
    inds4 = find(dist >= y(3));


    for j=1:size(M,1)
        switch zona
            case 1, Y(j) =   mean2(M(j,inds1));
            case 2, Y(j) =   mean2(M(j,inds2));
            case 3, Y(j) =   mean2(M(j,inds3));
            case 4, Y(j) =   mean2(M(j,inds4));
        end
    end


    X =           [ones(length(SRStotal),1) SRStotal' edad' sexo'];
    Xrestricted = [ones(length(SRStotal),1)  edad' sexo'];
    %
    whichstats = {'beta','tstat'};
    s = regstats(Y',[SRStotal' edad' sexo'],'linear',whichstats);P_reg(zona) = s.tstat.pval(2)

    [bhat bint R Rint Stats]                = regress(Y',X);
    [bhatres bintres Rres Rintres Statsres] = regress(Y',Xrestricted);

    Yhat = bhat(2) * SRStotal + Rres';
    Y = Y - min(Y); Y = Y/max(Y);
    Yhat = Yhat - min(Yhat); Yhat = Yhat/max(Yhat);

    figure
    plot(SRStotal,Yhat,'k.'),h=lsline,box off, axis tight
    set(h,'linewidth',2);

    format_figure(gcf)
    set_figure_size(7)
    cd /home/pablo/Dropbox/dropbox_pablob/autistic_traits/figuras/figura2/regresion_zonas_roc
%     print('-depsc', '-tiff', '-painters', '-r600', ['regresion_',banda,'_terc',num2str(zona)])


    %%
    medida = SRStotal;
    [a ord]=sort(medida);

    grupo_bajo= ord([1:floor(length(medida)/2)]);
    grupo_alto=ord(floor(length(medida)/2) +1:end);


    y=[ones(size(grupo_bajo,2),1) ;ones(size(grupo_alto,2),1)*2];

    X= [Yhat(grupo_bajo),Yhat(grupo_alto)];
    [area_obs(zona) labels xx yy] = colAUC2(X', y,'ROC',0);area_obs(zona)
    figure;hold on
    plot(xx,yy,'Color',color{zona},'linewidth',2);box off, xlim([0 1]), ylim([0 1.01])
    patch([xx;1],[yy;0],color{zona},'FaceAlpha',.3);
    plot([0 1],[0 1],'Color','k','linewidth',2)
    format_figure(gcf)
    set_figure_size(10)
    cd /home/pablo/Dropbox/dropbox_pablob/autistic_traits/figuras/figura2/regresion_zonas_roc
%     print('-depsc', '-tiff', '-painters', '-r600',['roc_',banda,'_','terc',num2str(zona)])
    %% boot
    NR = 1000;
    distA = nan(1,NR);

    for r =1:NR
        Y = shuffle(y);
        [distA(r) labels] = colAUC2(X', Y,'ROC',0);
    end
    p(zona) = length(find(distA>area_obs(zona))) /NR

end
area_obs