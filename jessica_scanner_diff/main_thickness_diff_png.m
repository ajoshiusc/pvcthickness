%||AUM||
opengl software;
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));
addpath(genpath('/home/ajoshi/freesurfer/matlab'));


load 1p5m1p5t_right

src=ave;
diff_fs=diff_fs/1.65;
h=figure;
patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',mean(diff_fs,2),'edgecolor','none','facecolor','interp');
axis on;axis equal;caxis([-0.75,.75]);axis off;
view(90,0);camlight('headlight');material dull;
saveas(h,sprintf('diff_thickness_fs_1p5m1p5t_right_1.png'));
autocrop_img(sprintf('diff_thickness_fs_1p5m1p5t_right_1.png'));
view(-90,0);camlight('headlight');material dull;
saveas(h,sprintf('diff_thickness_fs_1p5m1p5t_right_2.png'));
autocrop_img(sprintf('diff_thickness_fs_1p5m1p5t_right_2.png'));


h=figure;
patch('vertices',src.vertices,'faces',src.faces,'facevertexcdata',mean(abs(diff_fs),2),'edgecolor','none','facecolor','interp');
axis on;axis equal;caxis([0,.75]);axis off;
view(90,0);camlight('headlight');material dull;
saveas(h,sprintf('abs_diff_thickness_fs_1p5m1p5t_right_1.png'));
autocrop_img(sprintf('abs_diff_thickness_fs_1p5m1p5t_right_1.png'));
view(-90,0);camlight('headlight');material dull;
saveas(h,sprintf('abs_diff_thickness_fs_1p5m1p5t_right_2.png'));
autocrop_img(sprintf('abs_diff_thickness_fs_1p5m1p5t_right_2.png'));
