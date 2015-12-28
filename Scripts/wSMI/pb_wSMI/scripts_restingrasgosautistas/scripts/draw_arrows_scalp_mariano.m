% function draw_arrows_scalp_mariano(mat,Tmax,Tmin)

% Draws arrows between all EEG channels with values > Tmax (in red) and
% values < Tmin in red 
% (loads the Biosemi locations)
% from a connectivity matrix mat

function draw_arrows_scalp_mariano(mat,Tmax,Tmin,color1,color2)
load coord
AS=.5;
scatter(y,x,4,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
 
TRIAN=triu(~eye(128));
 
Smax=(mat > Tmax & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.


[i,j,s] = find(Smax);  % convert into pairs 
if length(i) > 0
arrow([y(i)',x(i)'],[y(j)',x(j)'],AS,'EdgeColor',color2,'FaceColor',color2,'Length',0,'BaseAngle',50,'width',AS)
end
Smin=(mat < Tmin & TRIAN); % finds pairs in the correlation matrix which exceed the threshold.

[i,j,s] = find(Smin);  % convert into pairs 
if length(i) > 0
arrow([y(i)',x(i)'],[y(j)',x(j)'],AS,'EdgeColor',color1,'FaceColor',color1,'Length',0,'BaseAngle',50,'width',AS)
end
axis off