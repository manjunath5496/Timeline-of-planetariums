% atlas_test plots somedata from teh WHP/SAC Atlas
% examples of accessing and plotting variables from GHC Atlas
%T. Joyce, Oct. 2004
load  ghc_pr.mat; %this is the atlas file
load topo
t0=squeeze(dataT_pr(:,:,1)); %get 2-D array of sea surface temperature

figure(1)
clf
orient tall
subplot(211)
pcolor(lon,lat,t0)
shading flat
hold on
ci=[-1000 -3000 -5000]; %depth (m) contour intervals
caxis([-2 32]);
contour(lon,lat,topo(10:180,:),ci,'k')
colorbar('vert')
ylabel('latitude','fontsize',14)
title('WHP/SAC Temperature (p=0)','fontsize',14)
s0=squeeze(dataS_pr(:,:,1));
subplot(212)
pcolor(lon,lat,s0)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([31.5 38.5]);
colorbar('vert')
xlabel('longitude','fontsize',14)
ylabel('latitude','fontsize',14)
title('WHP/SAC Salinity (p=0)','fontsize',14)

t1=squeeze(dataT_pr(:,:,22));
figure(2)
clf
orient tall
subplot(211)
pcolor(lon,lat,t1)
shading flat
hold on
ci=[-1000 -3000 -5000];
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([-2 12]);
colorbar('vert')
ylabel('latitude','fontsize',14)
title('WHP/SAC Temperature (p=1000)','fontsize',14)
s1=squeeze(dataS_pr(:,:,22));
subplot(212)
pcolor(lon,lat,s1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([34 36]);
colorbar('vert')
xlabel('longitude','fontsize',14)
ylabel('latitude','fontsize',14)
title('WHP/SAC Salinity (p=1000)','fontsize',14)

figure(3)
clf
%global plot of neutral density at surface and at 1000 dbar
orient tall
subplot(212)
g0=squeeze(dataG_pr(:,:,1)); %neutral density at surface
g1=squeeze(dataG_pr(:,:,22)); %neutral density at 1000 dbar
pcolor(lon,lat,g1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([26.5 28.5]);
colorbar('vert')
xlabel('longitude','fontsize',14)
ylabel('latitude','fontsize',14)
title('WHP/SAC Gamma-N (p=1000)','fontsize',14)
subplot(211)
pcolor(lon,lat,g0)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([20 27]);
colorbar('vert')
ylabel('latitude','fontsize',14)
title('WHP/SAC Gamma-N (p=0)','fontsize',14)

%now we want to interpolate S onto a gamma-n surface and plot
gn=[26.5 26.8 27.3 27.95]; %this is good for [EDW NPIW AAIW/MedW MedW/LSW]
for ilat=1:length(lat);
    for ilon=1:length(lon);
        %inner loop for making calculations like geopotential anomaly,
        %potential temperature, etc. 
        for klev=1:length(gn)
            gg=[];pg=[];
            gg=squeeze(dataG_pr(ilat,ilon,:));
            sg=squeeze(dataS_pr(ilat,ilon,:));
            ii=find(isfinite(gg));
            plevs=length(ii);
            gg=gg(ii);
            [ggs,jj]=unique(gg);% need to remove gamma-n inversions
            sg=sg(ii);
            sgs=sg(jj);
            pg=press(ii);
            pgs=pg(jj);
%            plevs=length(gg);
%            display([' working on gamma-n level of ',num2str(gn(klev))])
            if(plevs<=1)
                si(ilat,ilon,klev)=nan;
                pi(ilat,ilon,klev)=nan;
            elseif(max(gg)<gn(klev))
                si(ilat,ilon,klev)=nan;
                pi(ilat,ilon,klev)=nan;
            elseif(min(gg)>gn(klev))
                si(ilat,ilon,klev)=nan;
                pi(ilat,ilon,klev)=nan;
            else
                pi(ilat,ilon,klev)=interp1(ggs,pgs,gn(klev),'linear');
                si(ilat,ilon,klev)=interp1(pg,sg,pi(ilat,ilon,klev),'linear');
            end
        end
    end
end
figure(4)
clf
orient tall
subplot(211)
sg1=squeeze(si(:,:,4)); %plot LSW
pg1=squeeze(pi(:,:,4));
pcolor(lon,lat,pg1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([0 3000]);
colorbar('vert')
ylabel('latitude','fontsize',14)
title('WHP/SAC Pressure (\Gamma_n=27.95), LSW','fontsize',14)
subplot(212)
pcolor(lon,lat,sg1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([34.5 35.5]);
colorbar('vert')
xlabel('longitude','fontsize',14)
ylabel('latitude','fontsize',14)
title('WHP/SAC Salinity (\Gamma_n=27.95)','fontsize',14)

figure(5)
clf
orient tall
subplot(211)
sg1=squeeze(si(:,:,3)); %plot AAIW
pg1=squeeze(pi(:,:,3));
pcolor(lon,lat,pg1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([0 1500]);
colorbar('vert')
ylabel('latitude','fontsize',14)
title('WHP/SAC Pressure (\Gamma_n=27.3, AAIW/MW)','fontsize',14)
subplot(212)
pcolor(lon,lat,sg1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([34 36]);
colorbar('vert')
xlabel('longitude','fontsize',14)
ylabel('latitude','fontsize',14)
title('WHP/SAC Salinity (\Gamma_n=27.3)','fontsize',14)

figure(6)
clf
orient tall
subplot(211)
sg1=squeeze(si(:,:,2));% plot NPIW
pg1=squeeze(pi(:,:,2));
pcolor(lon,lat,pg1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([0 1000]);
colorbar('vert')
ylabel('latitude','fontsize',14)
title('WHP/SAC Pressure (\Gamma_n=26.8, NPIW)','fontsize',14)
subplot(212)
pcolor(lon,lat,sg1)
shading flat
hold on
contour(lon,lat,topo(10:180,:),ci,'k')
caxis([34 36]);
colorbar('vert')
xlabel('longitude','fontsize',14)
ylabel('latitude','fontsize',14)
title('WHP/SAC Salinity (\Gamma_n=26.8)','fontsize',14)

% now plot a north/south section of salinity and potrential temperature, followed by a theta/S diagram for the section
jlon=190; %this is 160W, from the Aluetians to Antartica
jj=find(lon==jlon);
s190=squeeze(dataS_pr(:,jj,:));
t190=squeeze(dataT_pr(:,jj,:));
g190=squeeze(dataG_pr(:,jj,:));
% need to loop thru latitude now to calculate potential temperature
%should REALLY convert to t68 temperature scale before doing this!
for ilat=1:length(lat)
    th190(ilat,:)=sw_ptmp(s190(ilat,:)',t190(ilat,:)',press,0)';
%    d200(ilat,:)=sw_dpth(press,lat(ilat)); %this is the depth from pressure
end
%plot against mean depth of pressure surfaces for section
figure(7)
orient tall
sci=33:.2:36;
thci=-2:2:28;
subplot(211)
contourf(lat',press,s190',sci,'k')
axis ij
colorbar
title('Salinity at 170W','fontsize',14)
ylabel('pressure, dbar')
subplot(212)
contourf(lat',press,th190',thci,'k')
axis ij
title('\theta at 170W','fontsize',14)
ylabel('pressure, dbar')
xlabel('latitude')
colorbar

%finally, plot a potential temperature/salinity diagram for the above section
figure(8)
clf
i1=find(lat>60);
i2=find(lat<-60);
i3=find(lat>=-60 & lat<=60);
ss1=s190(i1,:);th1=th190(i1,:);
ss2=s190(i2,:);th2=th190(i2,:);
ss3=s190(i3,:);th3=th190(i3,:);
plot(ss1(1,:),th1(1,:),'bo',ss2(10,:),th2(10,:),'cx',ss3(1,:),th3(1,:),'r.')
legend('Arctic(>60^oN)','Antarct.(<60^oS','all else',2)
hold on
plot(ss1,th1,'bo',ss2,th2,'cx',ss3,th3,'r.')
%axis square
grid
xlabel('Salinity','fontsize',14)
ylabel('Potential Temp., ^oC','fontsize',14)
title('\theta/S diagram for 170W','fontsize',14)

break
%this part is to make print files of the above figures
figure(1)
print -depsc2 atlas_fig1.eps -tiff
print -dtiff atlas_fig1.tif
figure(2)
print -depsc2 atlas_fig2.eps -tiff
print -dtiff atlas_fig2.tif
figure(3)
print -depsc2 atlas_fig3.eps -tiff
print -dtiff atlas_fig3.tif
figure(4)
print -depsc2 atlas_fig4.eps -tiff
print -dtiff atlas_fig4.tif
figure(5)
print -depsc2 atlas_fig5.eps -tiff
print -dtiff atlas_fig5.tif
figure(6)
print -depsc2 atlas_fig6.eps -tiff
print -dtiff atlas_fig6.tif
figure(7)
print -depsc2 atlas_fig7.eps -tiff
print -dtiff atlas_fig7.tif
figure(8)
print -depsc2 atlas_fig8.eps -tiff
print -dtiff atlas_fig8.tif



               
        