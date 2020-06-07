function newrand = randtest(seed)
% test random number generator
persistent oldrand
%
% Set the constantants
A = 16807; M = 2147483647; % Constants for MATLAB RAND function
%A = 32000; M = 4511;   % Test values to see character

if( nargin == 0 ) 
    oldrand = mod(A*oldrand,M) ; 
else
    oldrand = seed;
    oldrand = mod(A*oldrand,M) ;
    oldrand = mod(A*oldrand,M) ;
end
newrand = oldrand/M;


    