% 12.540 Homework number 2:

%% Start output of homework and generate radom number seed.
%
fprintf('\n----------------------------------------\n');
fprintf('12.540 Homework number 2\n');
clear all;
randn('state',10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 1:
% Non-linear and linear estimation for a periodic signal
% Generate data set first
nt = 30;
times = (0:nt-1);
ac = 10; as = -5; off = 2.0; per = 15;
yo = ac*cos(times/per*(2*pi))+as*sin(times/per*(2*pi))+off+randn(1,30);
% truncate y to two-significant digits
y = round(yo*100)/100;

% Output the data
fprintf('Q1: Data set \n    Time       Data    +-\n');
for k = 1:nt
    fprintf(' %8.1f  %8.2f   1.00  %8.2f  \n',times(k),y(k), yo(k));
end
%
%% Now do the non-linear estimate
% Form is A*cos(T+phi) where phi is phase
A0 = 1; phi0 = 0; off0 = 0.0;
err = 1.0; tol = 0.01^2; % The tolerance will be 1% sigma
iter = 0;
while  err > tol && iter < 10
    % Compute non-linear model
    iter = iter + 1;
    y0 = A0*cos(times/per*2*pi+phi0)+off0;
    dy = y-y0;
    % Partial derivative matrix
    An = [cos(times/per*2*pi+phi0) ; -A0*sin(times/per*2*pi+phi0) ; ones(30,1)']';
    % Standard Least square solution (covariance matrix is a unit matrix).
    Nn = An'*An; Cn = inv(Nn);
    Sn = Cn*An'*dy';
    % Update the parameter values 
    A0 = A0 + Sn(1); phi0 = phi0 + Sn(2); off0 = off0 + Sn(3);
    % Compute size of update.
    err= sum(Sn.^2./diag(Cn));
    fprintf('\nQ 1(a): Iteration %3d Error %9.3e\n',iter, err)
    fprintf('Ampl   %8.2f dA %8.5f +- %8.2f \n',A0  , Sn(1), sqrt(Cn(1,1)));
    fprintf('Phase  %8.4f dP %8.5f +- %8.4f \n',phi0, Sn(2), sqrt(Cn(2,2)))
    fprintf('Offset %8.2f dO %8.5f +- %8.2f \n',off0, Sn(3), sqrt(Cn(3,3)))

end
%% Now get the sigmas for Ac and As
Acn = A0*cos(phi0); Asn = -A0*sin(phi0);
% Linear operator between Ac As and amplitude and phase.
Atr = [cos(phi0) -A0*sin(phi0) ; ...
    -sin(phi0) -A0*cos(phi0)]; 
% Covariance matrix of amplitude and phase from LSQ solution
Cap = Cn(1:2,1:2);
% Propagation of covariance matrix 
Cc = Atr*Cap*Atr';

fprintf('Cosine %8.2f +- %8.2f\n',Acn, sqrt(Cc(1,1)))
fprintf('Sine   %8.2f +- %8.2f\n',Asn, sqrt(Cc(2,2)))
  
%% Now set up solutions
% Linear first
Ap = [ones(30,1)' ; cos(times/per*2*pi) ; sin(times/per*2*pi)]';
Np = Ap'*Ap; % Now weight matrix needed because sigmas are all unity
Cp = inv(Np);
Sp = Cp*Ap'*y';
% Output solution
fprintf('Q 1(b): Linear estimates\n')
fprintf('Offset %8.2f +- %8.2f\n',Sp(1), sqrt(Cp(1,1)))
fprintf('Cosine %8.2f +- %8.2f\n',Sp(2), sqrt(Cp(2,2)))
fprintf('Sine   %8.2f +- %8.2f\n',Sp(3), sqrt(Cp(3,3)))

%% Now compute amplitude and phase
Ae = sqrt(Sp(2)^2+Sp(3)^2); phie = atan2(-Sp(3),Sp(2));
% Compute the variance covariance matrix for amplitude and phase
Ccs = Cp(2:3,2:3);
Apt = [Sp(2)/Ae Sp(3)/Ae ; ...
    -Sp(3)/Ae^2 Sp(2)/Ae^2];
Ca = Apt*Ccs*Apt';
fprintf('Q 1(c): Linear estimates transformed to amplitude and phase\n')
fprintf('Amplitude  %8.2f +- %8.2f\n',Ae,sqrt(Ca(1,1)));
fprintf('Phase      %8.4f +- %8.4f rad\n',phie,sqrt(Ca(2,2)));

%% Finally get estimates by FFT
Zt = fft(y);
% Use 2/nt for folding negative frequency and Matlab normalization.
Cft = 2*real(Zt(3))/nt; Sft = -2*imag(Zt(3))/nt ; 
fprintf('Q 1(d): FFT Estimates, Linear and Non-linear estimates\n');
fprintf('Cosine: FFT  %9.6f Lin %9.6f NonL %9.6f\n',Cft, Sp(2), Acn)
fprintf('Sine  : FFT  %9.6f Lin %9.6f NonL %9.6f\n',Sft, Sp(3), Asn)

% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2:
% Simple least squares fitting
%
% Generate a random data set.  
val = zeros(10,1); sig=zeros(10,1);
fprintf('\n----------------------------------------\n');
fprintf('Question 2:\n    X      Y      +- \n')
for k = 1:10
    sigo(k) = 0.1*randn+1; sig(k) = round(sigo(k)*1000)/1000;
    valo(k) = 10 - 6*k + 1.5*sig(k)*randn;
    val(k) = round(valo(k)*1000)/1000;
    
    fprintf(1,' %4d  %7.3f  %6.3f\n', k, val(k), sig(k));
end
%
% Now do LSQ
% 1.a: Standard least least squares solution.
A = [ones(10,1) (1:10)'];  % Observation matrix
W = 1./sig.^2;             % Weight matrix
% Form A'W
atw = zeros(10,2);
for k = 1:2
    atw(:,k) = A(:,k).*W;
end
atw = atw';
% Form normal eqautions
neq = atw*A; b = atw*val;
sol = inv(neq)*b; cov = inv(neq);
% Form the prefit chi**2
prefchi = (val.*W)'*val;
%
fprintf('Q 2 (a) : Estimates:\n');
fprintf('Offset %6.2f +- %6.2f\n',sol(1),sqrt(cov(1,1)));
fprintf('Rate   %6.2f +- %6.2f\n',sol(2),sqrt(cov(2,2)));

% 1.b: Determine chi**2/f for the fit.  Two methods can be used
% (a) Compute the postfit residuals and form chi**2
% (b) Base chi**2 on the prefit chi**2 and estimated parameters.
%
% Method (a): Form the postfit residuals
res = val - A*sol;
postchi = (res.*W)'*res;
%
% Now get estimate from prefit chi**2
postchi_pref = prefchi - sol'*b;
%
fprintf('\nQ 2 (b): Chi**2/f\n');
fprintf('Chi**2/f from postfit residuals %10.4f for 8 dof\n',postchi/(10-2));
fprintf('Chi**2/f from prefit  residuals %10.4f for 8 dof\n',postchi_pref/(10-2));
% Add a test: Form the covariance matrix of the postfit residuals:
Vd = zeros(10,10); for i=1:10; Vd(i,i)=sig(i)^2; end
Vdi = inv(Vd);
Vp = Vd - A*inv(A'*Vdi*A)*A';
% Scale Vp diagonal to make more stable
for i = 1:10; Vp(i,i)=Vp(i,i)*(1+1.e-6); end
Vpi = inv(Vp); chigen = res'*Vpi*res;
%
% The cumulative chi**2 distrubution is gammainc(c/2,r/2) where the
% 2-argument gamma functionis the incomplete gamma function, r is the
% degrees of freedom (8 in the case) and c is chi**2.
% See http://mathworld.wolfram.com/Chi-SquaredDisribution.html
r = 8; c = postchi;
Prob = 1-gammainc(c/2,r/2);
fprintf('Probability that chi**2 would be greater than this due to random error: %8.4f %%\n',Prob*100);
%
% Q 1 (c) Sequential estimation:
% Divide the data into two parts:
% Form A'W for 1:5
atws = zeros(5,2);
for k = 1:2
    atws(:,k) = A(1:5,k).*W(1:5);
end
atws = atws';
% Form normal eqautions
neq = atws*A(1:5,:); b = atws*val(1:5);
sol1 = inv(neq)*b; cov1 = inv(neq);
fprintf('\nQ 2 (c) : Estimates for data 1-5:\n');
fprintf('Offset %6.2f +- %6.2f\n',sol1(1),sqrt(cov1(1,1)));
fprintf('Rate   %6.2f +- %6.2f\n',sol1(2),sqrt(cov1(2,2)));

% Form A'W for 6:10
clear atws
for k = 1:2
    atws(:,k) = A(6:10,k).*W(6:10);
end
atws = atws';
% Form normal eqautions
neq = atws*A(6:10,:); b = atws*val(6:10);
sol2 = inv(neq)*b; cov2 = inv(neq);
fprintf('Q 2 (c) : Estimates for data 6-10:\n');
fprintf('Offset %6.2f +- %6.2f\n',sol2(1),sqrt(cov2(1,1)));
fprintf('Rate   %6.2f +- %6.2f\n',sol2(2),sqrt(cov2(2,2)));
%
% We now have the two sets of estimates and there covariance matrices
% So now do the normal LSQ estimation
zerocov = [ 0 0; 0 0 ];
seqdat = [sol1; sol2]; seqcov = [cov1 zerocov ; zerocov cov2];
Ws = inv(seqcov);
% Observations equations:
As = [ 1 0 ; 0 1 ; 1 0; 0 1];
% Form the combined normal equations
neqs = As'*Ws*As; bs = As'*Ws*seqdat;
covs = inv(neqs); sols = covs*bs;
fprintf('\nQ 2 (c) : Estimates from combined data:\n');
fprintf('Offset %6.2f +- %6.2f\n',sols(1),sqrt(covs(1,1)));
fprintf('Rate   %6.2f +- %6.2f\n',sols(2),sqrt(covs(2,2)));
fprintf('Differences from 1(a): %10.4e %10.4e\n',sol-sols);

% Q2.d: Time shited and Weighted mean
% Form uncorrelated parameters by shifting the time argument by dT
dT = -cov(1,2)/cov(2,2);
Au = zeros(length(A(:,1)),2);
for i = 1: length(A(:,1))
    Au(i,:) = A(i,:) - [0 dT];               % New parameter type partials
end
% Form Ai'W
clear atw
for k = 1:2
    atw(:,k) = Au(:,k).*W;
end
atw = atw';
% Form normal eqautions
neq = atw*Au; b = atw*val;
% Estmates of the "independent parameters"
solu = inv(neq)*b; covu = inv(neq);
%
fprintf('Q 2 (d) : Estimates of uncorrelated parameters by shifting time %10.4f:\n',dT);
fprintf('Offset-shift %6.4f +- %6.4f\n',solu(1),sqrt(covu(1,1)));
fprintf('Rate-shift   %6.4f +- %6.4f\n',solu(2),sqrt(covu(2,2)));
fprintf('Covariance  %10.4e\n',covu(1,2));

% Question 1 (e): Find the wighted mean of the data
Wmean = sum(val.*W)/sum(W); sigWM = sqrt(1/sum(W));
fprintf('Q 2 (d): Weighted Mean %10.4f +- %10.4f\n',Wmean, sigWM);
fprintf('Compare with Offset-shift above\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3: Differencing
% Model y(t) = A*cos(x) + c(t);
% Generate some data
clear A
val = zeros(30,1); Xv = zeros(30,1); ttrue = zeros(10,1);
fprintf('\n----------------------------------------\n');
fprintf('Question 3: Differencing example question\n')
fprintf('     T        X             Y      +-\n')
for t = 1:10
    tval = 20*randn;
    x1 = 1+t/10; x2 = .5-.2*t; x3 = -0.2+(t/10)^2;
    y1 = fix((10*sin(x1) + tval + randn)*10000)/10000;
    y2 = fix((10*sin(x2) + tval + randn)*10000)/10000;
    y3 = fix((10*sin(x3) + tval + randn)*10000)/10000;
    fprintf('  %4d  %10.4f   %10.4f  1.00\n',t,x1,y1);
    fprintf('  %4d  %10.4f   %10.4f  1.00\n',t,x2,y2);
    fprintf('  %4d  %10.4f   %10.4f  1.00\n',t,x3,y3);
    % Save the "data"
    val((t-1)*3+1) = y1; val((t-1)*3+2) = y2; val((t-1)*3+3) = y3;
    Xv((t-1)*3+1) = x1; Xv((t-1)*3+2) = x2; Xv((t-1)*3+3) = x3;
    ttrue(t) = tval;
end

%% Solution
% Question 3: Example of using differenced data
% Using the data below:
% (a) Estimate A given the model that y(t) = A*sin(X)+C(t) 
%    where C(t) is a randomly varying function of time.
% (b) Instead of estimating C(t) at each time, use a differencing 
%    method to eliminate C(t) from the estimation.  (Hint: Use 
%    propagation of variances to determine the covariance matrix of 
%    the differenced data.
% (c) Determine A by treating C(t) as correlated data noise (i.e., 
%    the C(t) noise is that same at each time and therefore highly 
%    correlated at each time but independent between times).
% (d) Compare the results from the "brute force", differencing, and 
%   data noise approaches (Hint: When solved correctly they all 
%   generate the same result). 


A = zeros(30,11);
for t = 1:10   % Loop over 10 epochs of data
    for j = 1:3   % Loop over the 3 measurements at each epoch
        no = (t-1)*3+j;
        A(no,1) = sin(Xv(no)); A(no,t+1) = 1.0;
    end
end

% Now standard leqst squares
neq = A'*A; bvec = A'*val; prefit_chi = val'*val;
cov = inv(neq); sol = cov*bvec; postfit_chi = prefit_chi - sol'*bvec;
%
% Output the values (in this case I know the correct answers
fprintf('Q 3 (a) Brute force estimates\n')
fprintf('X value Estimate %10.4f +- %10.4f Error %10.4f\n', sol(1), sqrt(cov(1,1)), sol(1)-10);
for t = 1:10
    fprintf('Clock offsets %2d %10.4f +- %10.4f Error %10.4f\n', t, sol(t+1), sqrt(cov(t+1,t+1)), sol(t+1)-ttrue(t));
end
r=30-11; c = postfit_chi;
prob = 1-gammainc(c/2,r/2);
fprintf('Chi^2 per degree of freedom %6.4f; f = %3d ; Probability %8.2f %%\n',postfit_chi/r, r, prob*100);

% Question 3(b): Now use a differencing method:
% Form a differencing matrix made up of elements [ 1 -1 0; 1 0 -1];
Ad = zeros(20,1); covdiff = zeros(20,20); vald = zeros(20,1);
Dop = zeros(20,30);
for t = 1:10
    Dop((t-1)*2+1,(t-1)*3+1) =  1.d0;
    Dop((t-1)*2+1,(t-1)*3+2) = -1.d0;
    Dop((t-1)*2+2,(t-1)*3+1) =  1.d0;
    Dop((t-1)*2+2,(t-1)*3+3) = -1.d0;
end
% The new partials matix is simply the first column of A by Dop (we could
% generate the remaining elelments but they will all be zero)
Ad = Dop*A(:,1); vald=Dop*val;
covdiff = Dop*Dop'; W = inv(covdiff);
%
% We now have standard partials and now covariance matrix of differenced
% data
neq = Ad'*W*Ad; bvec = Ad'*W*vald; prefit_chi = vald'*W*vald;
vard = 1/neq; sold = vard*bvec; postfit_chi = prefit_chi - sold*bvec;
fprintf('Q 3 (b) Differenced data result\n');
fprintf('Solution from differnced data : %10.4f +- %10.4f\n', sold, sqrt(vard));
fprintf('Difference from full solution : %10.4e +- %10.4e\n', sold-sol(1), sqrt(vard)-sqrt(cov(1,1)));
r=20-1; c = postfit_chi;
prob = 1-gammainc(c/2,r/2);
fprintf('Chi^2 per degree of freedom %6.4f; Probability %8.2f %%\n',postfit_chi/r, prob*100);

% See what happensif we ignored correlations among differenced data:
neq = Ad'*Ad; bvec = Ad'*vald;
varb = 1/neq; solb = varb*bvec;
fprintf('Q 3 (b) Differenced data result with no-correlations\n');
fprintf('Solution from differenced data: %10.4f +- %10.4f\n', solb, sqrt(varb));
fprintf('Difference from full solution : %10.4e +- %10.4e\n', solb-sol(1), sqrt(varb)-sqrt(cov(1,1)));

% Another solution method based on white noise treatment in Kalman filters.
% Generate partials for just X parameter
A = zeros(30,1); clkp = zeros(30,10);
for t = 1:10   % Loop over 10 epochs of data
    for j = 1:3   % Loop over the 3 measurements at each epoch
        no = (t-1)*3+j;
        A(no) = sin(Xv(no));
        clkp(no,t) = 1.0;
    end
end
% Generate data covariance
covw = zeros(30,30);
for i =1:30
    covw(i,i) = 1.0^2;
end
% Now generate "clock noise" model.  Make clock noise 10000 (original noise
% generated with 20 sigma.  (Making the 10000 larger gives a closer
% approximation, but if it is too large numerical problems will develop).
covw = covw + clkp*clkp'*10000^2;
W = inv(covw);
neq = A'*W*A; bvec = A'*W*val; prefit_chi = val'*W*val;
varw = 1/neq; solw = varw*bvec; postfit_chi = prefit_chi - solw*bvec;
fprintf('Q 3 (c) White noise model result\n');
fprintf('Solution from white noise     : %10.4f +- %10.4f\n', solw, sqrt(varw));
fprintf('Difference from full solution : %10.4e +- %10.4e\n', solw-sol(1), sqrt(varw)-sqrt(cov(1,1)));
% Get chi**2
r=20-1; c = postfit_chi;
prob = 1-gammainc(c/2,r/2);
fprintf('Chi^2 per degree of freedom %6.4f; f = %3d, Probability %8.2f %%\n',postfit_chi/r, r, prob*100);
%% Use postfit residuals
pres = val - A*solw;
postfit_sum = pres'*W*pres;
fprintf('Chi^2 from prefit %8.4f and from postfit residuals %8.4f\n',postfit_chi, postfit_sum);
%
figure; imagesc(W); colorbar; title('Image of weight matrix with white noise clock')






    







