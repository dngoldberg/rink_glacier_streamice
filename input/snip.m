ylim_domain = [-2040 -1860]*1e3;
xlim_domain = [-310 10]*1e3;

x = ncread('/home/dgoldber/network_links/datastore/ice_data/its_live_greenland//GRE_G0240_0000.nc','x');
y = flipud(ncread('/home/dgoldber/network_links/datastore/ice_data/its_live_greenland//GRE_G0240_0000.nc','y'));
v = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/its_live_greenland//GRE_G0240_0000.nc','v')')); 
vx = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/its_live_greenland//GRE_G0240_0000.nc','vx')')); 
vy = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/its_live_greenland//GRE_G0240_0000.nc','vy')')); 
verr = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/its_live_greenland//GRE_G0240_0000.nc','v_err')')); 



% J = 1400:2800;
% I = 5600:6200;
% pcolor(x(J)/1000,y(I)/1000,log(v(I,J))); shading flat; caxis([0 5])
% h = colorbar;
% yl = get(h,'yticklabel')
% for i=1:length(yl); s = yl(i); s=s{1}; n = str2num(s); q=exp(n); yl(i)={num2str(round(q))};  end;
% set(h,'yticklabel',yl);

xbm = ncread('/home/dgoldber/network_links/datastore/ice_data/BM_greenland/BedMachineGreenland-2021-04-20.nc','x');
ybm = flipud(ncread('/home/dgoldber/network_links/datastore/ice_data/BM_greenland/BedMachineGreenland-2021-04-20.nc','y'));
bed_bm = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/BM_greenland/BedMachineGreenland-2021-04-20.nc','bed')'));
thick_bm = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/BM_greenland/BedMachineGreenland-2021-04-20.nc','thickness')'));
surf_bm = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/BM_greenland/BedMachineGreenland-2021-04-20.nc','surface')'));
mask_bm = flipud(double(ncread('/home/dgoldber/network_links/datastore/ice_data/BM_greenland/BedMachineGreenland-2021-04-20.nc','mask')'));



I_meas = (x>xlim_domain(1)) & (x<xlim_domain(2));
J_meas = (y>ylim_domain(1)) & (y<ylim_domain(2));

I_bm = (xbm>xlim_domain(1)) & (xbm<xlim_domain(2));
J_bm = (ybm>ylim_domain(1)) & (ybm<ylim_domain(2));

v = v(J_meas,I_meas);
vx = vx(J_meas,I_meas);
vy = vy(J_meas,I_meas);
verr = verr(J_meas,I_meas);

bed = bed_bm(J_bm,I_bm);
surf = surf_bm(J_bm,I_bm);
thick = thick_bm(J_bm,I_bm);
mask_bm = mask_bm(J_bm,I_bm);

xmesh = xlim_domain(1):600:xlim_domain(2);
ymesh = ylim_domain(1):600:ylim_domain(2);

x_mesh_mid = .5 *(xmesh(1:end-1)+xmesh(2:end));
y_mesh_mid = .5 *(ymesh(1:end-1)+ymesh(2:end));
diffx = diff(xmesh);
diffy = diff(ymesh);

xbm = xbm(I_bm);
ybm = ybm(J_bm);

xmeas = x(I_meas);
ymeas = y(J_meas);

save rink_data.mat v vx vy verr bed surf thick diffx diffy x_mesh_mid y_mesh_mid xbm ybm xmeas ymeas mask_bm



