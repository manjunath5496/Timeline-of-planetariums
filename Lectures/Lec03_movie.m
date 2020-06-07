% script M-file show animation
t = 0;
for t = [1:10]
	[x(t), y(t), z(t)] = per_func(t);
end	
display('Plot starting');

hold off;

%p = plot3(x,y,z,'or','EraseMode','background','Markersize',4);
% Options for EraseMode are normal, none, xor, background
p = plot3(x,y,z,'or','EraseMode','none','Markersize',4);
axis([-10 10 -10 10 -10 10])
hold on
grid on
for t = [11: 2000]
	ind = mod(t,10) + 1;
	[x(ind), y(ind), z(ind)] = per_func(t);
	set(p,'Xdata',x,'Ydata',y,'Zdata',z);
	drawnow;
end
hold off; grid on

display('Plot finished');

