clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));

hires='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/hires_data'
lowres='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/lowres_data'

sl=readdfs([hires,'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = min(max(sl.attributes,0),6);

sl=readdfs([lowres,'/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = min(max(sl.attributes,0),6);


sl.attributes = abs(thickness_3mm - thickness_1mm)
sl.attributes=smooth_surf_function(sl,sl.attributes);


h=figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,5]);colormap jet;material dull;
view(-90,0);camlight('headlight'); 
saveas(h,'ADE_right_hireslowres_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'ADE_right_hireslowres_2.png')
close all;

save hires_lowres_right_pvc

