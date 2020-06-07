function dy = Lec18_bacc(t, y)
% acc: Computes accelerations including drag (Cd) and 
% and gravity
global targdist g0 dgdh rho0 scaleht mass xarea cd

dy = zeros(4,1);    % a column vector
%
dy(1) = y(3);
dy(2) = y(4);

% Compute a drag force
vmag = sqrt(y(3)^2+y(4)^2);
d(1) = -(rho0*exp(-y(2)/scaleht)*cd*xarea*y(3)*vmag)/(2*mass);
d(2) = -(rho0*exp(-y(2)/scaleht)*cd*xarea*y(4)*vmag)/(2*mass);

% Add forces to the gravity acceleration.
dy(3) = 0 + d(1) ;
dy(4) = g0 + dgdh*y(2) + d(2);
%dy(4) = sign(y(2))*g0 + dgdh*y(2) + d(2);


