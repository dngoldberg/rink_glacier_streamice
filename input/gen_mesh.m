% This script 

npx = 12; % number of x-processors to use (nPx in SIZE.h)
npy = 4;  % number of y-processors to use (nPy in SIZE.h)

load rink_data.mat

nx = length(x_mesh_mid);
ny = length(y_mesh_mid);

% size of "padding" cells to ensure all tiles are same size
gx = ceil(nx/npx) * npx - nx;
gy = ceil(ny/npy) * npy - ny;

% displays values that are needed for sNx, sNy
disp(ceil(nx/npx)) % sNx in SIZE.h
disp(ceil(ny/npy)) % sNy in SIZE.h

setup_experiment(nx,ny,gx,gy);
