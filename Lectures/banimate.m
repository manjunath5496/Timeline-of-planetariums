function banimate(t,y)
% Function to animate the motion
qs = 50;
num = length(t);
hf1 = figure(1); set(hf1, 'Position',[10 100 750 400]); hold off; 
pc = plot(y(1,1),y(1,2),'o','MarkerFaceColor','r','EraseMode','xor'); hold on
pq = quiver(y(1,1),y(1,2),y(1,3),y(1,4),0);
xm = y(num,1)*1.01; ym = max(y(:,2))*1.01;
xs = min(y(:,1))*1.01; ys = min(y(:,2))*1.01;
xlim([xs xm]); ylim([ys ym]);
xlabel('Distance (m)'); ylabel('Height (m)');
pt = text(xm/100,ym*0.96,'Time    0.00 s');
%daspect([1 1 1]);
drawnow;
% Release 2011a of Matlab has some strange scaling in quiver and so we
% manually set properities that should be automatically set.  Also arrow
% heads are very wide so we turn them off here.
for i = 1: num
    % Replace the data point
    set(pc,'XData',y(i,1),'YData',y(i,2));
    delete(pq); pq = quiver(y(i,1),y(i,2),y(i,3),y(i,4),qs);
    set(pq,'ShowArrowHead','off','AutoScaleFactor',qs,'AutoScale','on');
    otext = sprintf('Time %6.1f s',t(i));
    set(pt,'String',otext);
    drawnow;
end
plot(y(:,1),y(:,2),'g');
%%
hf2 = figure(2);  set(hf2, 'Position',[760 100 350 200]);
hold off; pc = plot(y(:,1),y(:,2),'o','MarkerFaceColor','r','EraseMode','normal'); hold on
pq = quiver(y(:,1),y(:,2),y(:,3),y(:,4)); set(pq,'ShowArrowHead','off');
xlabel('Distance (m)'); ylabel('Height (m)'); axis tight; ylim([-10 15]);
%%
hf3 = figure(3); set(hf3, 'Position',[760 380 350 200]);
plot(t,(sqrt(y(:,3).^2+y(:,4).^2)));
xlabel('Time (sec)'); ylabel('Total Velocity (m/s)');
