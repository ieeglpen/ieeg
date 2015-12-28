function [matrix_norepeat]=identity(red);
%Esta funcion toma cualquier matrix que uno le meta y busca valores que se
%repitan a lo largo de esa matrix. De los valores repetidos deja el
%primero y los demás los llena con NAN. 
%
%
%inputs:
%   1-red: matrix de correlaciones
%
%output=promedio de la matrix de correlaciones habiendo eliminado los
%valores repetidos y habiendo reshapeado la matriz para hacer el promedio 
%
%
%ADVERTENCIA: lo idea es que la matriz sea cuadrada o que este completa en
%ambos triangulos
%
%*****************************************************by Hipereolo 2014

%% (1) 
%genero una red auxiliar en donde, la red que me interesa la pongo en un
%string para después hacer un for donde voy a buscar las correlaciones
%repetidas
red_aux=reshape(red,1,length(red(1,:))*length(red(:,1)));

%% (2)
%empiezo el for que me busca las correlaciones repetidas
for aux=1:length(red_aux)

    repes=find(red_aux(aux)==red_aux);
    red_aux(repes(2:end))=nan;
    clear repes
end
clear aux 
%saco todos aquellos valores que sean igual a uno
unos=find(red_aux>0.999999);
red_aux(unos)=nan;
clear unos

%% (3) reshapeo la matriz que queda sin valores repetidos ni unos
matrix_norepeat=reshape(red_aux,length(red(1,:)),length(red(:,1)));

clear red

end