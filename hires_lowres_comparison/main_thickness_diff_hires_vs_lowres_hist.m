
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/3rdParty'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));
addpath(genpath('/home/ajoshi/projects/pvcthickness/old_thickness_code'));


load('hires_lowres_left_fs.mat')
diff_fs=sl.attributes;


load('hires_lowres_right_pvc.mat')
diff_ale=sl.attributes;



load('hires_lowres_left_iso.mat')
diff_le=sl.attributes;



load('hires_lowres_left_ld.mat')
diff_ld=sl.attributes;



edg=linspace(0,6,100);
h=figure;
hst_fs=histc(diff_fs,edg); plot(edg,hst_fs,'k','LineWidth',2,'linestyle','--');hold on;
hst_ale=histc(diff_ale,edg); plot(edg,hst_ale,'r','LineWidth',2);hold on;
hst_le=histc(diff_le,edg); plot(edg,hst_le,'g','LineWidth',2,'linestyle','-.');
hst_ld=histc(diff_ld,edg); plot(edg,hst_ld,'b','LineWidth',2,'linestyle',':');
legend('ALE','LE','LD');

saveas(h,['hires_lowres_hist.png']);

