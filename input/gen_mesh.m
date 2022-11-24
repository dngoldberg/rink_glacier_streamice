npx = 12;
npy = 4;

load rink_data.mat

nx = length(x_mesh_mid);
ny = length(y_mesh_mid);

gx = ceil(nx/npx) * npx - nx;
gy = ceil(ny/npy) * npy - ny;

disp(ceil(nx/npx))
disp(ceil(ny/npy))

setup_experiment(nx,ny,gx,gy);
