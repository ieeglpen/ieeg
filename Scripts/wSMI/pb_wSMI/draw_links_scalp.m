function draw_links_scalp(mat,Tmax,Tmin,color1,color2)

AS=.5;

load 'C:\AnalisisEEG\Alzheimer_colombia\scripts\chanpos.mat'
x = X';
y = Y';
scatter(x,y,4,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
 
TRIAN=triu(~eye(60));

Smin=(mat < Tmin & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.
[i,j,s] = find(Smin);  % convert into pairs 
if length(i) > 0
    arrow([x(i),y(i)],[x(j),y(j)],AS,'EdgeColor',color1,'FaceColor',color1,'Length',0,'BaseAngle',50,'width',AS)
end
 
Smax=(mat > Tmax & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.
[i,j,s] = find(Smax);  % convert into pairs 
if length(i) > 0
    arrow([x(i),y(i)],[x(j),y(j)],AS,'EdgeColor',color2,'FaceColor',color2,'Length',0,'BaseAngle',50,'width',AS)
end
axis off

% set(gcf,'Position',[ 1325         516         560         420 ])