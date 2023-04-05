clc;clear ;close all;
restoredefaultpath;
addpath(genpath('C:/Users/ajoshi/Documents/coding_ground/svreg-matlab/dev'));
addpath(genpath('C:/Users/ajoshi/Documents/coding_ground/svreg-matlab/src'));

% tic;
% svreg C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_09.07\0003\co20050723_090747MPRAGET1Coronals003a001 -P -S
% toc
% svreg C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_09.53\0002\co20050723_095319s002a1001 -P -S
% toc
% svreg C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_11.02\0003\co20050723_110235Flash3Dt1CORONALs003a001 -P -S
% toc
s1=readdfs('C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_09.07\0003\atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs');
s2=readdfs('C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_09.53\0002\atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs');
s3=readdfs('C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_11.02\0003\atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs');

th_diff=s2.attributes-s3.attributes;
th_diff=smooth_surf_function(s1,th_diff);

sr=smooth_cortex_fast(s1,.1,6000);
std_thr=th_diff;
% std_thriso=std(thicknessriso,[],2);
% std_thrld=std(thicknessrld,[],2);

Tl=triangulation(sr.faces,sr.vertices);
[bvl]=Tl.freeBoundary;bvl=unique(bvl(:));
std_thr(bvl)=0;        std_thriso(bvl)=0;        std_thrld(bvl)=0;


src=close_surf(sr);
srco=src;

[~,~,ia]=intersect(sr.vertices,src.vertices,'rows','stable');
std_thrc=zeros(length(src.vertices),1);
std_thrc(ia)=std_thr;
%       std_thrisoc=zeros(length(src.vertices),1);
%       std_thrisoc(ia)=std_thriso;
%       std_thrldc=zeros(length(src.vertices),1);
%       std_thrldc(ia)=std_thrld;



h=figure;
patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',std_thrc,'edgecolor','none','facecolor','interp');
axis on;axis equal;caxis([-0.75,.75]);axis off;colormap jet;
view(90,0);camlight('headlight');material dull;
%         saveas(h,sprintf('std_dev_thickness_ALE_sub%d_r_1.png',jj));
%         autocrop_img(sprintf('std_dev_thickness_ALE_sub%d_r_1.png',jj));
%         view(-90,0);camlight('headlight');material dull;
%         saveas(h,sprintf('std_dev_thickness_ALE_sub%d_r_2.png',jj));
%         autocrop_img(sprintf('std_dev_thickness_ALE_sub%d_r_2.png',jj));
%
