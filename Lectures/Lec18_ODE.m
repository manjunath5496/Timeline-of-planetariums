% DEMO of using Matlab ODE solvers
%
% This script m-file solves for the initial velocity needed for a pojectile
% to hit a target a specified distance from the lauch point.  The program
% includes air drag and height dependent gravity.  
%
% There are many ways to solve this problem and we will use the Matlab ODE
% solvers with event detection (the event in this case is the z-value
% hitting zero).
%
global targdist g0 dgdh rho0 scaleht mass xarea cd
g0 = -9.806;   % m/sec^2
rho0 = 1.29;  % kg/m^3
%----- Get the inout that we need -----
prompt = {'Distance (km)', 'Error (m)', 'Launch Angle (deg)', 'Mass (kg)', ...
	'CrossSection Area (m^2)', 'Drag Coefficient', ...
	'AirScale height (m)', 'dg/ht (m/sec^2)/m'};
title = 'Ballistic Trajectory Parameters';
nlines = 1;
defaults = {'100','1','45','500','0.01','0.1','7500.e6', '3.0786e-6'};
% Get user inputs and save in the appropriate valuyes
result = inputdlg(prompt,title,nlines, defaults,'on');
%
targdist = eval(result{1})*1000.0;
terr     = eval(result{2});
ltheta   = eval(result{3})*pi/180;
mass     = eval(result{4}) ;
xarea    = eval(result{5}) ;
cd       = eval(result{6}) ;
scaleht  = eval(result{7}) ;
dgdh     = eval(result{8}) ;
%
% Based on no-drag, no dght get initial velocity
vx = sqrt(-targdist*g0/(2*tan(ltheta)));
vz = vx*tan(ltheta);
vtot = vx/cos(ltheta);
dvxdD = sqrt(-g0/(2*tan(ltheta)*targdist))/2;
dvdD = dvxdD/cos(ltheta);
tmax = targdist/vx*2*(1+cd);

% Set the ODE options
options = odeset('AbsTol',[terr 1 1 1],'Events','Lec18_hit');

%%% Loop until target distance is hit
done = 0; prevDD = 0; iter = 0;
while done == 0
%   Set the initial conditions for the ODE
    iter = iter + 1;
    y0 = [0.0; 0.0; vx; vz];
    [t,y,te,ye,ie] = ode23(@Lec18_bacc,[0:1:tmax],y0,options);
    % Check the time 
    if te/tmax > 0.5 , tmax = 2*te; end
    % See how close we got to target
    dd = targdist - ye(1);
    fprintf('Result te %f ye %f dd %f \n',te, ye(1), dd);
    if abs(dd) < terr 
        done = 1;   % We are finished
    else
        % Adjust the initial velocity.  Initially we use the analytic value
        % for the directivative but this updated once we start
        if prevDD == 0
            vtot = vtot + dvdD*dd;
            prevDD = dd;
        else
            dvdD = dvdD*(1+dd/prevDD);
            vtot = vtot + dvdD*dd;
        end
        vx = vtot*cos(ltheta); vz = vtot*sin(ltheta);
    end
    if vtot > 3.e8 
        fprintf('\nVelocity faster than speed of light!\n')
        done = 1;
    end

end
%
% Output the final results
fprintf('TARGET DISTANCE: %8.3f km, within %6.1f m, Launch Angle %6.3f deg\n', ...
    targdist/1000, terr, ltheta*180/pi)
fprintf('MASS %7.1f kg, XArea %7.4f m**2, Drag Coefficient %7.3f\n', ...
    mass, xarea, cd)
fprintf('GRAVITY %8.5f m/s**2 %11.4e (m/sec**2)/m\n', ...
    g0, dgdh)
fprintf('RHO AIR %8.5f kg/m**3, Scale Height %11.5e m\n', ...
    rho0, scaleht)

fprintf('Initial Velocity needed %8.3f n/s\n',vtot)
fprintf('Calculation took %d iterations with final error %8.2f m\n',iter,dd)

% Now animate (make as function)
Lec18_animate(t,y);
fprintf('To show animation: animate(t,y)\n');
%

