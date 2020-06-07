%% 12S56 Project 3 solution 2005
%
% Set some constants
rtd = 180/pi;   % Radians to degree conversion
% First set up the data
alpha = 74.6274; beta = 51.2464; gamma = 54.1233;
% Now the distances (Use the average of the two values measured)
po = 0.000;  % Prism Bias
% Distances are opposite the angles.
d0 = 39.838-po; d1 = 32.221-po; d2=33.476-po;
%d0 = 39.838-po; d1 = 33.476-po; d2=32.221-po;
% Data set to all the points around the circle
a = [gamma 322.6759 340.1612 16.7340 37.6851 69.1422 103.3052];
d = [d0 10.032 21.625 38.323 41.375 35.558 17.551]; d = d - po; 
l = {'B','a'  'b' 'c' 'd' 'e' 'f'};
%
% Center estimate
ac= 38.8351; dc = 20.656 - po;
%
% Check the sum of the angles and distribute any excess equally to all
% angles
sum = alpha+beta+gamma;
da = (180-sum)/3;
alpha = alpha+da; beta=beta+da; gamma=gamma+da;
fprintf(1,'\n12S56 Project Number 3\n')
fprintf(1,'Sum of angles in triangle is %8.4f deg, adding %6.4f to each angle\n',sum,da)

% Check basic data by using cosine rule to predict sides
e0 = sqrt(d1^2+d2^2-2*d1*d2*cos(alpha/rtd));
e1 = sqrt(d0^2+d2^2-2*d0*d2*cos(beta/rtd));
e2 = sqrt(d1^2+d0^2-2*d1*d0*cos(gamma/rtd));

% Set up a system in which the triangle is perfect.  Use two sides and one
% angle.
%d1 = sqrt(d0^2+d2^2-2*d0*d2*cos(beta/rtd));
%alpha = asin(d0*sin(beta/rtd)/d1)*rtd;
%gamma = asin(d2*sin(beta/rtd)/d1)*rtd;
% Now solve the main triangle
a1 = atan((d2/d1-cos(alpha/rtd))/sin(alpha/rtd))*rtd; R1=d1/(2*cos(a1/rtd));
b1 = atan((d0/d2-cos(beta/rtd))/sin(beta/rtd))*rtd; R2=d2/(2*cos(b1/rtd));
g1 = atan((d1/d0-cos(gamma/rtd))/sin(gamma/rtd))*rtd; R3=d0/(2*cos(g1/rtd));
%
% Now print out the results
fprintf(1,'-------12S56 2008------------------------\n')
fprintf(1,'Results for each angle/distance pair\n')
fprintf(1,'Alpha    1 %8.4f  Radius 1 %6.3f\n',a1,R1)
fprintf(1,'Beta      1 %8.4f  Radius 2 %6.3f\n',b1,R2)
fprintf(1,'Gamma 1 %8.4f  Radius 2 %6.3f\n',g1,R3)
MeanR = (R1+R2+R3)/3;
fprintf(1,'Mean radius %6.3f\n',MeanR)
fprintf(1,'-----------------------------------\n')

% Now compute the values around the cirlce and at the center
a = a/rtd; a0 = 90-a1; % 90-2*a1;
as = atan2((d/d1-cos(a)),sin(a)); r=abs(d1./(2*cos(as))); p=mod(2*(a0-(a-as)*rtd),360);
%
% Ouput the results
fprintf(1,' Point      Radius    Drad  Angle \n')
n = length(p);
for i = 1:n
    fprintf(1,'   %2s   %7.3f   %7.3f  %7.4f\n',l{i}, r(i), r(i)-MeanR, p(i))
end
%
% Finish up calculation of location of CEN (Sprinkler)
dd = a1-ac; dx=dc*cos(dd/rtd)-MeanR;dy=dc*sin(dd/rtd);
dcent = sqrt(dx^2+dy^2); danc = atan2(dy,dx)*rtd;
fprintf(1,'Sprinkler Postion  %4.3f (m) at %6.2f deg\n',dcent,danc);

% Plot up the results
figure(2)
plot(p,r-MeanR,'+')
xlim([0 360]);
xlabel('Angle at Center')
ylabel('Difference from Mean Radius (m)')
MRstr = sprintf('Mean Radius %6.3f (m)',MeanR);
text(10,0.08,MRstr)
for i = 1:n
    text(p(i),r(i)-MeanR+0.003,l{i})
end
print -dpng -r75 Proj_3_08_Fig2.png
%
% Total plot (Reverse sign of y so we have positive rotation)
yc = r.*cos(p/rtd);xc = -r.*sin(p/rtd);
figure(1)
plot(xc,yc,'+')
hold on; plot(dx,dy,'o'); text(1,0,'CEN'); grid on
for i=1:n
    text(xc(i)*(1.08),yc(i)*1.08,l{i});
end
% Now plot a circle if Mean radius
plot(MeanR*cos(0:0.01:2*pi),MeanR*sin(0:0.01:2*pi),'g')
% Plot the main mark
ym = [ -R1 R2*sin((270-2*(90-(alpha-a1)))/rtd) R3*sin((90-(2*a1))/rtd)];
xm = [ 0   R2*cos((270-2*(90-(alpha-a1)))/rtd) R3*cos((90-(2*a1))/rtd)];
lm = ['A' 'B' 'C'];
plot(xm,ym,'r^');
axis equal  % To make plot square

for i = 1:3
    text(xm(i),ym(i)-R1/15,lm(i));
end
axis([-25 25 -25 25]); % set(gca,'YDir','reverse');
xlabel('"East" m'); ylabel('"North" (m)')
print -dpng -r75 Proj_3_08_Fig1.png

hold off












