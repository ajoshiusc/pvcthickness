%||AUM||
opengl software
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/3rdParty'));

subbasename1mm='/home/ajoshi/brainweb/1mm/t1_icbm_normal_1mm_pn3_rf20_uint16'
atlas1mm='/home/ajoshi/brainweb/1mm/atlas.right.mid.cortex.svreg.dfs';

subbasename3mm='/home/ajoshi/brainweb/3mm/t1_icbm_normal_3mm_pn3_rf20_uint16'
atlas3mm='/home/ajoshi/brainweb/3mm/atlas.right.mid.cortex.svreg.dfs';

sin=readdfs([subbasename1mm,'.right.inner.cortex.svreg.dfs']);
spial=readdfs([subbasename1mm,'.right.pial.cortex.svreg.dfs']);
ld = sqrt(sum((sin.vertices - spial.vertices).^2,2));

sub=readdfs([subbasename1mm,'.right.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_1mm = ld;

tar = readdfs(atlas1mm);
ld_1mm=map_data_flatmap(sub,thickness_1mm,tar);




sin=readdfs([subbasename3mm,'.right.inner.cortex.svreg.dfs']);
spial=readdfs([subbasename3mm,'.right.pial.cortex.svreg.dfs']);
ld = sqrt(sum((sin.vertices - spial.vertices).^2,2));

sub=readdfs([subbasename3mm,'.right.mid.cortex.svreg.dfs']);
%smooth_surf_function(sl,sl.attributes);
thickness_3mm = ld;

tar = readdfs(atlas3mm);
ld_3mm=map_data_flatmap(sub,thickness_3mm,tar);





sl = readdfs('/home/ajoshi/brainweb/3mm/atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs');

sl.attributes = abs(ld_3mm - ld_1mm);
sl.attributes=smooth_surf_function(sl,sl.attributes);


h=figure;

patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
axis equal;axis off;camlight;axis tight;
caxis([0,5]);colormap jet;
 view(-90,0);camlight('headlight'); material dull;
 saveas(h,'LD_right_brainweb_1.png')
view(90,0);camlight('headlight'); 
saveas(h,'LD_right_brainweb_2.png')
close all;


save 3mm_1mm_right_ld

