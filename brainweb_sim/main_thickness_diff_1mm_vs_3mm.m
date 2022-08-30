%||AUM||
opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/dev'));
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/src'));

pth1mm='/home/ajoshi/brainweb/1mm'
pth3mm='/home/ajoshi/brainweb/3mm'

sl=readdfs([pth1mm,'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = sl.attributes;

sl=readdfs([pth3mm,'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = sl.attributes;


sl.attributes = abs(thickness_3mm - thickness_1mm)
%sl.attributes=smooth_surf_function(sl,sl.attributes);


figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,.75]);colormap jet;
view(-90,0);camlight('headlight'); material dull;

save 3mm_1mm_left_pvc

