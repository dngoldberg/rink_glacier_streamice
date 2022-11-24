function setup_experiment(nx,ny,gx,gy);
load rink_data
filter_surf = false;

density_ice = 917;
density_oce = 1027;

[X Y] = meshgrid(x_mesh_mid,y_mesh_mid);

%% interpolate all data to grid

vmask = (v>0);
vmask_interp = interp2(xmeas,ymeas',double(vmask),x_mesh_mid,y_mesh_mid');

vx = interp2(xmeas,ymeas',vx,x_mesh_mid,y_mesh_mid'); 
vx(vmask_interp<1) = -99999;
vy = interp2(xmeas,ymeas',vy,x_mesh_mid,y_mesh_mid'); 
vy(vmask_interp<1) = -99999;
verr = interp2(xmeas,ymeas',verr,x_mesh_mid,y_mesh_mid'); 
verr(vmask_interp<1) = -99999;

xbm = double(xbm);
ybm = double(ybm);

surf = interp2(xbm,ybm',double(surf),x_mesh_mid,y_mesh_mid');
surf(surf<0)=0;
mask_bm = interp2(xbm,ybm',mask_bm,x_mesh_mid,y_mesh_mid','nearest');
if(filter_surf)
    surf2 = surf;
    surf2(thick<5 & surf2>0)=.5;
    surf2(surf2==0 | mask_bm==1 | mask_bm==0)=nan;
    gaussFilter = fct_GaussianFilter([4 4], 1, 0);
    [surf2,im_conv,count,NaNcount] = fct_convNaN(surf2, gaussFilter, 'same', .5);
    surf2(mask_bm==0 | mask_bm==1)=nan;
    surf2(isnan(surf2))=surf(isnan(surf2));
    surf = surf2;
    surf(isnan(surf))=0;
end

bed = interp2(xbm,ybm',bed,x_mesh_mid,y_mesh_mid');
thick_floatation = (- density_oce*surf) / (density_ice - density_oce);
thick_floatation(surf==0)=0;
base_floatation = surf - thick_floatation;
base = max(bed,base_floatation);
thick_mod = surf-base;
thick_mod(surf==0)=0;
thick = thick_mod;


%%%%%%%%%%%%%%%%%%%%%

hmask = ones(size(thick));
hmask([1 end],:) = -1;
hmask(:,[1 end]) = -1;

hmask(thick<5)=-1;
con_mask = thick~=0 & hmask==1;
CC = bwconncomp(con_mask,4);
pp = CC.PixelIdxList;
for i=1:length(pp);
    length_pp(i) = length(pp{i});
end
[xx isort] = sort(length_pp,'descend');
if (length(pp)>1);
 for i=2:length(pp);
  for k=1:length(pp{isort(i)});
   hmask(pp{isort(i)}(k)) = -1;
  end;
 end;
end;

Aglen = apaterson(-10) * 31104000;
Bglen = Aglen.^(-1/3);
Bbar = sqrt(mean(Bglen,3)) * ones(size(thick));

faketopog = -1000*ones(ny,nx);
faketopog([1 end],:) = 0;
faketopog(:,[1 end]) = 0;


bed = [[bed zeros(ny,gx)];zeros(gy,nx+gx)];
binwrite('topog.bin',bed');

faketopog = [[faketopog zeros(ny,gx)];zeros(gy,nx+gx)];
binwrite('faketopog.bin',faketopog');

thick = [[thick zeros(ny,gx)];zeros(gy,nx+gx)];
binwrite('BedMachineThick.bin',thick');

vx = [[vx zeros(ny,gx)];zeros(gy,nx+gx)];
binwrite('velobsu.bin',vx');

vy = [[vy zeros(ny,gx)];zeros(gy,nx+gx)];
binwrite('velobsv.bin',vy');

verr = [[verr zeros(ny,gx)];zeros(gy,nx+gx)];
binwrite('errU.box',verr');

binwrite('ufacemask.bin',-1*ones(size(verr))');
binwrite('vfacemask.bin',-1*ones(size(verr))');

%binwrite('dhdtCryo.bin',dhdt');
%binwrite('oceModelMelt.bin',shelfMelt');

binwrite('delX.bin',[diffx ones(1,gx)]);
binwrite('delY.bin',[diffy; ones(gy,1)]);

disp('GOT HERE'); 
hmask = [[hmask -1*ones(ny,gx)];-1*ones(gy,nx+gx)];
binwrite('hmask.bin',hmask');

