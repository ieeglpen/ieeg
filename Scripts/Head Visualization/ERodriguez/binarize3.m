function [Mb]=binarize3(M,Vthreshold)

% binarize3 convierte una matriz de valores cualquiera en una matriz binaria (unos y ceros)
% A diferencia de Binarize2, los valores MAYORES O IGUALES QUE el umbral son puestos a uno, 
% los restantes son puestos a cero. La comparacion es realizada columna por columna.
%
%  Si Vthreshold es un escalar en lugar de un vector, toda la matriz es comparada 
%  contra ese valor
%
% Ej
%
%	M =[ 1 2 3;
%	     4 5 0]
%
%	Mb = binarize3( M, [3 1 2]);
%
%	Mb = [0 1 1;
%		  1 1 1]
% Vea también Binarize2



[Nfilas, Ncolumnas]= size(M);

% Depending on the size and orientation of Vthreshold, substract his values on M
   if size(Vthreshold)==[1, Ncolumnas]
       M = M - ones(Nfilas, 1)* Vthreshold;
   elseif size(Vthreshold)==[Ncolumnas, 1]
       M = M - ones(Nfilas, 1)* Vthreshold';
   elseif size(Vthreshold)==[1, 1]
     %  Vthreshold = Vthreshold*ones(1,Ncolumnas);
     %  M = M - ones(Nfilas, 1)* Vthreshold;
       M = M -  Vthreshold;
       
   else
        error('ERROR; Vthreshold must be either a scalar, either a vector of length = columns of binarized matrix')
    
    end
    

   Mb = sign((sign(M)+1)*0.5);
   