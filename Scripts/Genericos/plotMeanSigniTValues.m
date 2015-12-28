function plotMeanSigniTValues(mat1,mat2,offset,statmethod,p_value,color1,color2,colorPvalue,colorTvalue,conditionName1,conditionName2,titleName,root)

mat1 = mat1(offset:end,:);
mat2 = mat2(offset:end,:);

time = offset : size(mat1,1) + offset - 1;

%time = 1 : size(mat1,1);

%plot
figure;
subplot(3,1,1)
%plot(meanMat1,color1)
h1 = plot_std_met(mat1,time, color1);

hold on
%plot(meanMat2,color2)

h2 = plot_std_met(mat2,time, color2);

title2Print = [titleName '-' statmethod];

xlim([0 size(time,2)])

title(title2Print)
legend([h1,h2],{conditionName1,conditionName2},'Location','Best')

%estadística
grupo_uno = mat1;
grupo_dos = mat2;

%no debería suceder
grupo_uno(isnan(grupo_uno)) = 0 ;
grupo_dos(isnan(grupo_dos)) = 0 ;

grupo_uno(isinf(grupo_uno)) = 1 ;
grupo_dos(isinf(grupo_dos)) = 1 ;

%TODO revisar su utilidad
%nombre_metrica = 'SmallWorld';
%desvio_out = 2;

%[Resultado_T Resultado_Rank Resultado_Perm]=stat_metricas_globalesBin(grupo_uno,grupo_dos,nombre_metrica,desvio_out);
Permut{1}=grupo_uno;                         % transforma las variables en cellarray
Permut{2}=grupo_dos; 

if strcmp(statmethod,'boot')
    [t df pvals] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
    %[t df pvals] = statcond(Permut, 'mode', 'perm','paired','off','tail','both','naccu',1000);   %calcula permutaciones   
    subplot(3,1,2)
    pv = ones(1,size(pvals,1)) * p_value;
    %plot(1:size(pvals,1),pvals,'g',1:size(pvals,1),pv,'k')
    plotpvals_lpen_met2(p_value,pvals,time,colorPvalue,1,0,'-')
    time(1)
    time(end)
    xlim([time(1) time(end)])
    title('stats')
    subplot(3,1,3)
    plot(time,t,'Color',colorTvalue,'LineWidth',2,'LineStyle','-')
    hold on
    plot([time(1),time(end)],[0,0],'HandleVisibility','off','Color',[0.603 0.603 0.603],'LineWidth',2,'LineStyle','-')
    %plot([time(1),time(end)],[0,0])
    xlim([time(1) time(end)])
    title('T values')
else 
    [pvals h zval ranksum] = ranksumForMatrices(Permut{1},Permut{2},p_value);
    subplot(2,1,2)
    pv = ones(1,size(pvals,1)) * p_value;
    %plot(1:size(pvals,1),pvals,'g',1:size(pvals,1),pv,'k')
    plotpvals_lpen_met2(p_value,pvals,time,colorPvalue,1,0,'-')
    xlim([time(1) time(end)])
    title('stats')
end

fileName = [root title2Print];
saveas(gcf,fileName,'fig');
saveas(gcf,fileName,'eps');
saveas(gcf,fileName,'png');


% [t df pvals] = statcond(Permut, 'mode', 'bootstrap','paired','off','tail','both','naccu',1000);   %calcula permutaciones
% %[p h zval ranksum] = ranksumForMatrices(grupo_uno',grupo_dos',p_value);
% 
% %figure;
% subplot(2,1,2)
% %plot(Resultado_Perm.P)
% plot(pvals)
% hold on
% y = ones(1,1001);
% y = y * p_value;
% plot(y,'r')
% %title('p value Small World - Congruentes - tau 4')