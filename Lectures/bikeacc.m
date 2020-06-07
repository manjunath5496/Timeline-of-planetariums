function dy = bikeacc(t, y)
% acc: Computes accelerations including drag (Cd), rolling (Cr) and 
% and gravity
% y contains, [x z xdot zdot energy] and dy is the time derivative
%
global Grav Rho Mass Cd Cr Area Slope As Bs Lambda Pr Fr_Max TLength % Define these globals so that they will be accessible in the acceleration routine

dy = zeros(5,1);    % a column vector
%
% get the road slope for our current x position.
theta = atan(Slope + As*cos(2*pi*y(1)/Lambda)*2*pi/Lambda - Bs*sin(2*pi*y(1)/Lambda)*2*pi/Lambda);
%
% Compute forces: Assuming bike remains on road surface
% Drag:
vmag = sqrt(y(3)^2+y(4)^2); thetad = atan2(y(4),y(3));
dxd = -Rho*Cd*vmag^2*Area*cos(thetad)/(2*Mass);
dzd = -Rho*Cd*vmag^2*Area*sin(thetad)/(2*Mass);
dxr = +Grav*Cr*cos(theta) ;
dzr = +Grav*Cr*sin(theta) ;
%
% Get rider force
Fr_mag = Fr_Max ;
if ( vmag > 0 ) 
    Fr_mag = Pr/vmag ;
end
if ( Fr_mag > Fr_Max ) Fr_mag = Fr_Max ; end
height = Slope*y(1) + As*sin(2*pi*y(1)/Lambda) + Bs*cos(2*pi*y(1)/Lambda);
%if ( y(2) > height + 0.1 ) Fr_mag = 0; end
dxp = Fr_mag*cos(theta)/Mass ;
dzp = Fr_mag*sin(theta)/Mass ;
%
% Normal force from surface (Grav is a negative value)
dxn =  Grav*cos(theta)*sin(theta);
dzn = -Grav*cos(theta)^2;
% Get the curvature
dy2dx2 = -As*sin(2*pi*y(1)/Lambda)*(2*pi/Lambda)^2 - Bs*cos(2*pi*y(1)/Lambda)*(2*pi/Lambda)^2;
IRc = (dy2dx2)/(1+theta^2)^(3/2);
dxc = vmag^2*sin(theta)*IRc;
dzc = vmag^2*cos(theta)*IRc;
%fprintf(' %5.2f %9.5f %9.5f %5.2f %6.4f %10.1f \n',vmag, dxc, dzc, dxd, dzd, Rc)
%
% Update the dy velocity acceleration vector
dy(1) = y(3);
dy(2) = y(4);
dy(3) = dxd + dxr + dxp + dxn + dxc ;
dy(4) = dzd + dzr + dzp + dzn + dzc + Grav ;
dy(5) = Fr_mag * vmag;



