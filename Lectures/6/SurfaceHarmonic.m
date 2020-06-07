% Define constants.
Radius = 5 ; Amp = -.5;
% Create the grid
delta = pi/40;
theta = 0 : delta : pi; % altitude
phi = 0 : 2*delta : 2*pi; % azimuth
[phi,theta] = meshgrid(phi,theta);

figure; subplot(4,5,1); hold on;
for degree = 1:4
    for order = 0:degree
        
        subplot(4,5,(degree-1)*5+order+1);


%       Calculate the harmonic
        Ymn = legendre(degree,cos(theta(:,1)));
        Ymn = Ymn(order+1,:)';
        yy = Ymn;
        for kk = 2: size(theta,1)
            yy = [yy Ymn];
        end;
        yy = yy.*cos(order*phi);

        maxmag = max(max(abs(yy)));
        rho = Radius + Amp*yy/maxmag;

        % Apply spherical coordinate equations
        r = rho.*sin(theta);
        x = r.*cos(phi);    % spherical coordinate equations
        y = r.*sin(phi);
        z = rho.*cos(theta);
        c = yy/maxmag;

        % Plot the surface
        surf(x,y,z,c)
        light
        lighting phong; shading interp; 
        axis tight equal off
        view(40,30)
        tl = sprintf('N %1d M %1d',degree,order); title(tl);
        camzoom(1.5)
    end
end
colormap('hsv')
