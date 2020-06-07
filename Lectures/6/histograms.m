% Script M-file to generate statistics for 12.540 class
%
% Seed the random number generator (can be removed later)
% (use Seed to compatability with older versions of matlab).
s = 11; rand('seed',s); randn('seed',s+1);
unif_sig = 1.0; gauss_sig = sqrt(unif_sig/12);
%
N = 1000; % Used 1000 samples
uv = rand(N,1)-0.5; gv = randn(N,1)*gauss_sig;
dbn = 0.1; % db is bin width
bins = -1.5:dbn:1.5;
% Histogram counts values N(k) Count bin(k)<=x<bin(k+1), Last value counts
% values that match final edge value
uhist = histc(uv,bins)/N; ghist = histc(gv,bins)/N;

figure(1);
plot(1:N,uv,'c.', 1:N,gv,'ro');
xlabel('Sample'); ylabel('Random variable');
title('Uniform and Gaussian random values');
legend('Uniform','Gaussian');
%% Bar graph
figure(2); 
% Adjust bins to plot offset from center of bin (offset to show both the
% uniform and Gaussian values)
bp = bins + dbn/2 ; % General values; since we plot 2 histograms add/substract
                   % an additional db/4
hold off
bar(bp-dbn/4,uhist,0.5,'Facecolor',[0 1 1]); hold on
bar(bp+dbn/4,ghist,0.5,'FaceColor',[1 0 0]);
% Now compute theory:
plot([-0.5 -0.5 0.5 0.5],[0 dbn dbn 0],'k');
gtheory = (1/(gauss_sig*sqrt(2*pi)))*exp(-bp.*bp/(2*gauss_sig^2))*dbn;
plot(bp,gtheory,'k','LineWidth',2);
legend('Uniform','Gaussian','Gauss Theory');
xlabel('Bin'); ylabel('Fractional number');
tlab = sprintf('%d samples',N); text(-1.4,0.122,tlab);
axis tight

