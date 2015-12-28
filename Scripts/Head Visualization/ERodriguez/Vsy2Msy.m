function [MatS] = Vsy2Msy(VecS)

%   [MatS] = Vsy2Msy(VecS) Transform a vector of synchronic activity 
% (syncpairs) consisting of ((nelec x nelec)-nelec)/2 components into  
% a matrix of nelec x nelec components. 
% It works for both, row and column vectors
%
%    VecS    =>                   MatS 
%
%  [Sy21;          [  0   Sy12  Sy13  Sy14 .....  Sy1(N-1)  Sy1N
%   Sy31;           Sy21   0    Sy23  Sy24 .....  Sy2(N-1)  Sy2N
%   Sy32;           Sy31  Sy32   0    Sy34 .....  Sy3(N-1)  Sy3N
%   Sy41;           Sy41  Sy42  Sy43    0  .....  Sy4(N-1)  Sy4N
%   Sy42;    =>      .     .     .      .  .....     .       .
%   Sy43;            .     .     .      .  .....     .       .
%     .              .     .     .      .  .....     .       . 
%     .              .     .     .      .  .....     .       .
%     .              .     .     .      .  .....     0       .
%   SyN(N-1)]       SyN1  SyN2  SyN3  SyN4 .....  SyN(N-1)   0 ]  
%
%   E.Rodriguez 2003

npairs = length(VecS);

nelec =(1 + sqrt(1 + 4*2*npairs))/2;

count=0;
for ei = 2 : nelec
   for ej = 1 : ei-1
      count=count + 1;
      MatS(ei,ej) = VecS(count); % one component
      MatS(ej,ei) = VecS(count); % the symetric one
  end
end

