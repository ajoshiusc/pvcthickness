%||AUM||
%opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/Projects/svreg/dev'));
addpath(genpath('/home/ajoshi/Projects/svreg/3rdParty'));
addpath(genpath('/home/ajoshi/Projects/svreg/src'));
addpath(genpath('/home/ajoshi/Projects/pvcthickness/old_thickness_code'));

pth_hires='/home/ajoshi/Projects/pvcthickness/fs_data/BCI-DNI_brain.july2023'
pth_lowres='/home/ajoshi/Projects/pvcthickness/fs_data/BCI-DNI_brain_1mm.july2023'

addpath(genpath('/home/ajoshi/Projects/pvcthickness/fs_data/matlab'));
[ave_sp.vertices,ave_sp.faces]=read_surf(['/home/ajoshi/Projects/pvcthickness/fs_data/fsaverage/surf/lh.sphere.reg']);ave_sp.faces=ave_sp.faces+1;
[sl.vertices,sl.faces]=read_surf(['/home/ajoshi/Projects/pvcthickness/fs_data/fsaverage/surf/lh.inflated']);sl.faces=sl.faces+1;


thickness_hires=load_mgh([pth_hires,'/surf/lh.thickness.fwhm5.fsaverage.mgh']);
thickness_lowres=load_mgh([pth_lowres,'/surf/lh.thickness.fwhm5.fsaverage.mgh']);


rng(21,"twister");

sl.attributes = abs(thickness_hires - thickness_lowres);
sl.attributes = sl.attributes + 1*rand(size(sl.attributes));
sl.attributes=smooth_surf_function(sl,sl.attributes,6.2,6.2);

h=figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,1.25]);colormap jet;
view(-90,0);camlight('headlight'); material dull;
saveas(h,'FS_left_hires_lowres_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'FS_left_hires_lowres_2.png')
close all;

autocrop_img('FS_left_hires_lowres_1.png')
autocrop_img('FS_left_hires_lowres_2.png')

save left_fs