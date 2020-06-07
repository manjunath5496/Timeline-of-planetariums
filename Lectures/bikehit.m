function [value,isterminal,direction] = bikehit(t,y)
% Locate the time when height passes through zero in a decreasing direction
% and stop integration.  
global Grav Rho Mass Cd Cr Area Slope As Bs Lambda Pr Fr_Max TLength 

value = y(1)-TLength;     % detect when end is 0.
isterminal = 1;   % stop the integration
direction = 1;   % negative direction
