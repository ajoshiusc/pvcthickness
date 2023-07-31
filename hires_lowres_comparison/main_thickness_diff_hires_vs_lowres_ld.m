%||AUM||
opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/3rdParty'));


subbasename1mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/hires_data/BCI-DNI_brain'
subbasename3mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/lowres_data/BCI-DNI_brain_1mm'

atlas1mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/hires_data/atlas.left.mid.cortex.svreg.dfs';
atlas3mm='/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/lowres_data/atlas.left.mid.cortex.svreg.dfs';

sin=readdfs([subbasename1mm,'.left.inner.cortex.svreg.dfs']);
spial=readdfs([subbasename1mm,'.left.pial.cortex.svreg.dfs']);
ld = sqrt(sum((sin.vertices - spial.vertices).^2,2));

sub=readdfs([subbasename1mm,'.left.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = ld;

tar = readdfs(atlas1mm);
ld_1mm=map_data_flatmap(sub,thickness_1mm,tar);




sin=readdfs([subbasename3mm,'.left.inner.cortex.svreg.dfs']);
spial=readdfs([subbasename3mm,'.left.pial.cortex.svreg.dfs']);
ld = sqrt(sum((sin.vertices - spial.vertices).^2,2));

sub=readdfs([subbasename3mm,'.left.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = ld;

tar = readdfs(atlas3mm);
ld_3mm=map_data_flatmap(sub,thickness_3mm,tar);





sl = readdfs('/home/ajoshi/projects/pvcthickness/hires_lowres_comparison/lowres_data/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs');

sl.attributes = abs(ld_3mm - ld_1mm);
sl.attributes=smooth_surf_function(sl,sl.attributes);


h=figure;

patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,5]);colormap jet;
 view(-90,0);camlight('headlight'); material dull;
 saveas(h,'LD_left_hires_lowres_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'LD_left_hires_lowres_2.png')
close all;


save hires_lowres_left_ld

