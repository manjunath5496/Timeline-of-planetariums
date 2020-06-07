function [P,Z,t] = pz(Po,Zo,T,method,dt)
% PZ(Po,Zo,T,method,dt)
%
%	Po	- initial value of P (at time=0)
%	Zo	- initial value of Z (at time=0)
%	T	- duration (time)
%	method	- integration method ('heun','rk4','forward',...)
%	dt	- time step
%
% Integrates a P-Z model with parameterized N using different time-stepping
% methods:
%
%                 N = Nt - P - Z
%             d_t P = u*P*N/(N+No) - g*Z*P/f(P+Po)
%             d_t Z = a*g*Z*P/f(P+Po) - d*Z
%
% Model parameters are set in the sub-function (in this script) called model()
% with values u=0.03, No=0.1, Nt=5, g=0.2, a=0.4, d=0.08. f(P)=1 is used.
% Model and parameters courtesy of Glenn Flierl and Stephanie Dutkiewicz.
%
% Possible values for 'method' are:
%	'forward'	- Forward method
%	'matsuno'	- Matsuno method (forward/backward)
%	'heun'		- Huen (forward/trapezoidal)
%	'rk2'		- Runge-Kutta 2 (mid-point method)
%	'rk4'		- Runge-Kutta 4
%	'ab2'		- Adams-Bashforth 2 (extrapolates dPdt,dZdt in time)
%	'ab2s'		- Adams-Bashforth 2 (extrapolates P,Z in time)
%	'ab3'		- Adams-Bashforth 3 (extrapolates dPdt,dZdt in time)
%	'ab3s'		- Adams-Bashforth 3 (extrapolates P,Z in time)
%	'qab2'		- (Quasi-) Adams-Bashforth 2 (extrap. dPdt,dZdt in time)
%	'qab2s'		- (Quasi-) Adams-Bashforth 2 (extrapolates P,Z in time)
%
% e.g.
%
% >> [P,Z,t]=pz(2,.5,500,'rk4',5);
% >> clf;plot(t,[P Z]);legend('P','Z');
% >> axes('position',[.21 .65 .25 .25]);plot(P,Z);xlabel('P');ylabel('Z');

% Number of time steps
nt=max(1,round(T/dt));

P=zeros(nt,1);	% Declares memory (faster to do this here)
Z=zeros(nt,1);	% Declares memory (faster to do this here)

% Initial conditions
P(1)=Po;
Z(1)=Zo;

for n=1:nt-0;
 nl=max(1,n-2:n);
 [P(n+1),Z(n+1)] = integrator( P(nl), Z(nl), dt, method );
end
t=dt*(0:nt-0)';

% -----------------------------------------------------------------------------

function [dPdt,dZdt] = model(P,Z,method)
% returns rates of change, d/dt P and d/dt Z as function of P and Z
%
% P and Z each contain two elements corresponding to time levels (n-1) and (n).

% Model parameters
Nt=5;		% Total nutrient
No=0.1;		% Threshold nutrient
u=0.03;		% Uptake factor (or growth rate of P)
g=0.2;		% Grazing factor
a=0.4;		% Grazing conversion factor (efficiency)
d=0.08;		% Death rate (of Z)
ff=1;

%u=0.01;	% Uptake factor (or growth rate of P)
%g=0.1;		% Grazing factor
%a=1.0;		% Grazing conversion factor (efficiency)
%Po=0.5;	% Threshold phytoplankton
%ff=P+Po;

N=Nt-P-Z;
dPdt = u*P*N/(N+No) - g*Z*P/ff;
dZdt = a*g*Z*P/ff - d*Z;

% -----------------------------------------------------------------------------

function [P,Z] = integrator(P,Z,dt,method)

Pn_2=P(end-2);
Pn_1=P(end-1);
P=P(end);
Zn_2=Z(end-2);
Zn_1=Z(end-1);
Z=Z(end);

switch method
 case 'forward',
  [dPdt,dZdt]=model(P,Z);
  P=P+dt*dPdt; Z=Z+dt*dZdt;
 case 'matsuno',
  [dPdt1,dZdt1]=model(P,Z); P1=P+dt*dPdt1; Z1=Z+dt*dZdt1;
  [dPdt2,dZdt2]=model(P1,Z1);
  P=P+dt*dPdt2; Z=Z+dt*dZdt2;
 case 'heun',
  [dPdt1,dZdt1]=model(P,Z); P1=P+dt*dPdt1; Z1=Z+dt*dZdt1;
  [dPdt2,dZdt2]=model(P1,Z1);
  P=P+dt*(dPdt1+dPdt2)/2; Z=Z+dt*(dZdt1+dZdt2)/2;
 case 'rk2',
  [dPdt,dZdt]=model(P,Z); P1=P+dt/2*dPdt; Z1=Z+dt/2*dZdt;
  [dPdt,dZdt]=model(P1,Z1);
  P=P+dt*dPdt; Z=Z+dt*dZdt;
 case 'rk4',
  [dPdt0,dZdt0]=model(P ,Z ); P1=P+dt/2*dPdt0; Z1=Z+dt/2*dZdt0;
  [dPdt1,dZdt1]=model(P1,Z1); P2=P+dt/2*dPdt1; Z2=Z+dt/2*dZdt1;
  [dPdt2,dZdt2]=model(P2,Z2); P3=P+dt  *dPdt2; Z3=Z+dt  *dZdt2;
  [dPdt3,dZdt3]=model(P3,Z3);
  P=P+dt*(dPdt0+2*dPdt1+2*dPdt2+dPdt3)/6;
  Z=Z+dt*(dZdt0+2*dZdt1+2*dZdt2+dZdt3)/6;
 case 'ab2',
  [dPdt1,dZdt1]=model(P   ,Z   );
  [dPdt2,dZdt2]=model(Pn_1,Zn_1);
  P=P+dt*(3/2*dPdt1-1/2*dPdt2);
  Z=Z+dt*(3/2*dZdt1-1/2*dZdt2);
 case 'ab2s',
  Pab=3/2*P-1/2*Pn_1;
  Zab=3/2*Z-1/2*Zn_1;
  [dPdt,dZdt]=model(Pab,Zab);
  P=P+dt*dPdt;
  Z=Z+dt*dZdt;
 case 'qab2',
  eps=0.1;
  [dPdt1,dZdt1]=model(P   ,Z   );
  [dPdt2,dZdt2]=model(Pn_1,Zn_1);
  P=P+dt*((3/2+eps)*dPdt1-(1/2+eps)*dPdt2);
  Z=Z+dt*((3/2+eps)*dZdt1-(1/2+eps)*dZdt2);
 case 'qab2s',
  eps=0.1;
  Pab=(3/2+eps)*P-(1/2+eps)*Pn_1;
  Zab=(3/2+eps)*Z-(1/2+eps)*Zn_1;
  [dPdt,dZdt]=model(Pab,Zab);
  P=P+dt*dPdt;
  Z=Z+dt*dZdt;
 case 'ab3',
  [dPdt1,dZdt1]=model(P   ,Z   );
  [dPdt2,dZdt2]=model(Pn_1,Zn_1);
  [dPdt3,dZdt3]=model(Pn_2,Zn_2);
  P=P+dt*(23*dPdt1-16*dPdt2+5*dPdt3)/12;
  Z=Z+dt*(23*dZdt1-16*dZdt2+5*dZdt3)/12;
 case 'ab3s',
  Pab=(23*P-16*Pn_1+5*Pn_2)/12;
  Zab=(23*Z-16*Zn_1+5*Zn_2)/12;
  [dPdt,dZdt]=model(Pab,Zab);
  P=P+dt*dPdt;
  Z=Z+dt*dZdt;
 otherwise,
  disp( sprintf('Error: method="%s" is not known',method) );
  error('Unrecongnized method!');
 end
