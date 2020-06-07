function coriolis
%  Coriolis;  Demonstrate the Coriolis force
%  by computing the motion of a particle 
%  as seen from a rotating coordinate system.
%  This is a companion to rotation.m.  The
%  plots are shown in 3-d, as in rotation.m,
%  even though the trajectories here are 2-d.
%  
%  by Jim Price.  January, 2001.
%
%  This may be considered public domain for educational
%  purposes. 
%

clear
clear memory
close all


path(path, 'c:/jpsource/matextras')

% set default graphics things
set(0,'DefaultTextFontSize',12)
set(0,'DefaultAxesFontSize',12)
set(0,'DefaultAxesLineWidth',1.0)
set(0,'DefaultLineLineWidth',1.0)


str2(1) =  {'Coriolis:' };
str2(2) =  {'  '};
str2(3) =  {'Examine the kinematics of a rotating coordinate system by '};
str2(4) =  {'showing the path of a projectile as seen in an inertial '};
str2(5) =  {'reference frame (blue trajectory, Fig 1) and as seen from a'};
str2(6) =  {'frame rotating at a rate \Omega (red trajectory, Figs 1 and 2).'};
str2(7) =  {'(This differs from rotation.m in that there is assumed to be '};
str2(8) =  {'a centripetal acceleration and the motion is purely horizontal.)'};
str2(9) =  {'The projectile has an initial horizontal speed Vo in the Y '}; 
str2(10) = {'direction and is subject to a centripetal acceleration at a'}; 
str2(11) = {'rate -\Omega^2 r = \Omega x \Omega x r as if it were sliding on a '}; 
str2(12) = {'parabolic surface Z = 0.5 \Omega^2 r^2/g. The green path '}; 
str2(13) = {'of Fig 2 (computed in the rotating frame) includes the'};
str2(14) = {'Coriolis acceleration only.  This rotating frame solution '};
str2(15) = {'should be identical to the observations of the path' };
str2(16) = {'made from the rotating frame (red, Fig 2) if we'};
str2(17) = {'have fully accounted for the kinematic effects of the'};
str2(18) = {'rotating frame by the device of the Coriolis acceleration. '};
str2(19) = {'The circular motion at a rate 2\Omega observed and computed '};
str2(20) = {'in the rotating frame is often termed an `inertial motion`. '};
str2(21) = {' '};
str2(22) = {'Hit any key to continue and to step ahead the integration.'};
str2(23) = {''};
str2(24) = {'Jim Price, January, 2001. '};
hf3 = figure(10);
clf
set(hf3,'Position',[50 50 620 620])
set(gca,'Visible','off')
text(-0.1, 0.50, str2,'FontSize',12,'HorizontalAlignment','left')
pause


% t = zeros(2000,1); xs = zeros(2000,3); xcs = xs; xrs = xs;
hpn = 0; k = 0; 

g = 0.;
dt = 0.001;

kase = menu('choose which case', 'standard Vo, Omega and Xo', 'Vo x 2', ...
  'Omega x 2', 'tangential Vo, balanced', 'tangential Vo, unbalanced')   
  
%  the base case:
if kase == 1
rotrate = 0.3;
Omega = rotrate*2*pi*[0 0 1];   %  set the rotation rate       
initpos = 0.3;
x0 = [0 initpos 0.0000];
initang = 0.;
speed0 = 1.5;
u0 = speed0*[0 cos(initang*pi/180), sin(initang*pi/180)];
end

%  larger Vo:
if kase == 2
rotrate = 0.3;
Omega = rotrate*2*pi*[0 0 1];   %  set the rotation rate       
initpos = 0.3;
x0 = [0 initpos 0.0000];
initang = 0.;
speed0 = 3.0;
u0 = speed0*[0 cos(initang*pi/180), sin(initang*pi/180)];
end

%  larger rotation:
if kase == 3
rotrate = 0.6;
Omega = rotrate*2*pi*[0 0 1];   %  set the rotation rate       
initpos = 0.3;
x0 = [0 initpos 0.0000];
initang = 0.;
speed0 = 1.5;
u0 = speed0*[0 cos(initang*pi/180), sin(initang*pi/180)];
end

%  a case with tangential initial velocity
if kase == 4
rotrate = 0.3;
Omega = rotrate*2*pi*[0 0 1];   %  set the rotation rate 
initang = 0;
initpos = 1.0;
x0 = [0 initpos 0.0000];
centa = Omega(3)^2*initpos;
speed0 = sqrt(initpos*centa);
u0 = speed0*[-1 0 0];
end

%  a case with approx tangential initial velocity, unbalanced
if kase == 5
rotrate = 0.3;
Omega = rotrate*2*pi*[0 0 1];   %  set the rotation rate 
initang = 0;
initpos = 1.0;
x0 = [0 initpos 0.0000];
centa = Omega(3)^2*initpos;
speed0 = sqrt(initpos*centa);
u0 = speed0*[-1 0.5 0];    %  note the extra unbalanced Uo
end


x = x0;
u = u0;

%  initial position in the rotating frame
xr = x0;

%  initial position and velocity in the Coriolis frame
xc = x0;
uc = u0 - cross(Omega, x0);

j = 1;
t(1) = 0.;

figure(1)
clf reset

set(gcf,'position', [25 100 450 450])
set(gca,'xColor', [0 0 1], 'ycolor', [0 0 1], 'zcolor', [0 0 1])
xlabel('X'); ylabel('Y'), zlabel('Z')
axis([-1.5 1.5 -1.5 1.5 0 1])
view(30., 60.)
grid

% define and draw an equipotential surface
alpha = 0.2;
xessize = 1.3
for mx = 1:21
   for my = 1:21
      xes(mx) = xessize*(mx-11)/10.;
      yes(my) = xessize*(my-11)/10.;
      res = sqrt(xes(mx)^2 + yes(my)^2);
      zes(my, mx) = alpha*res^2/2;
   end
end
hold on
hm = mesh(xes, yes, zes);
hmt1 = text(-1.5, -1, 2.2, 'the projectile is moving freely')
hmt2 = text(-1.5, -1, 2.0, 'and horizontally on a surface,')
hmt3 = text(-1.5, -1, 1.8, 'Z = 0.5 \Omega^2 r^2/g, that could be')
hmt4 = text(-1.5, -1, 1.6, 'the free surface of a fluid in ')
hmt5 = text(-1.5, -1, 1.4, 'solid body rotation at the rate \Omega ')
harrowo = arrow3([0 0 1], [0 0 0], 0.03, 0.08, 1, 50);
set(harrowo, 'color', 'r');
harrowot = text(0., 0., 1.1, '\Omega', 'color', 'r');

pause
delete(hm); delete (hmt1); delete(hmt2); delete(hmt3); delete(hmt4);
delete(hmt5);


corstuff = 'dV/dt = -g \nabla Z = \Omega x \Omega x r'; 
text(-0.5, 0., 1.8, corstuff, 'Color', 'b')
corstuff = 'V(0) = V_0'
text(-0.5, 0., 1.5, corstuff, 'Color', 'b')


hold on

harrowv0 = arrow3(u0, x0, 0.03, 0.08, 1, 50);
u0pos = u0 + x0;
harrowv0t = text(u0pos(1), u0pos(2), u0pos(3), 'V_0', 'color', 'b');

harrowo = arrow3([0 0 1], [0 0 0], 0.03, 0.08, 1, 50);
set(harrowo, 'color', 'r')
harrowot = text(0., 0., 1.1, '\Omega', 'color', 'r');

      
      

drawnow


figure(2)
clf reset
hold on

set(gcf, 'position', [500 100 450 450])
xlabel('Xr'); ylabel('Yr'); zlabel('Z')
tstr = str2mat('as observed in the rotating frame (red)', ...
   'and as computed in the rotating frame (green)');
htt = title(tstr, 'VerticalAlignment', 'top'); 

corstuff = 'dV_r/dt = - 2 \Omega x V_r '; 
text(-0.5, 0., 1.4, corstuff, 'Color', 'g')
corstuff = 'V_r(0) = V_0 - \Omega x r'
text(-0.5, 0., 1.2, corstuff, 'Color', 'g')

harrowv0c = arrow3(uc, x0, 0.03, 0.08, 1, 50);
set(harrowv0c, 'Color', 'r')
u0pos = uc + x0;
harrowv0ct = text(u0pos(1), u0pos(2), u0pos(3),...
   'V_{r0}', 'color', 'r')
axis([-1.5 1.5 -1.5 1.5 0 1])
grid
view(30., 60.)
drawnow

jp = 0;
j = 0;
t(1) = 0.;

while max(t) <= 4.
   
j = j + 1;
t(j) = (j-1)*dt;
      
%  step ahead the inertial frame variables   
x = x + dt*u;
Omegacr = cross(Omega, x);
centforce = cross(Omega, Omegacr);  %  centripetal force
a = [0 0 g];
u = u + dt*(a + centforce);
   
%  compute the position as seen from the rotating frame
angle = t(j)*Omega(3);
xr(1) = x(1)*cos(angle) + x(2)*sin(angle);
xr(2) = x(2)*cos(angle) - x(1)*sin(angle);
xr(3) = x(3);

%  step ahead the position and speed in the Coriolis frame
xc = xc + dt*uc;
corforce = -2*cross(Omega, uc);      %  Coriolis force
uc = uc + dt*corforce;

%  plot some things, occasionally  ************ plotting

plotfrq = 100;
if mod(j,plotfrq) == 1;
   
jp = jp + 1;

if jp == 2
   figure(1)
   delete(harrowv0);
   delete(harrowv0t);
   delete(harrowo);
   delete(harrowot);
   figure(2)
   delete(harrowv0c);
   delete(harrowv0ct);
end

figure(1)
hold on
title('an inertial frame (blue) and a rotating frame (red)')


if exist('htim') == 1
   delete(htim);
end
tnd = t(j)/(2*pi/Omega(3));
htim = text(-0.8, -2.8, ['time/(2 \pi/\Omega) = ', num2str(tnd,3)]);

if exist('hball') == 1
   delete(hball)
end
hball = plot3( x(1), x(2), x(3), '.k', 'markersize', 16);

plot3(x(1), x(2), x(3), '+b')
 
%  plot the rotating frame
xa = 1*cos(angle);
ya = 1*sin(angle);
xb = -ya;
yb = xa;

%  save data and plot the projectile position in the inertial frame
xcn(jp,:) = x;
if jp >=1
for n=1:jp  
  ang(n) = -(jp-n)*plotfrq*dt*Omega(3);
end
end

if exist('hppr') == 1
delete(hppr); delete(hppr1);
end

for n=1:jp
xr1(n,1) = xcn(n,1)*cos(ang(n)) + xcn(n,2)*sin(ang(n));
xr1(n,2) = xcn(n,2)*cos(ang(n)) - xcn(n,1)*sin(ang(n));
xr1(n,3) = xcn(n,3);
end
hppr = plot3(xr1(:,1), xr1(:,2), 0*xr1(:,2), 'r.');
hppr1 = plot3(xr1(:,1), xr1(:,2), 0*xr1(:,2), 'r+');

if exist('hpp') == 1
   delete(hpp); delete(ht1); delete(ht2);
end

hpp = plot3([xa 0 xb], [ya 0 yb], [ 0 0 0], 'r', 'LineWidth', 1.4);
plot3(x(1), x(2), 0, '.b')
ht1 = text(xa, ya, 0, 'Xr', 'Color', 'r'); 
ht2 = text(xb, yb, 0, 'Yr', 'Color', 'r');
view(30., 60.)

hpa2 = plot3([x(1) x(1)], [x(2) x(2)], [0 x(3)],...
   'b-', 'LineWidth', 0.5);

drawnow
pause(0.1)
delete(hpa2);


figure(2)
hold on

if exist('htimc') == 1
  delete(htimc);
end 
tnd = t(j)/(2*pi/Omega(3));
htimc = text(-0.8, -2.8, ['time/(2 \pi/\Omega) = ', num2str(tnd,3)]);

if exist('hballr') == 1
   delete(hballr)
end
hballr = plot3(xr(1), xr(2), xr(3), '.k', 'markersize', 16);

plot3( xr(1), xr(2), x(3), '+r', 'markersize', 8)
plot3( xr(1), xr(2), 0., '.r', 'markersize', 12)
plot3( xc(1), xc(2), x(3), '+g', ...
    xc(1), xc(2), 0., '.g')
plot3([0 0 1], [1 0 0], [0 0 0], 'r', 'LineWidth', 1.4)  %  the extra axis
text(1, 0, 0, 'Xr', 'Color', 'r'); 
text(0, 1, 0, 'Yr', 'Color', 'r')
view(30., 60.)
set(gca, 'xcolor', [1 0 0], 'ycolor', [1 0 0], 'zcolor', [1 0 0])

hpa = plot3([xr(1) xr(1)], [xr(2) xr(2)], [0 xr(3)],...
   'r-', 'LineWidth', 0.5);
drawnow
pause(0.1)
delete(hpa)


pause    %  hit a key to continue

end  %  end of if on whether to plot or not

end    %  the loop on time, while z > 0

%  the end of coriolis

function hp3 = arrow3(v,x0,radius,l,scale,ntet,c)
%  arrow3( V , X0 , R , L , Scale , N )
%
%          DRAW A 3-D ARROW (as a segment plus a cone)
%
% V   vector to be represented as an arrow
% X0  point where vector start -            (default [0 0 0])
% R   arrow width  (cone radius) (in units of V)
%                                           (default 0.2)
% L   arrow length (cone height) (in units of V)
%     if L>1 the segment is not plotted     (default 0.3)
% Scale is to scale the vector              (default 1)
% N   is the resolution (number of lines to draw a cone)
%                                           (default 12)
%
if nargin<2 x0=[0 0 0]; end
if nargin<3 radius=0.2; end
if nargin<4 l=0.3; end
if nargin<5 scale=1; end
if nargin<6 ntet=12; end
if nargin<7 c=[1 1 1]; end
%create circle normal to vector v
V=norm(v);
salpha=v(3)/V;calpha=sqrt(v(1)*v(1)+v(2)*v(2))/V;
sbeta=0;cbeta=1;
if calpha~=0,sbeta=v(2)/V/calpha;cbeta=v(1)/V/calpha;end
tet=(0:pi/ntet:2*pi)';ct=radius*V*cos(tet);st=radius*V*sin(tet);
x(:,1)=+ct*salpha*cbeta+st*sbeta;
x(:,2)=+ct*salpha*sbeta-st*cbeta;
x(:,3)=-ct*calpha;
ntet2=2*ntet;
%graphic tools
v=v*scale;x=x*scale;
p=x0+v;
%b=axis;d(1:3)=b(2:2:6)-b(1:2:5);d=d/max(d);c=d;
for i=1:3,x(:,i)=x0(i)+(1-l)*v(i)+c(i)*x(:,i);end
if l<1, 
hp3 = plot3(x(:,1),x(:,2),x(:,3),'b-',[p(1)*ones(ntet,1) x(1:2:ntet2,1)]',...
   [p(2)*ones(ntet,1) x(1:2:ntet2,2)]',[p(3)*ones(ntet,1) x(1:2:ntet2,3)]',...
   'b-',[x0(1) p(1)],[x0(2) p(2)],[x0(3) p(3)],'b-');
else
hp3 = plot3(x(:,1),x(:,2),x(:,3),'b-',[p(1)*ones(ntet,1) x(1:2:ntet2,1)]',...
   [p(2)*ones(ntet,1) x(1:2:ntet2,2)]',[p(3)*ones(ntet,1) x(1:2:ntet2,3)]',...
   'b-');
end

