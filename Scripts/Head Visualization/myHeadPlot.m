%import data de .txt con los valores de los electrodos
load 'Peirone_xyz.txt'
x=Peirone_xyz(:,1);
y=Peirone_xyz(:,2);
z=Peirone_xyz(:,3);
index1=12;
index2=80;
xtest=[Peirone_xyz(index1,1),Peirone_xyz(index2,1)];
ytest=[Peirone_xyz(index1,2),Peirone_xyz(index2,2)];
ztest=[Peirone_xyz(index1,3),Peirone_xyz(index2,3)];

figure
scatter3(x,y,z,'filled','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
color1=[0 .26 .62];
color2=[.9 .1 0];
AS = 0.9;
arrow([xtest(1),ytest(1),ztest(1)],[xtest(2),ytest(2),ztest(2)],AS,'EdgeColor','r','FaceColor','r','Length',0,'BaseAngle',50,'width',AS);