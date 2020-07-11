%||AUM||
opengl software;
clc;clear ;close all;
restoredefaultpath;
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/dev'));
addpath(genpath('/home/ajoshi/git_sandbox/svreg-matlab/src'));
addpath(genpath('/home/ajoshi/freesurfer/matlab'));


str='3m1p5t_left';
load(str);

diff_fs=mean(abs(diff_fs),2);
diff_ale=mean(abs(diff_ale)/1.75,2);
diff_le=mean(abs(diff_le)/1.75,2);
diff_ld=mean(abs(diff_ld)/1.75,2);

edg=linspace(0,1,100);
h=figure;
hst_fs=histc(diff_fs,edg); plot(edg,hst_fs,'k','LineWidth',2,'linestyle','--');hold on;
hst_ale=histc(diff_ale,edg); plot(edg,hst_ale,'r','LineWidth',2);
hst_le=histc(diff_le,edg); plot(edg,hst_le,'g','LineWidth',2,'linestyle','-.');
hst_ld=histc(diff_ld,edg); plot(edg,hst_ld,'b','LineWidth',2,'linestyle',':');
legend('FS','ALE','LE','LD');

saveas(h,[str,'.png']);

