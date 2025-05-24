# AUM
# ||Shree Ganeshaya Namaha||

import pandas as pd
from tqdm import tqdm
from time import sleep
from shutil import copyfile
from os import makedirs, system
from os.path import join, isfile
from multiprocessing import Pool
from nilearn.image import resample_img
import numpy as np
from nilearn.masking import compute_background_mask
import glob
import os
from dfsio import readdfs, writedfs



def main():

    hcp_proj11183 = "/home/ajoshi/project_ajoshi_1183"
    outdir = join("/home/ajoshi/project_ajoshi_1183/HCP_data_multires")

    # get a list of subjects
    sub_list = glob.glob(
        f"{hcp_proj11183}/volume1/masal/big_disk/ajoshi/ajoshi/HCP100_struct/*"
    )

    hcpsubs = [os.path.basename(x) for x in sub_list]

    if not os.path.isdir(hcp_proj11183):
        # this means I am running on my local machine
        # so only process 2 subjects
        hcp_proj11183 = "/home/ajoshi/project_ajoshi_1183"
        outdir = join("/home/ajoshi/HCP_data_multires")
        sub_list = glob.glob(
            f"{hcp_proj11183}/volume1/masal/big_disk/ajoshi/ajoshi/HCP100_struct/*"
        )
        hcpsubs = [os.path.basename(x) for x in sub_list]
        hcpsubs = hcpsubs[:2]

    # /*/T1w_acpc_dc_restore_brain.nii.gz

    diff_left_thickness_all = []
    diff_right_thickness_all = []
    # make output dirs for 4 different resolutions, orig, 1mm, 2mm, 3mm
    
    
    hcpsubs = hcpsubs[8:10]

    for sub in tqdm(hcpsubs):
        outdir_sub = join(outdir, sub)

        hires_left_file = join(outdir_sub, "orig", "atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs")
        lowres_left_file = join(outdir_sub, "1mm", "atlas.pvc-thickness_0-6mm.left.mid.cortex.dfs")
        hires_right_file = join(outdir_sub, "orig", "atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs")
        lowres_right_file = join(outdir_sub, "1mm", "atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs")



        if not isfile(hires_left_file) or not isfile(lowres_left_file) or not isfile(hires_right_file) or not isfile(lowres_right_file):
            print(f"Missing files for {sub}. Skipping...")
            continue


        hires_left_thickness = readdfs(hires_left_file)
        lowres_left_thickness = readdfs(lowres_left_file)
        hires_right_thickness = readdfs(hires_right_file)
        lowres_right_thickness = readdfs(lowres_right_file)
        diff_left_thickness = hires_left_thickness.attributes - lowres_left_thickness.attributes
        diff_right_thickness = hires_right_thickness.attributes - lowres_right_thickness.attributes
        diff_left_thickness = np.abs(diff_left_thickness)
        diff_right_thickness = np.abs(diff_right_thickness)
        diff_left_thickness_all.append(diff_left_thickness)
        diff_right_thickness_all.append(diff_right_thickness)
    

    # take average of the differences over all subjects and save as dfs
    diff_left_thickness_all_data = np.array(diff_left_thickness_all)
    diff_right_thickness_all_data = np.array(diff_right_thickness_all)
    diff_left_thickness_all_data = np.mean(diff_left_thickness_all, axis=0)
    diff_right_thickness_all_data = np.mean(diff_right_thickness_all, axis=0)

    # create a new dfs object
    diff_left_thickness_all = readdfs(hires_left_file)
    diff_left_thickness_all.attributes = diff_left_thickness_all_data
    diff_left_thickness_all.attributes = diff_left_thickness_all.attributes.astype(np.float32)
    diff_right_thickness_all = readdfs(hires_right_file)
    diff_right_thickness_all.attributes = diff_right_thickness_all_data
    diff_right_thickness_all.attributes = diff_right_thickness_all.attributes.astype(np.float32)

    # save as dfs
    writedfs(join(outdir, "diff3_left_thickness.dfs"), diff_left_thickness_all)
    writedfs(join(outdir, "diff3_right_thickness.dfs"), diff_right_thickness_all)







if __name__ == "__main__":
    main()
