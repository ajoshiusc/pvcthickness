clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));

pth1mm='/home/ajoshi/brainweb/1mm'
pth3mm='/home/ajoshi/brainweb/3mm'

sl=readdfs([pth1mm,'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = sl.attributes;

sl=readdfs([pth3mm,'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = sl.attributes;


sl.attributes = abs(thickness_3mm - thickness_1mm)
sl.attributes=smooth_surf_function(sl,sl.attributes);


h=figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,5]);colormap jet;material dull;
view(-90,0);camlight('headlight'); 
saveas(h,'ADE_right_brainweb_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'ADE_right_brainweb_2.png')
close all;

save 3mm_1mm_right_pvc

