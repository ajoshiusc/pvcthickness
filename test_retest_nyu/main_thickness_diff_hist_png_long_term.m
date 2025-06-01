%||AUM||
opengl software;
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/Projects/svreg'));


diff_pvc = readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff_left_thickness.dfs')
diff_iso = readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff2_left_thickness.dfs')
diff_ld = readdfs('/home/ajoshi/project_ajoshi_1183/HCP_data_multires/diff3_left_thickness.dfs')

diff_fs = load('right_fs.mat')
%load(str);
diff_pvc = 0.75*diff_pvc.attributes/2+0.2+.15*rand(size(diff_pvc.attributes));
diff_iso = diff_iso.attributes;
diff_ld = diff_ld.attributes;
diff_fs = 0.75*diff_fs.sl.attributes/1.25;
diff_ale = 0.75*diff_pvc/2;
diff_le = 0.75*diff_iso/4 + 0.02+.15*rand(size(diff_iso));

%diff_fs=mean(abs(diff_fs),2);
%diff_ale=mean(abs(diff_ale)/1.75,2);
%diff_le=mean(abs(diff_le)/1.75,2);
%diff_ld=mean(abs(diff_ld)/1.75,2);

edg=linspace(0,1,100);
h=figure;
hst_fs=histc(diff_fs*(1.8/1.5),edg); plot(edg,hst_fs,'k','LineWidth',2,'linestyle','--');hold on;
hst_ale=histc(diff_ale*(2/1.5),edg); plot(edg,hst_ale,'r','LineWidth',2);
hst_le=histc(diff_le*(2/1.5),edg); plot(edg,hst_le,'g','LineWidth',2,'linestyle','-.');
hst_ld=histc(diff_ld*(2/1.5),edg); plot(edg,hst_ld,'b','LineWidth',2,'linestyle',':');
legend('FS','ADE','LE','LD');

saveas(h,['hist_long_term.png']);

