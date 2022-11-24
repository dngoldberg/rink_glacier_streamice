% This matlab script is designed to "snip" a predefined section of topography, surface, BM_mask, and velocity from 
% predefined file paths. BedMachine-Greenland and ITS_live velocity is used. A grid is also defined which is separate
% from either data product grid.
% the data is saved in a matfile to allow for manipulation of smaller arrays later on


% paths to datafiles -- NEED TO BE MODIFIED
path_to_BMG = '/home/dgoldber/network_links/datastore/ice_data/BM_greenland/BedMachineGreenland-2021-04-20.nc'
path_to_IL = '/home/dgoldber/network_links/datastore/ice_data/its_live_greenland//GRE_G0240_0000.nc'

% limits of domain set here, in Polar Stereo coordinates
ylim_domain = [-2040 -1860]*1e3;
xlim_domain = [-310 10]*1e3;

%%%% NO NEED TO MODIFY BELOW HERE %%%

x = ncread(path_to_IL,'x');
y = flipud(ncread(path_to_IL,'y'));
v = flipud(double(ncread(path_to_IL,'v')')); 
vx = flipud(double(ncread(path_to_IL,'vx')')); 
vy = flipud(double(ncread(path_to_IL,'vy')')); 
verr = flipud(double(ncread(path_to_IL,'v_err')')); 


xbm = ncread(path_to_BMG,'x');
ybm = flipud(ncread(path_to_BMG,'y'));
bed_bm = flipud(double(ncread(path_to_BMG,'bed')'));
thick_bm = flipud(double(ncread(path_to_BMG,'thickness')'));
surf_bm = flipud(double(ncread(path_to_BMG,'surface')'));
mask_bm = flipud(double(ncread(path_to_BMG,'mask')'));


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

x_il = x(I_meas);
y_il = y(J_meas);

save rink_data.mat v vx vy verr bed surf thick diffx diffy x_mesh_mid y_mesh_mid xbm ybm x_il y_il mask_bm

