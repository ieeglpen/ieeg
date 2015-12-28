function	ok=CartoGamSync(Gpow,sync,desync,elocfile,limite,limite2,ti,tf)

% this draws a head,(just one) plots the electrodes on it (given 
% by coordinates in elocfile) interpolates for gamma values given
% in Gpow an draw lines of synchrony (sync) and desynchrony (desync)
%
%		Ej: CartoGamSync(Gpow,sync,desync,'eloc64.txt',limite,limite2,ti,tf)
%
%		Gpow     = Gamma power vector of nelec (N° of electrodes) 
%				   components.   Values must be between [-2, 2]
%		sync     = matrix of syncrony interactions dimension nelec*nelec
%		desync   = matrix of dimension nelec*nelec
%		elocfile = matrix with polar coordinates of electrodes
%					  theta=0 points to nasion(see file 'eloc64.txt')
%	    limite 		= synchrony values determining thinest and widest 
%	    limite2		  lines in the plot
%		ti			= begining of time window in ms (for ploting)
%		tf			= end of time window in ms (for ploting uses)
%
%	USES SCRIPTS topoploter2 

% Defines the colormap to be used
jet1=hot(64);
jet2=jet1(10:64,:);
% defines color and linewidth for synchrony lines
sa='k';%[.5 .5 .5];%'b';%[.7 0 0];%'k'
%lwa=3;
% defines color and linewidth for desynchrony lines
sr=[0 .5 0];%[0 0 1];%'g'
%lwr=3;

if ischar(ti)==0
   ti=num2str(ti);
   tf=num2str(tf);
end


 [ex,ey]=topoploter2(Gpow,elocfile,'colormap',jet2);
  hold on;
  jgplot2(sync,[ey,ex],sa,limite,limite2); 
  jgplot2(desync,[ey,ex],sr,limite,limite2);

title([ti,' - ',tf,' ms'])   


function	ok=jgplot2(A,xy,lc,lf,lg)

%  This script is a generalization of gplot
%  it plots a graph given by
%
%	A = matrix of conextions aij=1 if node i conects with node j.
%	    else aij=0.
%
%	xy = matrix of coordinates; cordinates of node i are coded in
%	     xy(i,:)= [x(i), y(i)]
%
%   lc = vector or string defining the line color
%
%   lf = smallest value to be ploted (linea fina)
%
%   lg = largest value to be ploted (linea gruesa)
%
%  Unlike gplot, all conection line parameters are avaibles.
%

% Line parameters
ls='-'; 	% line style, default '-'
	

X=[];
Y=[];
LW=[];
[n,m]=size(A);


k=1;
for i=2:n       %----------------------------+
    for j=1:i-1       %-------------------+  |
		if A(i,j)>=lf & A(i,j)<=lg %%%%%% |  |
	 		X(1,k)=xy(i,1);             % |  |	
	  		X(2,k)=xy(j,1);             % |  |
	  		Y(1,k)=xy(i,2);             % |  |
	  		Y(2,k)=xy(j,2);             % |  |
            LW(k) = A(i,j);             % |  |
            k=k+1;	    	            % |  |
		end    %%%%%%%%%%%%%%%%%%%%%%%%%% |  |
    end	      %---------------------------+  | 
end       %----------------------------------+	


% Valores que puede tomar la fuerza de asociacion (matriz de links)
lx=linspace(lf,lg,10);
% Valores que puede tomar 'LineWidth' osea 2-11
ly=linspace(2,11,10);
% line width definition
LW=interp1(lx,ly,LW,'nearest');

for p = 1:k-1
   h=line(X(:,p),Y(:,p),'color',lc,'linestyle',ls,'linewidth',LW(p));
end