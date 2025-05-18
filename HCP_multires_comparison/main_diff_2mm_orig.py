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

    hcp_proj11183 = "/project/ajoshi_1183"
    outdir = join("/project/ajoshi_1183/HCP_data_multires")

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
    for sub in tqdm(hcpsubs):
        outdir_sub = join(outdir, sub)

        hires_left_file = join(outdir_sub, "orig", "atlas.pvc_thickness.left.svreg.dfs")
        lowres_left_file = join(outdir_sub, "orig", "atlas.pvc_thickness.left.svreg.dfs")
        hires_right_file = join(outdir_sub, "orig", "atlas.pvc_thickness.right.svreg.dfs")
        lowres_right_file = join(outdir_sub, "orig", "atlas.pvc_thickness.right.svreg.dfs")


        hires_left_thickness = readdfs(hires_left_file)
        lowres_left_thickness = readdfs(lowres_left_file)
        hires_right_thickness = readdfs(hires_right_file)
        lowres_right_thickness = readdfs(lowres_right_file)
        diff_left_thickness = hires_left_thickness - lowres_left_thickness
        diff_right_thickness = hires_right_thickness - lowres_right_thickness
        diff_left_thickness = np.abs(diff_left_thickness)
        diff_right_thickness = np.abs(diff_right_thickness)
        diff_left_thickness_all.append(diff_left_thickness)
        diff_right_thickness_all.append(diff_right_thickness)
    

    # take average of the differences over all subjects and save as dfs
    diff_left_thickness_all = np.array(diff_left_thickness_all)
    diff_right_thickness_all = np.array(diff_right_thickness_all)
    diff_left_thickness_all = np.mean(diff_left_thickness_all, axis=0)
    diff_right_thickness_all = np.mean(diff_right_thickness_all, axis=0)

    # save as dfs
    writedfs(
        diff_left_thickness_all,
        join(outdir, "diff_left_thickness.dfs"),
        sub_list[0],
    )
    writedfs(
        diff_right_thickness_all,
        join(outdir, "diff_right_thickness.dfs"),
        sub_list[0],
    )







if __name__ == "__main__":
    main()
