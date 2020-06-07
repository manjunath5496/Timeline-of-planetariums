function Lec18_animate(t,y)
% Function to animate the motion
qs = 3;
num = length(t);
hf1 = figure(1); set(hf1, 'Position',[10 100 900 400]); hold off; 
y= y/1000;  % Convert to km and km/sec
%pc = plot(y(1,1),y(1,2),'o','MarkerFaceColor','r','EraseMode','xor'); hold on
pc = plot(y(1,1),y(1,2),'o','MarkerFaceColor','r'); hold on
pq = quiver(y(1,1),y(1,2),y(1,3),y(1,4),qs);
xm = y(num,1)*1.01; ym = max(y(:,2))*1.01;
xlim([0 xm]); ylim([-ym*0.001 ym]);
xlabel('Distance (km)'); ylabel('Height(km)');
pt = text(xm/100,ym*0.96,'Time    0.00 s');
daspect([1 1 1]); drawnow;
for i = 1: num
    % Replace the data point
    %set(pc,'XData',y(i,1),'YData',y(i,2));
    col(1) = y(i,3)/y(1,3); col(2)=0; col(3) = 1-y(i,3)/y(1,3);
  
    delete(pc); pc = plot(y(i,1),y(i,2),'o','MarkerFaceColor',col);
    delete(pq); pq = quiver(y(i,1),y(i,2),y(i,3),y(i,4),qs);
    otext = sprintf('Time %6.1f s',t(i));
    set(pt,'String',otext);
    drawnow;
end
plot(y(:,1),y(:,2),'g');
hf2 = figure(2); set(hf2, 'Position',[910 100 350 200]);
hold off; pc = plot(y(:,1),y(:,2),'o','MarkerFaceColor','r','EraseMode','normal'); hold on
pq = quiver(y(:,1),y(:,2),y(:,3),y(:,4));
xlabel('Distance (km)'); ylabel('Height(km)'); daspect([1 1 1]);

hf3 = figure(3); set(hf3, 'Position',[910 300 350 200]);
semilogy(t,(sqrt(y(:,3).^2+y(:,4).^2))*1000);
xlabel('Time (sec)'); ylabel('Total Velocity (m/s)');
