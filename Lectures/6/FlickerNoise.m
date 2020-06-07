% Set frequencies
Dur = 3*365;
%Dur = 365; 
 FlicSig = 2.0; WNSig = 1 ; % correlation time 32-days
%FlicSig = 1.0; WNSig = 2.0 ;

%Dur = 3625;
f = (1:Dur)*1/Dur;

FlicSP = [1./f 1./fliplr(f(2:Dur))];
%Flic
FlicRt = ifft(FlicSP);

FlicRt = FlicRt/FlicRt(1)*FlicSig^2;

Cvv = zeros(Dur,Dur);
for i = 1:Dur
    for j = 1:Dur
      Cvv(i,j) = FlicRt(abs(i-j)+1);
    end
end

% get eigevalues
eg = 1;
if  eg == 1
    fprintf('Getting eigenvalues ... ');
    [V,D] = eig(Cvv);
    fprintf('Done\n');
end

%% Set up for LSQ soluton
A = [ones(1,Dur) ; (1:Dur)/365]';
W = inv(Cvv + eye(Dur)*WNSig^2);
N = A'*W*A; Cfp = inv(N);
fprintf('++++++++++++++++++++++++++++++++++++++++++++++++++\n');
fprintf('Flicker Noise Sig %5.2f WN %5.2f \nOffset and Rate Sig %6.3f %6.3f\n', ...
    FlicSig, WNSig, sqrt(Cfp(1,1)), sqrt(Cfp(2,2)))
%
Afm = Cfp*(A'*W);


%% Generate realizations and average
meanpsd = zeros(Dur*2,1);
%figure(3) ; clf ; loglog([1 10 100 1e5],[1 1/10 1/100 1/1e5]*8e6,'r'); hold on; 
M = 200; meanstd = 0;
fpesave = zeros(2,M); nrmssave = zeros(1,M); fitsave = zeros(2,M);
for it = 1:M   
    wh = sqrt(diag(D)).*randn(Dur,1)+WNSig*randn(Dur,1);
    fn = V*wh;
    fpest = Afm*fn;
    %fprintf('Iter %3d Offset Rate %6.3f %6.3f \n',it, fpest);
    fpesave(:,it) = fpest;
    
    %fprintf('Iter %d Std %6.2f\n',it,std(fn))
    df = fft([fn ; flipud(fn)]); psd = df.*conj(df);
    meanpsd = meanpsd + psd; meanstd = meanstd + std(fn);
    %loglog(psd(1:Dur))
    
    % Now see how realistic sigma works
    [fit, Cp, nrms, tau] = RSFit((1:Dur)/365,fn',ones(1,Dur)*max(1,WNSig)*2);
    fitsave(:,it) = fit ; nrmssave(it) = nrms; 
end
fprintf('Obs RMS from %4d estimates, Offset and rate %6.3f %6.3f \n', it, std(fpesave,0,2))
fprintf('RSF RMS from %4d estimates, Offset and rate %6.3f %6.3f +- %6.3f %6.3f\n', it, std(fitsave,0,2),sqrt(diag(Cp))*mean(nrms))

%% Average PSD
figure(1); clf; 
loglog(meanpsd(1:Dur)/M)
hold on; loglog([1 10 2000],[1 1/10 1/2000]*3.5e6,'r')
fprintf('Mean STD Flicker %6.2f\n',meanstd/M);

%% Now do a fogm model
%
tau = 32 ; var = FlicRt(1);
PhiG = sqrt(2*var/tau);  F = exp(-1/tau); stepsig = PhiG*tau*(1-F);

%% Set up for LSQ soluton: Two approaches

Cfv = zeros(Dur,Dur);
for i = 1:Dur
    for j = 1:Dur
      Cfv(i,j) = var*exp(-abs(i-j)/tau);
    end
end

W = inv(Cfv + eye(Dur)*WNSig^2);
N = A'*W*A; Cfg = inv(N);
fprintf('\nFOGM Noise Sig %5.2f tau %6.1f WN %5.2f \nOffset and Rate Sig %6.3f %6.3f\n', ...
    sqrt(var), tau, WNSig, sqrt(Cfg(1,1)), sqrt(Cfg(2,2)))
%
Afg = Cfg*(A'*W);

%%
fogm = zeros(Dur,1); fogm(1) = randn()*sqrt(var);
fgesave = zeros(2,M);
meanpsdf = zeros(Dur*2,1);meanstdf = 0;
%figure(5) ; clf ; loglog([1 10 1000 0],[1 1/10 1/1000]*8e6,'r'); hold on; 
for it = 1:M
    % Generate process
    for i = 2:Dur
        fogm(i) = fogm(i-1)*F + randn()*stepsig;
    end
    fogm = fogm + WNSig*randn(Dur,1); 
    % fprintf('Iter %d Std %6.2f\n',it,std(fogm))
    df = fft([fogm ; flipud(fogm)]); psd = df.*conj(df);
    
    %[psd,w] = pwelch([fogm ; flipud(fogm)],[],[],2*Dur,1); % By default generates 8 segements with 50% overlap, Hanning window
    
    meanpsdf = meanpsdf + psd; meanstdf = meanstdf + std(fogm);
    %loglog(psd(1:Dur))
    fgest = Afg*fogm;
    %fprintf('Iter %3d Offset Rate %6.3f %6.3f \n',it, fpest);
    fgesave(:,it) = fgest;
    % Now see how realistic sigma works
    [fit, Cp, nrms, tau] = RSFit((1:Dur)/365,fogm',ones(1,Dur)*max(1,WNSig)*2);
    fitsave(:,it) = fit ; nrmssave(it) = nrms; 
end
fprintf('Obs RMS from %4d estimates, Offset and rate %6.3f %6.3f \n', it, std(fgesave,0,2))   
fprintf('RSF RMS from %4d estimates, Offset and rate %6.3f %6.3f +- %6.3f %6.3f\n', it, std(fitsave,0,2),sqrt(diag(Cp))*mean(nrms))

%% Average PSD
figure(2); clf; 
loglog(meanpsdf(1:Dur)/M)
hold on; loglog([1 10 1000],[1 1/10 1/1000]*8e6,'r')
fprintf('Mean STD FOGM %6.2f\n',meanstdf/M);

figure(3) ; clf ; hold off ; plot(Afm(2,:),'r'); hold on ; plot(Afg(2,:),'g')
legend('Flicker noise','FOGM Model','Location','NorthWest');

%% 

%% Outout timesseries
o = 0;
if o == 1
    fid = fopen('mn_TST1_GPS.dat1','w');
    fprintf(fid,'Globk Analysis\nTST1_GPS  to N Solution  1 +   0.0 m\n\n');
    for i = 1:Dur
        fprintf(fid,' %9.4f    %7.4f  %7.4f\n',(i-1)/365+2000.0, 1.02+fn(i)/1000+0.001*i/365.0,0.0015);
    end
    fclose(fid);
    fid = fopen('mn_TST2_GPS.dat1','w');
    fprintf(fid,'Globk Analysis\nTST2_GPS  to N Solution  1 +   0.0 m\n\n');
    for i = 1:Dur
        fprintf(fid,' %9.4f    %7.4f  %7.4f\n',(i-1)/365+2000.0,1.02+fogm(i)/1000.0+0.001*i/365,0.0015);
    end
    fclose(fid);
    
end
 
% 1999.1137       2.5528   0.0039

    
    
    
        
