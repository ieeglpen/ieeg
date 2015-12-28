function plot_scalp(pares , color,flagpatch)
% get skin surface
figure_defaults
skinFullFilename = 'italyskin.mat';
model.skin = load(skinFullFilename);
hold on

if flagpatch
    patch('SpecularStrength',0.4,'DiffuseStrength',0.8,'AmbientStrength',0.5,...
        'FaceLighting','phong',...
        'Vertices',model.skin.italyskin.Vertices,...
        'LineStyle','none',...
        'Faces',model.skin.italyskin.Faces,...
        'FaceColor','interp',...
        'FaceAlpha',1,...
        'EdgeColor','none',...
        'FaceVertexCData',model.skin.italyskin.FaceVertexCData);

    lighting phong; % phone, gouraud
    lightcolor = [0.5 0.5 0.5];
    light('Position',[0 0 1],'color',lightcolor);
    light('Position',[0 1 0],'color',lightcolor);
    light('Position',[0 -1 0],'color',lightcolor);
end
load coords_100.txt
nasion = coords_100(81,:) +[0 100 -26];
left = coords_100(104,:);
right = coords_100(59,:);


marks = [nasion;left ;right];
[new_locations, new_marks] = get_new_locations(coords_100, marks);
hold on
% plot3(new_locations(:,1),new_locations(:,2),new_locations(:,3),'k.')
view([-90 0])

%%

for cont1=1:size(pares,1)
    P1 =  new_locations(pares(cont1,1),:);
    P2 =  new_locations(pares(cont1,2),:);

    x=mean([P2   ;P1]',2);
    centro =   [ 0  -43.3469   34.2041]';

    d=x-centro;
        d = d * norm(P1-P2)*.01;

    x = x - d;

    v1 = [P1(1)-x(1); P1(2)-x(2);P1(3)-x(3)]; % Vector from center to 1st point
    v2 = [P2(1)-x(1); P2(2)-x(2);P2(3)-x(3)]; % Vector from center to 2nd point

    r = norm(v1); % The radius

    v3 = cross(cross(v1,v2),v1); % v3 lies in plane of v1 & v2 and is orthog. to v1
    v3 = r*v3/norm(v3); % Make v3 of length r
    % Let t range through the inner angle between v1 and v2
    t = linspace(-0,atan2(norm(cross(v1,v2)),dot(v1,v2)) +0);
    v = v1*cos(t)+v3*sin(t); % v traces great circle path, relative to center

    plot3(v(1,:)+x(1),v(2,:)+x(2),v(3,:)+x(3),'Color',color,'linewidth',1.5) % Plot it in 3D

end
axis off
view([-90 0])
view([225 10])