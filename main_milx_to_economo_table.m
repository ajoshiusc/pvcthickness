clc;clear;close all;
clc;clear all;close all;restoredefaultpath;
pp='/ImagePTE1/ajoshi/code_farm/svreg';
cmd_str=[pp,'/3rdParty',pathsep,pp,'/MEX_Files',pathsep,pp,'/src'];
addpath(cmd_str);

subbasename='/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/BCI_DNI_brain_deface_MNI';
pial=readdfs([subbasename,'.left.pial.cortex.dfs']);
inner=readdfs([subbasename,'.left.inner.cortex.dfs']);
midmid.faces=inner.faces;
midmid.vertices=0.75*inner.vertices+0.25*pial.vertices;
writedfs([subbasename,'.left.midmid.cortex.dfs'],midmid);
v=load_nii_BIG_Lab(['/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BCI_DNI_brain_deface_MNI_Thickness.nii.gz']);

xres = v.hdr.dime.pixdim(2);
yres = v.hdr.dime.pixdim(3);
zres = v.hdr.dime.pixdim(4);
SZ=size(v.img);


ind = find(v.img > 0);

%% Generate indices of the voxels to be labeled
[XX,YY,ZZ]=ind2sub(SZ,ind);XX=XX-1;YY=YY-1;ZZ=ZZ-1;

Xc = XX*xres;
Yc = YY*yres;
Zc = ZZ*zres;


th=griddata(Xc,Yc,Zc, double(v.img(ind)), midmid.vertices(:,1),midmid.vertices(:,2),midmid.vertices(:,3),'nearest');
%%
pvcth=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/BCI_DNI_brain_deface_MNI.pvc-thickness_0-6mm.left.mid.cortex.dfs');

midmid.attributes = th;
midmid = colorDFS(pvcth, midmid.attributes, [0 6], jet(256));
writedfs([subbasename,'.left.midmid.cortex.dfs'], midmid);
%
pvcth.attributes=smooth_surf_function(midmid,pvcth.attributes,1,1);
midmid = colorDFS(pvcth, pvcth.attributes, [0 6], jet(256));
writedfs([subbasename,'.left.midmid.cortex.pvcth.dfs'], midmid);

sub=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/BCI_DNI_brain_deface_MNI.left.mid.cortex.svreg.dfs');
sub.attributes=th;
tar=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/atlas.left.mid.cortex.svreg.dfs');
tar.attributes=map_data_flatmap(sub,sub.attributes,tar);
tar = colorDFS(tar, tar.attributes, [0 6], jet(256));
writedfs(['BCI_milx.left.mid.cortex.dfs'], tar);





lh = readdfs('BCI_DNI_economo_left.dfs');


thickness_lh = zeros(43,1);

for labid=1:43
    ind=(lh.labels==labid+1);
    th_lh=mean(mean(tar.attributes(ind)));
    
    thickness_lh(labid) = th_lh;

end


%%

subbasename='/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/BCI_DNI_brain_deface_MNI';
pial=readdfs([subbasename,'.right.pial.cortex.dfs']);
inner=readdfs([subbasename,'.right.inner.cortex.dfs']);
midmid.faces=inner.faces;
midmid.vertices=0.75*inner.vertices+0.25*pial.vertices;
writedfs([subbasename,'.right.midmid.cortex.dfs'],midmid);
v=load_nii_BIG_Lab(['/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BCI_DNI_brain_deface_MNI_Thickness.nii.gz']);

xres = v.hdr.dime.pixdim(2);
yres = v.hdr.dime.pixdim(3);
zres = v.hdr.dime.pixdim(4);
SZ=size(v.img);


ind = find(v.img > 0);

%% Generate indices of the voxels to be labeled
[XX,YY,ZZ]=ind2sub(SZ,ind);XX=XX-1;YY=YY-1;ZZ=ZZ-1;

Xc = XX*xres;
Yc = YY*yres;
Zc = ZZ*zres;


th=griddata(Xc,Yc,Zc, double(v.img(ind)), midmid.vertices(:,1),midmid.vertices(:,2),midmid.vertices(:,3),'nearest');
%%
pvcth=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/BCI_DNI_brain_deface_MNI.pvc-thickness_0-6mm.right.mid.cortex.dfs');

midmid.attributes = th;
midmid = colorDFS(pvcth, midmid.attributes, [0 6], jet(256));
writedfs([subbasename,'.right.midmid.cortex.dfs'], midmid);
%
pvcth.attributes=smooth_surf_function(midmid,pvcth.attributes,1,1);
midmid = colorDFS(pvcth, pvcth.attributes, [0 6], jet(256));
writedfs([subbasename,'.right.midmid.cortex.pvcth.dfs'], midmid);

sub=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/BCI_DNI_brain_deface_MNI.right.mid.cortex.svreg.dfs');
sub.attributes=th;
tar=readdfs('/big_disk/ajoshi/milx_cloud_results/milxcloud_results/BrainSuite/atlas.right.mid.cortex.svreg.dfs');
tar.attributes=map_data_flatmap(sub,sub.attributes,tar);
tar = colorDFS(tar, tar.attributes, [0 6], jet(256));
writedfs(['BCI_milx.right.mid.cortex.dfs'], tar);


rh = readdfs('BCI_DNI_economo_right.dfs');

thickness_rh = zeros(43,1);

for labid=1:43
    ind=(rh.labels==labid+1);
    th_r=mean(mean(tar.attributes(ind)));
    
    thickness_rh(labid) = th_r;

end






%%

figure;
plot(pvcth.attributes,th,'.');

tic
figure;
%[x,f]=ksdensity(pvcth.attributes(1:100),midmid.attributes(1:100));

edges = {(0:0.06:6),(0:0.06:6)}; 
[h,b]=hist3([pvcth.attributes,th],'edges',edges);

figure;histogram(pvcth.attributes,linspace(0,6,100),'facealpha',.5,'edgecolor','none','facecolor','blue');
hold on;histogram(th,linspace(0,6,100),'facealpha',.5,'edgecolor','none','facecolor','red');


figure;
%imagesc(h);
imagesc(b{1}([1 end]),b{2}([1 end]),h);
set(gca,'YDir','normal');
xlabel('PVC Thickness');
ylabel('Acosta');
axis equal;
axis tight;
colorbar;

%hist3(pvcth.attributes,midmid.attributes,[0,3])
toc


figure;
hist3([pvcth.attributes,th],'CdataMode','auto','Nbins',[100,100]);
view(2)
