% HW5_1: Matlab script output Erf and its derivative
%
arg = -3:0.25:3;
% Make a table with the results in it
Results = [ arg ; erf(arg) ; 2/sqrt(pi)*exp(-arg.^2) ];
fprintf('\n12.010 HW05 Q01: Table of Erf and its derivative\n');
fprintf('-------------------------------------\n');
fprintf('|  Arg x  |    Erf(x)  |  d(Erf)/dx |\n');
fprintf('-------------------------------------\n');
fprintf('| %7.3f | %10.5f | %10.5f |\n',Results); 
fprintf('-------------------------------------\n');
%% Create Figure of results
% Regenerate results at finer spacing.
figure ;
arg = -3:0.05:3;
Results = [ arg ; erf(arg) ; 2/sqrt(pi)*exp(-arg.^2) ];
plot(Results(1,:),Results(2,:),'k',Results(1,:),Results(3,:),'b');
xlabel('Argument'); ylabel('Erf dErf/dx'); 
legend('Erf','dErf/dx','Location','NorthWest')
axis tight;

