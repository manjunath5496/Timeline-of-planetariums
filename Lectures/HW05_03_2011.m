% 12.010 HW 05 Q 3: Bike simulator
%
% This script m-file simulates the motions of a paper plane being
% influenced by gravity, lift and drag
%
% There are many ways to solve this problem and we will use the Matlab ODE
% solvers with event detection (the event in this case is the z-value
% hitting zero).
%
global Grav Rho Mass Cd Cr Area Slope As Bs Lambda Pr Fr_Max TLength terr % Define these globals so that they will be accessible in the acceleration routine

Grav = -9.8  ;   % m/sec^2
Rho  = 1.226;  % kg/m^3
%----- Get the inout that we need -----
prompt = {'Track Grade (m/m)', 'Track Asin (m)', 'Track Bcos (m)', 'Wavelegth (km)','Track Length (km)','Mass (kg)', ...
	'Rider Area (m^2)', 'Drag Coefficient','Rolling coefficient','Power (watts)','Max Force (N)', ...
    'Output Interval (sec)','Error (mm)'};
title = 'Track and Bike Parameters';
nlines = 1;
defaults = {'0.001','5.0','0.0','2.0','10.0','80.0','0.67','0.9','0.007','100.0','20','100','1'};
% Get user inputs and save in the appropriate valuyes
result = inputdlg(prompt,title,nlines, defaults,'on');
%
Slope   = eval(result{1});
As      = eval(result{2});
Bs      = eval(result{3});
Lambda  = eval(result{4})*1000.0 ;  % Convert to meters
TLength = eval(result{5})*1000.0 ;   % Convert to meters
Mass      = eval(result{6}) ;
Area      = eval(result{7}) ;
Cd        = eval(result{8}) ;
Cr        = eval(result{9}) ;
Pr        = eval(result{10}) ;
Fr_Max    = eval(result{11}) ;
tstep     = eval(result{12}) ;
terr      = eval(result{13})/1000 ;   % convert height error to m
%
% Set the ODE options.  hit is the name of an m-file which will detect when
% we hit the ground.
options = odeset('AbsTol',[terr terr terr terr 100],'Events','bikehit');

% Set up the initial conditions
y0 = [0.0; Bs ; 0.0 ; 0.0; 0.0];
% Set the maximum integration time to 5000 seconds. In a more general
% problem we should check to see of this is enough time
tmax = 5000;
% Solve the ODE 
fprintf('\n Starting new run \n');
[t,y,te,ye,ie] = ode45(@bikeacc,[0:tstep:tmax],y0,options);
%
% Output the final results
fprintf('---------------------------------------------------------------------\n');
fprintf('12.010 HW 05 Q 3: Bike simulation\n');

% Output table of values
fprintf('---------------------------------------------------------------------\n')
fprintf('    Time         X pos      Z pos      X Vel      Z Vel      Energy \n')
fprintf('   (sec)          (m)        (m)       (m/s)      (m/s)     (Joules)\n')
fprintf(' %9.3f %12.4f %10.4f %10.4f %10.4f %12.2f\n',[t,y(:,1:5)]');
fprintf('---------------------------------------------------------------------\n')
fprintf('Time : %8.3f, Velocity %6.4f %6.4f \n',te,ye(3),ye(4))
fprintf('Energy used: %12.2f Joules, %8.2f kcals\n', ye(5), ye(5)*0.2388e-3);

% Now animate (make as function)
%banimate(t,y);
% Re-run the solution for the animation 
[ta,ya,tae,yae,iae] = ode45(@bikeacc,[0:10.0:te],y0,options);

fprintf('\nTo show animation: banimate(ta,ya)\n');
%

