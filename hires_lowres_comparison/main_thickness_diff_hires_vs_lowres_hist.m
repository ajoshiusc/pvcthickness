
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/dev'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/3rdParty'));
addpath(genpath('/home/ajoshi/projects/BrainSuite/svreg/src'));
addpath(genpath('/home/ajoshi/projects/pvcthickness/old_thickness_code'));


load('hires_lowres_right_fs.mat')
diff_fs=sl.attributes;

diff_fs(diff_fs<1e-2)=[];

load('hires_lowres_right_pvc.mat')
diff_ale=sl.attributes;



load('hires_lowres_right_iso.mat')
diff_le=sl.attributes;



load('hires_lowres_right_ld.mat')
diff_ld=sl.attributes;



edg=linspace(0,.75,100);
h=figure;
hst_ale=histc(diff_ale,edg); plot(edg,hst_ale,'r','LineWidth',2);hold on;
hst_le=histc(diff_le,edg); plot(edg,hst_le,'g','LineWidth',2,'linestyle','-.');
hst_ld=histc(diff_ld,edg); plot(edg,hst_ld,'b','LineWidth',2,'linestyle',':');
hst_fs=histc(diff_fs,edg); plot(edg,2.3*hst_fs,'k','LineWidth',2,'linestyle','--');hold on;


legend('ADE','LE','LD','FS');

xlabel('Thickness difference in mm');
ylabel('Number of vertices in cortical mesh');

saveas(h,['hires_lowres_hist_2023.png']);
saveas(h,['hires_lowres_hist_2023.svg']);
saveas(h,['hires_lowres_hist_2023.pdf']);


