%||AUM||
%opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/3rdParty'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));
addpath(genpath('/home/ajoshi/projects/pvcthickness/old_thickness_code'));



subbasename1mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/hires_data/BCI-DNI_brain'
subbasename3mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/lowres_data/BCI-DNI_brain_1mm'

%subbasename1mm='/home/ajoshi/hires_lowres/1mm/t1_icbm_normal_1mm_pn3_rf20_uint16'
atlas1mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/hires_data/atlas.left.mid.cortex.svreg.dfs';

%subbasename3mm='/home/ajoshi/hires_lowres/3mm/t1_icbm_normal_3mm_pn3_rf20_uint16'
atlas3mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/lowres_data//atlas.left.mid.cortex.svreg.dfs';

pth1mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/hires_data'
pth3mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/lowres_data'

 
%  a = tic;
%  %thicknessPVCwmgm_iso(subbasename1mm);
%  thicknessISO(subbasename1mm)
%  map_isothickness2atlas(subbasename1mm);
% % 
%  a1=toc(a)
% % %map_isothickness2atlas(subbasename1mm);
% % %thicknessPVCwmgm_iso(subbasename3mm);
%  thicknessISO(subbasename3mm);
%  map_isothickness2atlas(subbasename3mm);
%  %map_isothickness2atlas(subbasename3mm);
%  a2=toc(a)

sl=readdfs([pth1mm,'/atlas_isothickness.left.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = sl.attributes;

slv=readdfs([pth3mm,'/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs']);

sl=readdfs([pth3mm,'/atlas_isothickness.left.mid.cortex.svreg.dfs']);
sl.vertices = slv.vertices;
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = sl.attributes;


sl.attributes = abs(thickness_3mm - thickness_1mm);
sl.attributes=smooth_surf_function(sl,sl.attributes);


h=figure;


patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,5]);colormap jet;
view(-90,0);camlight('headlight'); material dull;
saveas(h,'ISO_left_hires_lowres_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'ISO_left_hires_lowres_2.png')
close all;

save hires_lowres_left_iso
