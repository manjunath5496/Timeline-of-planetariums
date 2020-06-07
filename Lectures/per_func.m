function [x, y, z] = per_func(t);
%
x = 9.9*sin(0.01*t);
y = 9.9*cos(0.02*t);
z = 5.0*sin(0.03*t+0.01*t^0.5);
return
