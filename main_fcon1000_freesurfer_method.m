opengl software;
clc;clear all;close all;
restoredefaultpath;
addpath(genpath('/ImagePTE1/ajoshi/code_farm/svreg/src'))
addpath(genpath('/ImagePTE1/ajoshi/code_farm/pvcthickness'));

lst=dir('/big_disk/ajoshi/fcon_1000/Beijing/su*');

parpool(6);

parfor jj=1:length(lst)
    subbasename=['/big_disk/ajoshi/fcon_1000/Beijing/',lst(jj).name, '/anat/BST/mprage_mni'];

    anatDir=['/big_disk/ajoshi/fcon_1000/Beijing/',lst(jj).name, '/anat/BST'];

    if ~exist([anatDir,'/atlas_fs_thickness.right.mid.cortex.svreg.dfs'],'file')
        try
            thickness_freesurfer(subbasename);
            map_fsthickness2atlas(subbasename)

            jj

        catch
            fprintf('skippig subject %s',subbasename);
        end
    end
end
