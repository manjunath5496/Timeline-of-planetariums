%% Examples below are based on examples from
% Mastering MATLAB 7
% Duane Hanselman and 
% Bruce Littlefield
% 
% Pearson/Prentice Hall, 2005
% 852 Pages
% www.prenhall.com
% Tel: 800-947-7700;
% Fax: 515-284-2607
% Outside the USA
% Tel: 201-767-4990;
% Fax: 201-767-5625

% ISBN 0-13-143018-1

% http://www.eece.maine.edu/mm/mm7.html


%% mm2701.m
t = linspace(0,10*pi);
figure(1); clf; 
plot3(sin(t),cos(t),t)
xlabel('sin(t)'), ylabel('cos(t)'), zlabel('t')
text(0,0,0,'Origin')
grid on
title('Lec 19.1: Helix')
v = axis;
figure(1);

%% mm2704.m
figure(2); clf; 
[X,Y,Z] = peaks(30); % 30x30 version of Gassians
mesh(X,Y,Z)
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
colorbar;daspect([1 1 2.5]);
title('Lec 19.2: Mesh Plot of Peaks')
figure(2);

%% mm2705.m
figure(3); clf ;
[X,Y,Z]=sphere(12);
subplot(1,2,1)
mesh(X,Y,Z), title('Lec 3a: Opaque')
hidden on
axis square off
subplot(1,2,2)
mesh(X,Y,Z), title('Lec 3b: Transparent')
hidden off
axis square off
figure(3);

%%  mm2706.m
figure(4); clf; 
[X,Y,Z] = peaks(30);
meshc(X,Y,Z)  % mesh plot with underlying contour plot
title('Lec 19.4: Mesh Plot with Contours')
figure(4);

%%
figure(5); clf; 
[X,Y,Z] = peaks(30);
surf(X,Y,Z)
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Lec 19.5: Surface Plot of Peaks')
figure(5);

%%
figure(6); clf; 
[X,Y,Z] = peaks(30);
surf(X,Y,Z)  % same plot as above
shading flat
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Lec 19.6: Surface Plot with Flat Shading')
figure(6);
%%
figure(7); clf; 
[X,Y,Z] = peaks(30);
surf(X,Y,Z)  % same plot as above
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
shading interp
title('Lec 19.7: Surface Plot with Interpolated Shading')
figure(7);
%%
figure(8); clf; 
[X,Y,Z] = peaks(30);
surfl(X,Y,Z)    % surf plot with lighting
shading interp  % surfl plots look best with interp shading
colormap pink   % they also look better with shades of a single color
colorbar;       % Add color bar
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Lec 19.8: Surface Plot with Lighting')
%%
figure(9); clf; 
[X,Y,Z] = peaks(15);
surfnorm(X,Y,Z)
xlabel('X-axis'), ylabel('Y-axis'), zlabel('Z-axis')
title('Lec19.9: Surface Plot with Normals')
figure(9); 

%%
figure(10); clf; 
N = 100; % Use 100-random locations (not so random because we seed)
rand('twister',0)
x = 2*(rand(N,1)-0.5)*pi; y = 2*(rand(N,1)-0.5)*pi; 
z = peaks(x,y);
ti = -pi:.25:pi; 
[xi,yi] = meshgrid(ti,ti);
zi = griddata(x,y,z,xi,yi);
surf(xi,yi,zi), hold on, plot3(x,y,z,'o'), hold off
title('Lec 19.10: Meshed data using gridddata')

%% Repeat above figure with trimesh
figure(11); clf; 
N = 100; % Use 100-random locations (not so random because we seed)
rand('twister',0)
x = 2*(rand(N,1)-0.5)*pi; y = 2*(rand(N,1)-0.5)*pi; 
z = peaks(x,y);
t = delaunay(x,y);
trisurf(t,x,y,z)
hold on, plot3(x,y,z,'o'), hold off
hidden off
title('Lec 19.11: Triangular Mesh Plot')
figure(11);
%% 3-D slices 
figure(12); clf; 
x=linspace(-3,3,13);
y=1:20;
z=-5:5;
[X,Y,Z]=meshgrid(x,y,z);
V=sqrt(X.^2 + cos(Y).^2 + Z.^2);
slice(X,Y,Z,V,[0 3],[5 15],[-3 5])
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Lec 19.12: Slice Plot Through a Volume')
colorbar; 
figure(12);

%% 3-D volumn slice now with contour
figure(13); clf; 
x=linspace(-3,3,13);
y=1:20;
z=-5:5;
[X,Y,Z]=meshgrid(x,y,z);
V=sqrt(X.^2 + cos(Y).^2 + Z.^2);
slice(X,Y,Z,V,[0 3],[5 15],[-3 5])
hold on
h=contourslice(X,Y,Z,V,3,[5 15],[]);
set(h,'EdgeColor','k','Linewidth',1.5)
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Lec 19.13: Slice Plot with Selected Contours')
colorbar; 
hold off
figure(13);

%% Slice along an oscillating surface
figure(14); clf;
x=linspace(-3,3,13);
y=1:20;
z=-5:5;
[X,Y,Z]=meshgrid(x,y,z);
V=sqrt(X.^2 + cos(Y).^2 + Z.^2);
[xs,ys]=meshgrid(x,y);
zs=5*sin(xs-ys/2);
slice(X,Y,Z,V,xs,ys,zs)
xlabel('X-axis')
ylabel('Y-axis')
zlabel('Z-axis')
title('Lec 19.14: Slice Plot Using a Surface')
colorbar; 
figure(14);

%%
figure(15); clf;
p = patch(isosurface(X,Y,Z,V,2), ...
     'FaceColor','Blue','EdgeColor','none');
% patch(isocaps(X,Y,Z,V,2), ...
%     'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(X,Y,Z,V,p)
view(3); axis vis3d tight off
camlight; lighting phong
title('Lec 19.15: Isosurface: Lebel 2')
figure(15);

%%
figure(16); clf;
p = patch(isosurface(X,Y,Z,V,2), ...
     'FaceColor','Blue','EdgeColor','none');
patch(isocaps(X,Y,Z,V,2), ...
     'FaceColor', 'interp', 'EdgeColor', 'none');
isonormals(X,Y,Z,V,p)
view(3); axis vis3d tight off % Freeze aspect ratio
camlight left; lighting phong
title('Lec 19.16: Isosurface: Level 2 with materical outside')
figure(16);

%%
figure(17); clf; 
[x y z v] = flow;
p = patch(isosurface(x, y, z, v, -3));
isonormals(x,y,z,v, p)
set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
daspect([1 1 1])
view(3)
camlight; lighting phong
title('Lec 19.17: Flow example level -3');
figure(17);

%% figure 18:
figure(18) ; clf; 
[x y z v] = flow;
q = z./x.*y.^3;
p = patch(isosurface(x, y, z, q, -.08, v));
isonormals(x,y,z,q, p)
set(p, 'FaceColor', 'interp', 'EdgeColor', 'none');
daspect([1 1 1]); axis tight; 
colormap(prism(28))
camup([1 0 0 ]); campos([25 -55 5]) 
camlight; lighting phong
title('Lec 19.18: Flow with cut away view');
colorbar;
figure(18);


        

