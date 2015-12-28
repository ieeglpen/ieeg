% topoplot() - plot a topographic map of an EEG field as a 2-D
%              circular view (looking down at the top of the head) 
%              using cointerpolation on a fine cartesian grid.
% Usage:
%        >>  topoplot(datavector,'eloc_file');
%        >>  topoplot(datavector,'eloc_file',   'Param1','Value1', ...)
% Inputs:
%
%    datavector = vector of values at the corresponding locations.
%   'eloc_file' = name of an EEG electrode position file {0 -> 'chan_file'}
%
% Optional Parameters & Values (in any order):
%                  Param                         Value
%                'colormap'         -  any sized colormap {default jet(64)}
%                'output'           - 'screen' gives black background 
%                                     'printer' gives white background
%                                        {default 'screen'}
%                'interplimits'     - 'electrodes' to furthest electrode
%                                     'head' to edge of head
%                                        {default 'electrodes'}
%                'gridscale'        -  scaling grid size {default 67}
%                'maplimits'        - 'absmax' +/- the absolute-max 
%                                     'maxmin' scale to data range
%                                     [clim1,clim2] user-definined lo/hi
%                                        {default = 'absmax'}
%                'style'            - 'straight' colormap only
%                                     'contour' contour lines only
%                                     'both' both colormap and contour lines
%                                        {default = 'straight'}
%                'numcontour'       - number of contour lines
%                                        {default = 20}
%                'example'          - show example of an eloc_loc file
%
% Note: topoplot() only works when map limits are >= the max and min 
%                                     interpolated data values.
% eloc_file format:
%       chan_number degrees radius channel_name
%       (Angle-0 = Cz-to-Fz; C3-angle =-90; Radius at edge of image = 0.500)
%       topoplot() will ignore any electrode with a position outside 
%       the head (radius > 0.5).  See >> topoplot('example')
%
% Note: topoplot() adds one value to the colormap for the background. 
%       with value [0 0 0] for 'screen' or [1 1 1] for 'printer'.
%       This increases the size of the colormap by one, which 
%       should be taken into account when plotting a colorbar.
%

% Andy Spydell, NHRC,  7-23-96
% 8-96 Revised by Colin Humphries, CNL / Salk Institute, La Jolla CA
%   -changed surf command to imagesc (faster)
%   -can now handle arbitrary scaling of electrode distances
%   -can now handle non integer angles in eloc_file
% 4-4-97 Revised again by Colin Humphries, reformat by SM
%   -added parameters
%   -changed eloc_file format
% Revised for Matlab 5.0.1 11/97

%function handle = topoplot(Vl,loc_file,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7)

function [x, y] = topoploter2(Vl,loc_file,p1,v1,p2,v2,p3,v3,p4,v4,p5,v5,p6,v6,p7,v7)

% error(nargchk(1,10,nargin));
%if nargin<1 | nargin > 10
%	help topoplot
%	return
%end

% Set Defaults:
                                    %lisup=2%.225;%.58; 
                                    %linf=-2% 0.23 
MAXCHANS = 256;
DEFAULT_ELOC = 'chan_file';
OUTPUT = 'screen';
INTERPLIMITS = 'head';
MAPLIMITS = [];
COLORMAP = jet(64);
GRID_SCALE = 67;
CONTOURNUM = 6;
STYLE = 'straight';

if nargin==1,
    loc_file = DEFAULT_ELOC;
end
nargs = nargin;
if nargin>1,
  if isstr(Vl)
    error('topoplot(): first argument should be the data vector');
  end
else
   if isstr(Vl) 
     if strcmp(lower(Vl),'example') | strcmp(lower(Vl),'demo')
       fprintf(['This is an example electrode location file.\n',...
               'Channel names should have 4 chars (. = space).\n',...
               'A file should consist of the following parameters:\n',...
               'channel_number degrees radius channel_name\n\n',...
               ' 1                 -18    .352       Fp1.\n',...
               ' 2                  18    .352       Fp2.\n',...
               ' 3                 -39    .231       F3..\n',...
               ' 4                  39    .231       F4..\n',...
               ' 5                 -90    .181       C3..\n',...
               ' 6                  90    .181       C4..\n',...
               ' 7                 -90    .500       A1..\n',...
               ' 8                  90    .500       A2..\n',...
               ' 9                -142    .231       P3..\n',...
               '10                 142    .231       P4..\n',...
               '11                -162    .352       O1..\n',...
               '12                 162    .352       O2..\n',...
               '13                 -54    .352       F7..\n',...
               '14                  54    .352       F8..\n',...
               '15                 -90    .352       T3..\n',...
               '16                  90    .352       T4..\n',...
               '17                -126    .352       T5..\n',...
               '18                 126    .352       T6..\n',...
               '19                   0    .181       Fz..\n',...
               '20                   0    0          Cz..\n',...
               '21                 180    .181       Pz..\n\n',...
               'The edge of the head has a radius of .500;\n',...
               '0 degrees points towards the nasion\n\n\n'])
       return
     else
       error('topoplot(); first argument is a vector of data values');
     end
   end
end
if loc_file == 0,
   loc_file = DEFAULT_ELOC;
end

if nargs > 2
   if ~(round(nargs/2) == nargs/2)
      error('topoplot(): Incorrect number of inputs')
   end
   for i = 3:2:nargs
      Param = eval(['p',int2str((i-3)/2 +1)]);
      Value = eval(['v',int2str((i-3)/2 +1)]);
      if ~isstr(Param)
         error('topoplot(): Parameter must be a string')
      end
      Param = lower(Param);
      if strcmp(Param,'colormap')
         if size(Value,2)~=3
            error('topoplot(): Colormap must be a n x 3 matrix')
         end
         COLORMAP = Value;
         User_CM_Flag = 1;
      elseif strcmp(Param,'interplimits')
         if ~isstr(Value)
            error('topoplot(): interplimits value must be a string')
         end
         Value = lower(Value);
         if ~strcmp(Value,'electrodes') & ~strcmp(Value,'head')
            error('topoplot(): Incorrect value for interplimits')
         end
         INTERPLIMITS = Value;
      elseif strcmp(Param,'output')
         if ~isstr(Value)
            error('topoplot(): output value must be a string')
         end
         Value = lower(Value);
         if ~strcmp(Value,'screen') & ~strcmp(Value,'printer')
            error('topoplot(): Incorrect value for output')
         end
         OUTPUT = Value;
      elseif strcmp(Param,'maplimits')
         if isstr(Value)
            Value = lower(Value);
            if ~strcmp(Value,'absmax') & ~strcmp(Value,'maxmin')
               error('topoplot(): Incorrect value for maplimits')
            end
            MAPLIMITS = Value(1);
         else   
            if size(Value,1) > 1 | size(Value,2) > 2
               error('topoplot(): Incorrect Value for maplimits')
            end
            MAPLIMITS = Value;
         end
      elseif strcmp(Param,'gridscale')
         GRID_SCALE = Value;
      elseif strcmp(Param,'style')
         Value = lower(Value);
         if ~strcmp(Value,'contour') & ~strcmp(Value,'straight') & ~strcmp(Value,'both')
	    error('Incorrect value for style')
         end
	 STYLE = Value;
      elseif strcmp(Param,'numcontour')
         CONTOURNUM = Value;      
      end
   end
end

[r,c] = size(Vl);
if r>1 & c>1,
    fprintf('topoplot(): data should be a single vector\n');
    return
end
fid = fopen(loc_file);
if fid<1,
	fprintf('topoplot(): cannot open eloc_file (%s)\n',loc_file)
    return
end
A = fscanf(fid,'%d %f %f  %s',[7 MAXCHANS]);
fclose(fid);

A = A';

if length(Vl) ~= size(A,1),
       fprintf('topoplot(): data vector must have %d values to match %s\n',size(A,1),loc_file);
       return
end




labels = setstr(A(:,4:7));
idx = find(labels == '.');                       % some labels have dots
labels(idx) = setstr(abs(' ')*ones(size(idx)));  % replace them with spaces

Th = pi/180*A(:,2);                               % convert degrees to rads
Rd = A(:,3);
ii = find(Rd <= 0.5); % interpolate on-head channels only
Th = Th(ii);
Rd = Rd(ii);
Vl = Vl(ii);

[x,y] = pol2cart(Th,Rd);

if strcmp(INTERPLIMITS,'head')

   xmin = min(-.5,min(x)); xmax = max(0.5,max(x));
   ymin = min(-.5,min(y)); ymax = max(0.5,max(y));
    
else
   xmin = max(-.5,min(x)); xmax = min(0.5,max(x));
   ymin = max(-.5,min(y)); ymax = min(0.5,max(y));

  % xmin = min(x); xmax = max(x);
  % ymin = min(y); ymax = max(y);
end

rmax = .5;

x_scale = GRID_SCALE;               % number of partitions x-axis (odd)
y_scale = GRID_SCALE;               % number of partitions y-axis (odd)
xi = linspace(xmin,xmax,x_scale);   % x-axis description (row vector)
yi = linspace(ymin,ymax,y_scale);   % y-axis description (row vector)

yi = yi';                           % make it a column vector for griddata

%[Xi,Yi,Zi] = griddata(x,y,Vl,xi,yi);
[Xi,Yi,Zi] = griddata(y,x,Vl,yi,xi,'invdist');

% only want data within radius of rmax
mask = (sqrt(Xi.^2+Yi.^2) <= rmax ); 
% this mask a half moon in the front part of the head
%mask = (sqrt(Xi.^2+Yi.^2) <= rmax & sqrt(Xi.^2+(Yi+.23).^2) < rmax ); 


if strcmp(OUTPUT,'screen')
  axiscolor = get(gca,'Color');
   map = [COLORMAP;axiscolor];
else
   map = [COLORMAP;1 1 1];
end

m = size(map,1)-1;
colormap(map)

ii = find(mask ~= 0);

if isempty(MAPLIMITS)
   amin = -max(max(abs(Zi(ii))));
   amax = max(max(abs(Zi(ii))));
elseif isstr(MAPLIMITS)
   if MAPLIMITS == 'm'
      amin = min(min(Zi(ii)));
      amax = max(max(Zi(ii)));
   else
      amin = -max(max(abs(Zi(ii))));
      amax = max(max(abs(Zi(ii))));
   end
else
   amin = MAPLIMITS(1);
   amax = MAPLIMITS(2);
end
%amin=linf;
%amax=lisup;

idx = min(m,round((m-1)*(Zi-amin)/(amax-amin))+1);
ii = find(mask == 0);
idx(ii) = (m+1)*ones(size(ii));
%figure
%pcolor(idx)

%hs = image([min(Yi) max(Yi)],[min(Xi) max(Xi)],rot90(idx));
if strcmp(STYLE,'contour')
   [ccc,cch] = contour(Xi,Yi,(Zi),CONTOURNUM,'k');
   for ij = 1:length(cch)
      ccx = get(cch(ij),'Xdata');
      ccy = get(cch(ij),'Ydata');
%      ccz = get(cch(ij),'Zdata');
      iii = find(sqrt(ccx.^2+ccy.^2) > rmax);
      ccx(iii) = [];
      ccy(iii) = [];
%      ccz(iii) = [];
%      set(cch(ij),'Xdata',ccx,'Ydata',ccy,'Zdata',ccz);
      set(cch(ij),'Xdata',ccx,'Ydata',ccy);
    end
    keyboard
%   set(gca,'YDir','reverse')
elseif strcmp(STYLE,'both')
   hs = image([min(Xi) max(Xi)],[min(Yi) max(Yi)],(idx)); %%%%%%%%%%%%%%%%%%%%%
   set(gca,'YDir','normal')
   hold on
   if strcmp(OUTPUT,'printer')
      [ccc,cch] = contour(Xi,Yi,(Zi),CONTOURNUM,'k');
   else
      [ccc,cch] = contour(Xi,Yi,(Zi),CONTOURNUM,'k');
   end
   for ij = 1:length(cch)
      ccx = get(cch(ij),'Xdata');
      ccy = get(cch(ij),'Ydata');
%      ccz = get(cch(ij),'Zdata'); %
      iii = find(sqrt(ccx.^2+ccy.^2) > rmax);
      ccx(iii) = [];
      ccy(iii) = [];
%      ccz(iii) = [];%
%      set(cch(ij),'Xdata',ccx,'Ydata',ccy,'Zdata',ccz);%
      set(cch(ij),'Xdata',ccx,'Ydata',ccy);

   end
else
   hs = image([min(Xi) max(Xi)],[min(Yi) max(Yi)],(idx));%%%%%%%%%%%%%%%%
   set(gca,'YDir','normal')

end
%keyboard
ha = gca;                           % axes handle

axis([-rmax*1.3 rmax*1.3 -rmax*1.3 rmax*1.3])
%   set(ha,'XTick',[]);
%   set(ha,'YTick',[]);

hold on
   % plot the black circle (This looks bad...fix it up)
   l = 0:2*pi/100:2*pi;
%   hp2 = plot(cos(l).*rmax,sin(l).*rmax,'-w');
%      set(hp2,'LineWidth',2);

%   % Plot electrode placement
% if strcmp(OUTPUT,'printer')
%   hp2 = plot(y,x,'.w');  
% else
%   hp2 = plot(y,x,'.k');
% end
   % plot the nose 
%   tip = -.575; base = -.49;
tip = rmax*1.15; base = rmax;

% NoseMX = [-0.06 -0.056 -0.0515 -0.02 -0.0135 -0.0105 0 0.0105 0.0135 0.02 0.0515 0.056 0.06];

% NoseMY = [0.5000 0.5128 0.5166 0.530 0.5394 0.5509 0.5547 0.5509 0.5394 0.530 0.5166 0.5128 0.5000];

% plot(NoseMX,NoseMY,'color','w','Linewidth',2)   
   
   
%   hp3 = plot([.1;0],[base;tip],'w');
%   hp4 = plot([-.1;0],[base;tip],'w');
% hp3 = plot([.18*rmax;0],[base;tip],'w','LineWidth',2);
% hp4 = plot([-.18*rmax;0],[base;tip],'w','LineWidth',2);

% draw ears
EarX = [.491 .510 .5299 .5419 .5509 .551 .532 .510 .4900];
EarY = [.0855 .1084 .1046 .0855 .0245 -.0632 -.1013 -.1084 -.0899];

% plot(EarX,EarY,'color','w','LineWidth',2)
% plot(-EarX,EarY,'color','w','LineWidth',2)   

if strcmp(OUTPUT,'printer')
   hp2 = plot(y,x,'.k');
   hp2 = plot(cos(l).*rmax,sin(l).*rmax,'color','k','Linestyle','-','LineWidth',4);
   hp3 = plot([.18*rmax;0],[base;tip],'k','LineWidth',4);
   hp4 = plot([-.18*rmax;0],[base;tip],'k','LineWidth',4);
   plot(EarX,EarY,'color','k','LineWidth',4)
   plot(-EarX,EarY,'color','k','LineWidth',4)   
  
else
  
%    hp2 = plot(y,x,'ok','LineWidth',4); %%%%%%%%%%%% draw elec position
%    hp2 = plot(y,x,'ow','LineWidth',1); %%%%%%%%%%%% draw elec position
%    hp2 = plot(y,x,'ow','LineWidth',2); %%%%%%%%%%%% draw elec position
%   % %hp2 = plot(y,x,'ow','LineWidth',3); %%%%%%%%%%%% draw elec position
%   % hp2 = plot(y,x,'*w','LineWidth',2); %%%%%%%%%%%% draw elec position
%    
   hp2 = plot(y,x,'.k','LineWidth',.05); %%%%%%%%%%%% draw elec position
  
  %DRAW a white limiting band in front of the HEAD 
  %hp2 = plot(cos(l).*rmax,sin(l).*rmax-.23,'color','w','Linestyle','-','LineWidth',6);
   hp2 = plot(cos(l).*rmax,sin(l).*rmax,'color','k','Linestyle','-','LineWidth',4);% DRAW HEAD
   

   hp3 = plot([.18*rmax;0],[base;tip],'k','LineWidth',4);% draw nose right
   hp4 = plot([-.18*rmax;0],[base;tip],'k','LineWidth',4);% draw nose left
   plot(EarX,EarY,'color','k','LineWidth',4)  % draw  right ear
   plot(-EarX,EarY,'color','k','LineWidth',4)  % draw  left ear 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold off
axis off
%set(ha,'Visible','off')



