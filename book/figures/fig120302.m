%fig120302
clf, hold on
axis([-.1 3.3 -.3 3.1])
axis off
x=0:.01:3.3; y=0;
plot([0 3.3],[0 0], '-')
plot([0 0],[0 2.7], '-')
plot([3 3],[0 2.3], '-', 'LineWidth',2)
plot([0 3], [2.3 2.3],'-','LineWidth',2)
text(-.03,2.8,'{\it y}'),
text(3.3,0,'{\it x}')
text(2.97,-.05,'{\it a}')
text(-.1,2.3,'{\it b}')
%plot([0 -.02], [2.7  2.65], '-')
%plot([0 .02], [2.7  2.65], '-')
%plot([3.3 3.26], [0 .025],'-')
%plot([3.3 3.26], [0 -.025],'-')
text(1.3, 1.15, '{\it u_{xx}+u_{yy}=0}')
text(1.3, -.1,'{\it u(x,0)=f_{0}(x)}')
text(1.3, 2.4, '{\it u(x,b)=f_{1}(x)}')
text(-.4, 1.15,'{\it u(0,y)=g_{0}(x)}')
text(3.05, 1.15,'{\it u(a,y)=g_{1}(x)}')
theta = .125*pi; rhopoint = .075; xf = 3.3; yf= 2.7;
fill([xf-rhopoint*cos(theta) xf xf-rhopoint*cos(theta)],[-rhopoint*sin(theta) 0 rhopoint*sin(theta)],'-')
theta = .11*pi; rhopoint = .075;
fill([-rhopoint*sin(theta) 0 rhopoint*sin(theta)],[yf-rhopoint*cos(theta) yf yf-rhopoint*cos(theta)],'-')

 b=2.3; a=3;
m=50; n=50;
for r=1:m-1
     u=r*a/m;
     plot([u u], [0 b],':' )
end
for r=1:n-1
     v=r*b/n;
     plot([0 a], [v v],':')
end
