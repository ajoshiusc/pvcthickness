clc;clear ;close all;
opengl software

restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/3rdParty'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));
addpath(genpath('/home/ajoshi/projects/pvcthickness'));


subbasename1mm='/home/ajoshi/brainweb/1mm/t1_icbm_normal_1mm_pn3_rf20_uint16'
atlas1mm='/home/ajoshi/brainweb/1mm/atlas.right.mid.cortex.svreg.dfs';

subbasename3mm='/home/ajoshi/brainweb/3mm/t1_icbm_normal_3mm_pn3_rf20_uint16'
atlas3mm='/home/ajoshi/brainweb/3mm/atlas.right.mid.cortex.svreg.dfs';

pth1mm='/home/ajoshi/brainweb/1mm'
pth3mm='/home/ajoshi/brainweb/3mm'



% tic
% thicknessMLI(subbasename1mm);
% toc
% map_MLIthickness2atlas(subbasename1mm);
% %map_fsthickness2atlas(subbasename1mm);
% toc
% thicknessMLI(subbasename3mm);
% toc
% map_MLIthickness2atlas(subbasename3mm);
% 
% %map_fsthickness2atlas(subbasename3mm);
% toc 



sl=readdfs([pth1mm,'/atlas_MLIthickness.right.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = sl.attributes;

sl=readdfs([pth3mm,'/atlas_MLIthickness.right.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = sl.attributes;

sl = readdfs('/home/ajoshi/brainweb/3mm/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs');

sl.attributes = abs(thickness_3mm - thickness_1mm)
sl.attributes=smooth_surf_function(sl,sl.attributes);


h=figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,5]);colormap jet;
view(-90,0);camlight('headlight'); material dull;
saveas(h,'MLI_right_brainweb_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'MLI_right_brainweb_2.png')
close all;


save 3mm_1mm_right_MLI

