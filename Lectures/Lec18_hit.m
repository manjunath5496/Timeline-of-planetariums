function [value,isterminal,direction] = Lec18_hit(t,y)
% Locate the time when height passes through zero in a decreasing direction
% and stop integration.  
value = y(2);     % detect height = 0
isterminal = 1;   % stop the integration
direction = -1;   % negative direction
