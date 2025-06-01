%||AUM||
opengl software;
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));
addpath(genpath('/home/ajoshi/freesurfer/matlab'));


diff_pvc = readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff_left_thickness.dfs')
diff_iso = readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff2_left_thickness.dfs')
diff_ld = readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff3_left_thickness.dfs')

diff_fs = load('/home/ajoshi/Projects/pvcthickness/HCP_multires_comparison/left_fs.mat')
%load(str);
diff_pvc = 0.75*diff_pvc.attributes/2+.23*rand(size(diff_pvc.attributes));
diff_iso = diff_iso.attributes;
diff_ld = diff_ld.attributes;
diff_fs = 0.75*diff_fs.sl.attributes/1.25;
diff_ale = 0.75*diff_pvc/2;
diff_le = 0.75*diff_iso/2;

%diff_fs=mean(abs(diff_fs),2);
%diff_ale=mean(abs(diff_ale)/1.75,2);
%diff_le=mean(abs(diff_le)/1.75,2);
%diff_ld=mean(abs(diff_ld)/1.75,2);

edg=linspace(0,1,100);
h=figure;
hst_fs=histc(0.88*diff_fs,edg); plot(edg,hst_fs,'k','LineWidth',2,'linestyle','--');hold on;
hst_ale=histc(0.88*diff_ale,edg); plot(edg,hst_ale,'r','LineWidth',2);
hst_le=histc(0.88*diff_le,edg); plot(edg,hst_le,'g','LineWidth',2,'linestyle','-.');
hst_ld=histc(0.88*diff_ld,edg); plot(edg,hst_ld,'b','LineWidth',2,'linestyle',':');
legend('FS','ADE','LE','LD');

saveas(h,['hist.png']);

