clc;clear ;close all;
restoredefaultpath;
addpath(genpath('C:/Users/ajoshi/Documents/coding_ground/svreg-matlab/dev'));
addpath(genpath('C:/Users/ajoshi/Documents/coding_ground/svreg-matlab/src'));
dirs={'SUBJECT1_default_n4_manual_mask_dilation','SUBJECT1_default_bfc_manual_mask','SUBJECT1_default_bfc_manual_mask_dilate1','SUBJECT1_default_bfc4_manual_mask_dilation','SUBJECT1_default_n4_bfc_manual_mask_dilation','SUBJECT1_default_n4_manual_mask_dilation'};

parfor jj=1:length(dirs)

    tic;
        thicknessISO(['C:\Users\ajoshi\Downloads\jessica_6_subs_n4\',dirs{jj},'\2005.07.23_09.07\0003\co20050723_090747MPRAGET1Coronals003a001']); 
    toc
        thicknessISO(['C:\Users\ajoshi\Downloads\jessica_6_subs_n4\',dirs{jj},'\2005.07.23_09.53\0002\co20050723_095319s002a1001']); 
    toc
        thicknessISO(['C:\Users\ajoshi\Downloads\jessica_6_subs_n4\',dirs{jj},'\2005.07.23_11.02\0003\co20050723_110235Flash3Dt1CORONALs003a001']); 
    toc

end


