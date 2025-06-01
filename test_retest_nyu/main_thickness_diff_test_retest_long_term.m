clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/Projects/svreg/dev'));
addpath(genpath('/home/ajoshi/Projects/svreg/src'));


sl=readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff3_left_thickness.dfs');
%smooth_surf_function(sl,sl.attributes);
thickness_left = min(max(sl.attributes,0),1);

sr=readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff3_right_thickness.dfs');
%smooth_surf_function(sl,sl.attributes);
thickness_right = min(max(sr.attributes,0),1);


sl.attributes = abs(thickness_left)

pvc_val = 2*sl.attributes
pvc_val=smooth_surf_function(sl,pvc_val);

Tl=triangulation(sl.faces,sl.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
pvc_val(bvl)=0;        iso_val(bvl)=0;        ls_val(bvl)=0;


slc=close_surf(sl);
slco=slc;

[~,~,ia]=intersect(sl.vertices,slc.vertices,'rows','stable');
pvc_valc=zeros(length(slc.vertices),1);
pvc_valc(ia)=pvc_val;
iso_valc=zeros(length(slc.vertices),1);
iso_valc(ia)=iso_valc;
ld_valc=zeros(length(slc.vertices),1);
ld_valc(ia)=ld_valc;


sl=smooth_cortex_fast(sl,.5,5000);

h=figure;
patch('vertices',slc.vertices,'faces',slc.faces,'facevertexcdata',(pvc_valc),'edgecolor','none','facecolor','interp');
axis on;axis equal;caxis([0,1.5]);axis off;
view(90,0);camlight('headlight');material dull;
saveas(h,'thickness3_PVC_left1.png');
autocrop_img('thickness2_PVC_left1.png');
view(-90,0);camlight('headlight');material dull;
saveas(h,'thickness3_PVC_left2.png');
autocrop_img('thickness3_PVC_left2.png');



% plot right hemisphere

pvc_val = 2* sr.attributes
pvc_val=smooth_surf_function(sr,pvc_val);

Tl=triangulation(sr.faces,sr.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
pvc_val(bvl)=0;        iso_val(bvl)=0;        ls_val(bvl)=0;


src=close_surf(sr);
srco=src;

[~,~,ia]=intersect(sr.vertices,src.vertices,'rows','stable');
pvc_valc=zeros(length(src.vertices),1);
pvc_valc(ia)=pvc_val;
iso_valc=zeros(length(src.vertices),1);
iso_valc(ia)=iso_valc;
ld_valc=zeros(length(src.vertices),1);
ld_valc(ia)=ld_valc;


sr=smooth_cortex_fast(sr,.5,5000);

h=figure;
patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',(pvc_valc),'edgecolor','none','facecolor','interp');
axis on;axis equal;caxis([0,1.5]);axis off;
view(90,0);camlight('headlight');material dull;
saveas(h,'thickness3_PVC_right1.png');
autocrop_img('thickness3_PVC_right1.png');
view(-90,0);camlight('headlight');material dull;
saveas(h,'thickness3_PVC_right2.png');
autocrop_img('thickness3_PVC_right2.png');




% 
% h=figure;
% 
% 
% patch('vertices',sl.vertices,'faces',sl.faces,'facevertexcdata',sl.attributes,'facecolor','interp','edgecolor','none');
% axis equal;axis off;camlight;axis tight;
% caxis([0,5]);colormap jet;material dull;
% view(-90,0);camlight('headlight'); 
% saveas(h,'diff_hires_lowres_1.png')
% view(90,0);camlight('headlight'); 
% saveas(h,'diff_hires_lowres_2.png')
% close all;
% 
% 
