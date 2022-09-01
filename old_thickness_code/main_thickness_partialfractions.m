clc;clear all;close all;
restoredefaultpath;
addpath(genpath('/home/biglab/Easswar/svreg-matlab/src'));
addpath(genpath('/home/biglab/Easswar/svreg-matlab/dev'));
atlasbasename='/home/biglab/Easswar/svreg-matlab/BrainSuiteAtlas1/mri';
lst=dir('/home/ajoshi/fcon_1000/Beijing/sub*');

for jj=1:length(lst)
   subbasename=['/home/ajoshi/fcon_1000/Beijing/',lst(jj).name, '/anat/mprage_anonymized']
  % svreg(subbasename,atlasbasename,'-rv2');
   thickness_pvc_ourmid(subbasename);
   jj
end

