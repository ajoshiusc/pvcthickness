%||AUM||
opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/dev'));
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/3rdParty'));
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/src'));
addpath(genpath('/home/ajoshi/projects/pvcthickness/old_thickness_code'));

subbasename1mm='/home/ajoshi/brainweb/1mm/t1_icbm_normal_1mm_pn3_rf20_uint16'
atlas1mm='/home/ajoshi/brainweb/1mm/atlas.left.mid.cortex.svreg.dfs';

subbasename3mm='/home/ajoshi/brainweb/3mm/t1_icbm_normal_3mm_pn3_rf20_uint16'
atlas3mm='/home/ajoshi/brainweb/3mm/atlas.left.mid.cortex.svreg.dfs';

pth1mm='/home/ajoshi/brainweb/1mm'
pth3mm='/home/ajoshi/brainweb/3mm'

tic
thickness_freesurfer(subbasename1mm);
toc
map_fsthickness2atlas(subbasename1mm);
toc
thickness_freesurfer(subbasename3mm);
toc
map_fsthickness2atlas(subbasename3mm);
toc 

sl=readdfs([pth1mm,'/atlas_fs_thickness.left.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = sl.attributes;

sl=readdfs([pth3mm,'/atlas_fs_thickness.left.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = sl.attributes;


sl.attributes = abs(thickness_3mm - thickness_1mm);
%sl.attributes=smooth_surf_function(sl,sl.attributes);


figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,.75]);colormap jet;
view(-90,0);camlight('headlight'); material dull;

save 3mm_1mm_left_fs
