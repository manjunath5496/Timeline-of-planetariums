% Script M-file to process Sextant Data
%
% See if S is loaded
try size(S);
catch
     fprintf('Loading Data\n')
     %!tr '\r' '\n' < Sextant_041013.txt | tail +2 >! S.in
     S = load('Sextant_061025.txt');
     Times = S(:,1)+S(:,2)/60+S(:,3)/3600;
     DbleEl = S(:,4)+S(:,5)/60.;
     % These data are collected on Oct 25, 2006 between 11-13 hrs ESummer
     % time.  This is +4 hours of Greenhich sp 15-17 UT (values from
     % Nautical Almanac.
     SunEph= [15 48 58.7 -12 -11.4 ; 16 63 58.8 -12 -12.2 ; 17 78 58.9 -12 -13.1];
     SunTime = SunEph(:,1); SunGHA = SunEph(:,2)+SunEph(:,3)/60; SunDec = SunEph(:,4)+SunEph(:,5)/60.;
     % GHAFit and DecFit can be used in polyval as gha = polyval(GHAFit,t);
     GHAFit = polyfit(SunTime,SunGHA,1); DecFit =  polyfit(SunTime,SunDec,1);
end
%
% Now plot the data:
figure(1); hold off
plot(Times,DbleEl,'or'); hold on
xlabel('Time (Easter Summer Time, hrs)'); ylabel('Double Elev Sun (deg)');

% Fit a quadratic
delfit = polyfit(Times,DbleEl,2);
plot([11.4:0.1:13.5],polyval(delfit,[11.4:0.1:13.5]),'b');
% Comput time of max
Tmax = -delfit(2)/(2*delfit(1));
DEmax = polyval(delfit,Tmax);
plot([Tmax Tmax NaN Tmax-0.2 Tmax+0.2],[DEmax+0.5 DEmax-0.5 NaN DEmax DEmax],'k')
maxstr = sprintf('Max Time %6.3f Val %6.2f',Tmax, DEmax);
text(12,74.2,maxstr);
% Solve the forward problem using the GPS position estimates
GPSlong = 71.0894; GPSlat = 42.3597;
% Compute meridian crossing (Remove 4hrs for EST to UT)
TXing = (GPSlong-GHAFit(2))/GHAFit(1) - 4.0;
ThEl =  asin(sin(GPSlat*pi/180)*sin(polyval(DecFit,Times+4)*pi/180) + ...
    cos(GPSlat*pi/180)*cos(polyval(DecFit,Times+4)*pi/180).*cos((Times-TXing)*GHAFit(1)*pi/180))*180/pi;
ThDblEl = 2*ThEl;
plot(Times, ThDblEl,'r');

%
% get position:  Longitude GHA of Sun at Max:
Index_data = [-6.2 -7.5 -7.8 ]; % Minutes of arc
Index_err = mean(Index_data)/60 ;   % Index error in instrument
Index_rms = std(Index_data)/60;   % standard deviation
fprintf('\nSextant Results: Calibrations\n');
fprintf('Mean Index Error %5.1f mins RMS %5.1f mins\n',Index_err*60, Index_rms*60);

% Get Max elevation
max_elev = (DEmax-Index_err)/2; 
fprintf('Max elev: %6.2f deg index error corrected\n', max_elev);

% Compute the expected refraction contribution
atm = (1/60)/(tan((DEmax/2*pi/180)+0.028));  % refraction will increased obs value

% Output final corrected elevation angle
fprintf('Max elev: %6.2f deg index error and atm corrected\n', max_elev-atm);
dt_EDT_UT = 4.0 ;  % Time offset for EDT to Greenwich
Long = polyval(GHAFit,Tmax+dt_EDT_UT);
Lat = 90 - (max_elev-atm) + polyval(DecFit,Tmax+dt_EDT_UT); 
fprintf('Declination of Sun: %6.2f\n',polyval(DecFit,Tmax+dt_EDT_UT));
%
% Get residuals
res = DbleEl - polyval(delfit,Times); rms = std(res);
resstr = sprintf('RMS scatter %6.3f minutes',rms*60);
figure(2); hold off;
plot(Times,res*60,'or-', Times,DbleEl-mean(DbleEl),'+b'); hold on;
plot(Times,(DbleEl-ThDblEl)*60,'*k:')
xlabel('Time (Easter Summer Time, hrs)'); ylabel('Residual (mins)');
legend('Polyfit Residual','demeaned Data/60','GPS Theory Residual');
text(11.3,-4.8,resstr);

%Now write results
fprintf('\nRESULTS\nMax Time %6.3f Val %6.2f deg, RMS %3.1f min\n',Tmax, DEmax,rms*60);
fprintf('Index Error %4.1f min, Refraction %4.1f min\n',Index_err*60, atm*60);
fprintf('Sextnt Longitude %6.3f deg Latitude %6.3f deg\n', Long, Lat)
fprintf('GPS    Longitude %6.3f deg Latitude %6.3f deg\n', GPSlong, GPSlat)
dpos = sqrt(((Lat-GPSlat)*pi/180)^2 + ((Long-GPSlong)*cos(Lat*pi/180))^2)*pi/180*6783;
fprintf('Diff   Longitude %6.1f min Latitude %6.1f min, Distance %5.1f km\n', ...
    (Long-GPSlong)*60, (Lat-GPSlat)*60,dpos)
fprintf('\nStatistics to GPS Mean %4.2f min RMS %3.1f min\n',mean(DbleEl-ThDblEl)*60, std(DbleEl-ThDblEl)*60);



