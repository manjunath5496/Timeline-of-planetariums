% 12.540 Homework #1
% Use close all to clear all exisitng figures
%
%% Question 1:  Converions of lat and long
%{
Question 1: (a) Convert geodetic position 290 deg Long 42 deg latitude 
ellipsoidal height 0 m into Cartesian and geocentric coordinates.  
(b) How far apart on the surface of the Earth (approximate radius 6371km) 
would be locations that have geocentric latitude 42 deg and geodetic 
latitude 42 deg.  Give answer in km. 
(c) Using the conversion between XYZ and Geodetic coordinates, 
determine if ellipsoid heights are measured along a straight line.  
(Orthometric heights are measured along a curved path that is always along 
the local direction of gravity). (30 pts)
%}
geod_lat = 42.0*pi/180; % Radians (latitude)
geod_lng = 70.0*pi/180; % Radians (longitude)
geod_hgt = 0.0 ;        % meters (ellipsoidal heught).
% Convert to XYZ coordinate
[xyz,rot] = geod_to_xyz(geod_lat, geod_lng, geod_hgt) ; 
geoc_crd = xyz_to_llr(xyz);
% Compute the difference in latitude as arc length
dlat_km = (geod_lat-geoc_crd(1))*6371.00 ; % Distance in km
% Now output results
fprintf('++++++++++++++++++++++++++++++++++\n')
fprintf('12.540 HW 01 Question 1\n(a) Coordinates \n');
fprintf('GEODETIC Lat, Long, Height       %8.4f %8.4f deg   %13.4f m\n', ...
    geod_lat*180/pi, geod_lng*180/pi, geod_hgt)
fprintf('Cartesian XYZ coordinates   %13.4f %13.4f  %13.4f m\n', xyz)
fprintf('GEOCENTRIC Lat, Long, Radius     %8.4f %8.4f deg   %13.4f m\n', ...
    geoc_crd(1:2)*180/pi, geoc_crd(3) )
% Part (b) differce
fprintf('(b) Difference at latitude (%8.4f deg) %8.4f km\n', ...
    geod_lat*180/pi, dlat_km);

% Now make a figure of the differemce
glts = (-90:90)*pi/180; 
glgs = zeros(1,length(glts)); ghts = zeros(1,length(glts));
xyza = geod_to_xyz(glts, glgs, ghts);  
clata = atan(xyza(3,:)./(xyza(1,:).^2+xyza(2,:).^2).^(1/2));
dlata = (glts-clata)*6371.0;
h1 = figure(1); set(h1,'Name','Difference geod-geoc lat (km)');
plot(glts*180/pi,dlata,'k'); axis tight;
xlabel('Geodetic Latitude (deg)'); ylabel('Geodetoc-Geocentric Lat differnce (km)');
if ppr , print -dpsc2 HW01_Q1.ps; end
% Now Part (c):  The rot matrix returned from geod_to_xyx allow use to
% construct at perpendicuar from initial positon
dh = 1000;   % 100 meter height change
xyz_dh = xyz + (rot(3,:)*dh)'; % 
% Covert to geodetic lat long and height
[geod_dh, ni] = xyz_to_geod(xyz_dh); 
% Now output difference
fprintf('(c) Difference with height\n')
fprintf('For height change %10.4f m,\nDifference in lat %13.4e rad, height %13.4e m\n', ...
    dh, geod_dh(1)-geod_lat, dh-geod_dh(3));

fprintf('++++++++++++++++++++++++++++++++++\n')


%%


% Script M-file for 12.540 HW 01 Question 2:
%

%% Set Position of site
lat = 42.36*pi/180; long=288.90*pi/180; ht=0.0;
ppr = 1 ; % Set to zero not to have prints of figures make

%% Read in the MIT broadcast emphersis file.
% nav is the broadcast ephemeris structure, lp is difference between
% GPSTime and UTC, nr is number of records
fprintf('++++++++++++++++++++++++++++++++++\n')
navfile = 'mit0090s.10n';
[nav lp nr] = ReadNav(navfile);
fprintf('12.540 HW 01\nFound %d records in %s, GPST-UTC %d s\n', ...
    nr, navfile, lp);

% Set up times for calculations: Run 24-hours at 1 minute intervals
ts = (0:60:86400); num_ts = length(ts);
tdata = 14*3600; % Time after start of nav file our time is (14:00 GPST).  
% We will mark the satellite positions at this time.
its = find( ts == tdata ); 

% Color for plots (need to extend if more then 10)
c = ['k '; 'g '; 'b '; 'm '; 'r '; 'r:'; 'g:'; 'b:'; 'm:'; 'k:'];

%% Generate a sphere the size of the Earth
[Xeu, Yeu, Zeu] = sphere(20);
Xe = Xeu*6371.0; Ye = Yeu*6371.0; Ze = Zeu*6371; % Mean radius (2*a+b)/3

%% Q2.1(a): Generate Inertial coordinates
[prns IXYZ] = eph_to_xyz(nav,ts,'I');
% Now plot
h2 = figure; set(h2,'Name','Inertial coordinates'); clf; 
surface(Xe,Ye,Ze,abs(Ze)); shading interp;
hold on; 
for k = 1:nr; 
    plot3(IXYZ(1,:,k)/1000,IXYZ(2,:,k)/1000,IXYZ(3,:,k)/1000,c(k,:)); 
end
xlabel('X inertial (km)'); ylabel('Y inertial (km)'); zlabel('Z inertial (km)'); 
title('12.540 HW01: Q2.1(a)')
% Plot postions at tdata
for k = 1:nr
    plot3(IXYZ(1,its,k)/1000,IXYZ(2,its,k)/1000,IXYZ(3,its,k)/1000,'k*')
    lab = sprintf('PRN%2.2d',prns(k));
    text(IXYZ(1,its,k)/1000,IXYZ(2,its,k)/1000,IXYZ(3,its,k)/1000,lab);
end
daspect([1 1 1]); axis tight; grid on;
view(-115,20);
if ppr , print -dpsc2 HW01_Q21a.ps; end
hold off;

%% Q2.1(b): Generate Earth fixed coordinates
[prns EXYZ] = eph_to_xyz(nav,ts,'E');
% Now plot
h3 = figure; set(h3,'Name','Earth Fixed coordinates'); clf; 
surface(Xe,Ye,Ze,abs(Ze)); shading interp;
hold on; 
for k = 1:nr; 
    plot3(EXYZ(1,:,k)/1000,EXYZ(2,:,k)/1000,EXYZ(3,:,k)/1000,c(k,:)); 
end
xlabel('X Efixed (km)'); ylabel('Y Efixed (km)'); zlabel('Z Efixed (km)'); 
title('12.540 HW01: Q2.1(b)')
% Plot postions at tdata
for k = 1:nr
    plot3(EXYZ(1,its,k)/1000,EXYZ(2,its,k)/1000,EXYZ(3,its,k)/1000,'k*')
    lab = sprintf('PRN%2.2d',prns(k));
    text(EXYZ(1,its,k)/1000,EXYZ(2,its,k)/1000,EXYZ(3,its,k)/1000,lab);
end
daspect([1 1 1]); axis tight; grid on;
view(16,30);
if ppr , print -dpsc2 HW01_Q21b.ps; end
hold off;

%% Q2.2 Ground track
gtrk = xyz_to_llr(EXYZ); % Lat, Long (rads), dist
coasts = load('WorldVelV.xy');
h4 = figure; set(h4,'Name','Ground Track');
plot(coasts(:,1),coasts(:,2),'k'); hold on
xlim([0 360]); ylim([-90 90]); daspect([1 1 1]);
% For plotting with a line, put an NaN when the longitude wraps through
% 360
for k = 1:nr
    ind = find(gtrk(2,2:num_ts,k)-gtrk(2,1:num_ts-1,k) < 0);
    gtrk(2,ind+1,k) = NaN;
end
% Plot ground track

for k = 1:nr
    plot(gtrk(2,:,k)*180/pi,gtrk(1,:,k)*180/pi,c(k,:));
end
% Plot positions during data acquition
for k = 1:nr
    plot(gtrk(2,its,k)*180/pi,gtrk(1,its,k)*180/pi,'r*');
    lab = sprintf('PRN%2.2d',prns(k));
    text(gtrk(2,its,k)*180/pi,gtrk(1,its,k)*180/pi,lab);
end
xlabel('Longitude (deg)'); ylabel('Latitude (deg)');
title('12.540 HW01: Q2.2')
if ppr , print -dpsc2 HW01_Q22.ps; end
hold off;

%% Q2.3 Azimuth/Zenith Distance plot
azzd = xyz_to_azzd(EXYZ,lat,long,ht);
% Now set all zenith distances greater than pi/2 to NaN so they will not
% plot
ind = find(azzd(2,:,:)>pi/2);
azzd(2,ind) = NaN;
% Now generate the polar plot
h5 = figure; set(h5,'Name','Azimuth/Zenith Distance');clf; 
for k = 1:nr
    polar(azzd(1,:,k),azzd(2,:,k)*180/pi,c(k,:));
    if k == 1 , hold on; end
end
% Now plot our data locations
for k = 1:nr
    polar(azzd(1,its,k),azzd(2,its,k)*180/pi,'r*')
    lab = sprintf('PRN%2.2d',prns(k));
    % Compute coordinates where label needs to go
    xl = azzd(2,its,k)*180/pi*cos(azzd(1,its,k))+5;
    yl = azzd(2,its,k)*180/pi*sin(azzd(1,its,k));
    text(xl,yl,lab);
end
%axis tight;
title('12.540 HW01: Q2.3');
view(+90,-90)
if ppr , print -dpsc2 HW01_Q23.ps; end
hold off;

    
    
    
    









