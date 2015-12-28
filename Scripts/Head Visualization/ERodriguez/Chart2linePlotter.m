function Chart2linePlotter(Xscale,Yscale,mat,trange,frange,name,cline)
% Chart2linePlotter(Xscale,Yscale,mat,trange,frange,name,cline)
% Makes a line plot of a specified part of a Time-Frequency Chart 
%
% Xscale, Yscale: Axis for ploting 'mat'
%
% mat: Matrix of data to be plotted
%
% trange: Time range to be plotted must be inside 'Xscale' range
%
% frange: Frequency range to be averaged must be inside 'Yscale' range
%
% name: title of the figure
%
% cline: color of line. eg 'k','*-g'
%
% Eg:  
%  Chart2linePlotter(ejesX,ejesY,INDUCEDTF(:,:,5),[1000 15000],[1,50],name,'k')
%
% E.Rodriguez 2003

t1=interp1(Xscale,[1 : length(Xscale)], trange(1),'nearest' );
t2=interp1(Xscale,[1 : length(Xscale)], trange(2),'nearest' );
f1=interp1(Yscale,[1 : length(Yscale)], frange(1),'nearest' );
f2=interp1(Yscale,[1 : length(Yscale)], frange(2),'nearest' );
plot(Xscale(t1:t2),mean(mat(f1:f2,t1:t2)),cline)
title([name,'      f. range = ',num2str(frange(1)),' - ',num2str(frange(2))  ]);
xlabel(['Time  [ms]']);
ylabel(['Mean value ']);
