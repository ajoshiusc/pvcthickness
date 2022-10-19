clear; clc;
restoredefaultpath;
addpath(genpath('C:\Users\ajoshi\Downloads\register_files_affine_v12'));
addpath(genpath('C:/Users/ajoshi/Documents/coding_ground/svreg-matlab/src'));
%target_dir = ''
%scan_suffix = {'_MR1', '_MR2'};


scan1 = 'C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_09.07\0003\co20050723_090747MPRAGET1Coronals003a001';
scan2 = 'C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_09.53\0002\co20050723_095319s002a1001';
%scan2 = 'C:\Users\ajoshi\Downloads\jessica_6_subs_n4\SUBJECT1\2005.07.23_11.02\0003\co20050723_110235Flash3Dt1CORONALs003a001';
moving_filename = [scan1,'.bfc.nii.gz'];
static_filename = [scan2,'.bfc.nii.gz'];
output_filename = [scan2,'.warped.nii.gz'];

scan1_msk = [scan1,'.mask.nii.gz'];
scan1_mskd2 = [scan1,'.2dilated.mask.nii.gz'];
scan2_msk = [scan2,'.mask.nii.gz'];
warped_msk = [scan2,'.mask.nii.gz'];
warped_mskd2 = [scan2,'.2dilated.mask.nii.gz'];

if exist([scan2_msk,'.orig'],'file')
    copyfile([scan2_msk,'.orig'],scan2_msk);
end
fixBSheader(moving_filename, scan1_msk, scan1_msk);

copyfile(scan2_msk, [scan2_msk,'.orig']);

% Check/set input options
opts = struct( ...
    'similarity', 'sd', ...  See comments
    'dof', 6, ...          See comments
    'axis_translation', [],  ... 1/2/3, defines the translation axis for dof<3
    'intensity_norm', '',... histeq/sigmoid/none - intensity normalization prior to registration, when empty sets appropriately based on similarity
    'static_mask', scan2_msk, ... filename for mask of <static_filename>
    'moving_mask', scan1_msk, ... filename for mask of <moving_filename>
    'BST_masks', true, ... Interpret mask files as masks saved by BrainSuite (allow inconsistent headers)
    'mask_op', 'or',     ... Error mask: and / or of indivdual masks
    'pngout', true,   ... write overlay images in png format
    'reg_res', 1.5,    ... Resolution in mm (isotropic) to be used for registration
    'verbose', false,  ... Show optimization/processing details
    'nbins', 128,      ... Number of bins for histeq and MI based registration
    'parzen_width', 8, ... Width of parzen window for histogram estimation
    'log_lookup', false, ... When true, uses log lookup table for computing log()
    'log_thresh', 1/(128*128*2), ... Lower threshold to skip log() when NOT using log-lookup; roughly related to nbins
    'step_size', [],   ... Step size for cost optimization, when empty sets appropriately depending on similarity
    'CFn_opts', struct(), ... cost function options, when empty sets appropriately depending on similarity & other options (overrides other options)
    'nthreads', 6,    ... Number of (possible) parallel threads to use
    'non_uniformity_correction', false, ... Makes sense only if images are corsely-pre-registered
    'init_opts', struct('init_method', 'search', 'search_range',[60 60 60], ...
    'search_delta',[15 15 15], 'search_imres',5) ...
    );


[M_world, ref_loc, x_param] = register_files_affine(moving_filename, static_filename, output_filename, opts);

transform_data_affine(scan1_msk, 'm', warped_msk, ...
    moving_filename, static_filename, [remove_extension(output_filename) '.rigid_registration_result.mat'], 'nearest')

transform_data_affine(scan1_msk, 'm', warped_mskd2, ...
    moving_filename, static_filename, [remove_extension(output_filename) '.rigid_registration_result.mat'], 'nearest')
