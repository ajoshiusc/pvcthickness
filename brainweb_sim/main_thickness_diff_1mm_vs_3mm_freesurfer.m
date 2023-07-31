%||AUM||
opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/3rdParty'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));
addpath(genpath('/home/ajoshi/projects/pvcthickness/old_thickness_code'));


brainweb_1mm='/home/ajoshi/projects/pvcthickness/fs_data/icbm_1mm'
brainweb_3mm='/home/ajoshi/projects/pvcthickness/fs_data/icbm_3mm'


addpath(genpath('/home/ajoshi/projects/pvcthickness/fs_data/matlab'));
[ave_sp.vertices,ave_sp.faces]=read_surf(['/home/ajoshi/projects/pvcthickness/fs_data/fsaverage/surf/lh.sphere.reg']);ave_sp.faces=ave_sp.faces+1;
[sl.vertices,sl.faces]=read_surf(['/home/ajoshi/projects/pvcthickness/fs_data/fsaverage/surf/lh.inflated']);sl.faces=sl.faces+1;


thickness_hires=load_mgh([brainweb_1mm,'/surf/lh.thickness.fwhm25.fsaverage.mgh']);
thickness_lowres=load_mgh([brainweb_3mm,'/surf/lh.thickness.fwhm25.fsaverage.mgh']);




sl.attributes = abs(thickness_hires - thickness_lowres);
%sl.attributes=smooth_surf_function(sl,sl.attributes);


h=figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,.75]);colormap jet;
view(-90,0);camlight('headlight'); material dull;
saveas(h,'FS_left_brainweb_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'FS_left_brainweb_2.png')
close all;

save brainweb_left_fs


