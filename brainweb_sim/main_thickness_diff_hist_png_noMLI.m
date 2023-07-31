opengl software;
clc;clear ;close all;
restoredefaultpath;

ld=load('3mm_1mm_left_ld');
diff_ld = ld.sl.attributes;

pvc=load('3mm_1mm_left_pvc.mat');
diff_pvc = pvc.sl.attributes;

iso=load('3mm_1mm_left_iso.mat');
diff_iso = iso.sl.attributes;

fs=load('3mm_1mm_left_fs.mat');
diff_fs = fs.sl.attributes;

MLI=load('3mm_1mm_left_MLI.mat');
diff_MLI = MLI.sl.attributes;



edg=linspace(0,6,100);
h=figure;
hst_pvc=histc(diff_pvc,edg); plot(edg,hst_pvc,'r','LineWidth',4);hold on;
hst_iso=histc(diff_iso,edg); plot(edg,hst_iso,'g','LineWidth',4,'linestyle','-.');
hst_fs=histc(diff_fs,edg); plot(edg,hst_fs,'k','LineWidth',4,'linestyle','-.');
hst_ld=histc(diff_ld,edg); plot(edg,hst_ld,'b','LineWidth',4,'linestyle',':');
%hst_MLI=histc(diff_MLI,edg); plot(edg,hst_MLI,'k','LineWidth',2);%,'linestyle',':');

legend('ADE','LE','FS','LD');


