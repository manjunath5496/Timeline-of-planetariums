% First-Order Gauss Markov process simulation
%
clear all;
tau = 30;    % 30-day correlation
var = 3;     % Variances of 3-mm^2
wns  = 1;    % 1-mm of white noise
num = 3650;  % Equivalent of 10-years of data
%
% Generate the time series
ts = zeros(num,1);
dt = 1  ;   % 1-day sapcing of values
tt = [1:num]*dt ;  % Times of values
% Generate an intial value
y = randn*wns + randn*sqrt(var);
sigfog = sqrt(2*var*(1-exp(-dt/tau)));
decay = exp(-1/tau);
for t = 1:num
    wn = randn*wns;
    y = y*decay + sigfog*randn;
    ts(t) = y + wn ;
end
%
% Now plot results
subplot(211);
plot(tt/365,ts);
ttext = sprintf('FOGM: Tau %10.2f Var %6.2f White Noise %6.2f',tau,var, wns);
title(ttext); xlabel('Time Years'); ylabel('Position (mm)');
%
% Compute the Power Spectral Density (could do a lot of playing here)
[Pxx,F] = psd(ts,1024,2/dt);
subplot(212);
loglog(F,Pxx); xlabel('Frequency (cpd)'); ylabel('Power');


    
    