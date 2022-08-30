%||AUM||
opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/dev'));
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/src'));

subbasename1mm='/home/ajoshi/brainweb/1mm/t1_icbm_normal_1mm_pn3_rf20_uint16'
atlas1mm='/home/ajoshi/brainweb/1mm/atlas.left.mid.cortex.svreg.dfs';

subbasename3mm='/home/ajoshi/brainweb/3mm/t1_icbm_normal_3mm_pn3_rf20_uint16'
atlas3mm='/home/ajoshi/brainweb/3mm/atlas.left.mid.cortex.svreg.dfs';

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





sl = readdfs('/home/ajoshi/brainweb/3mm/atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs');

sl.attributes = abs(ld_3mm - ld_1mm);
%sl.attributes=smooth_surf_function(sl,sl.attributes);


figure;

patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,.75]);colormap jet;
 view(-90,0);camlight('headlight'); material dull;

save 3mm_1mm_left_ld

