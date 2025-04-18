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


def thicknessPVC(sub):
    # cortical thickness computation
    subbase = join("/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/", sub, "t1")

    if isfile(subbase + ".right.pial.cortex.svreg.dfs"):
        if not isfile(
            join(
                "/big_disk/ajoshi/coding_ground/pvcthickness/HCP_data/",
                sub,
                "atlas.pvc-thickness_0-6mm.right.mid.cortex.dfs",
            )
        ):

            system(
                "/home/ajoshi/BrainSuite18a/svreg/bin/thicknessPVC.sh "
                + subbase
                + " >/dev/null 2>&1"
            )


def bstsvreg(subbasename):
    # run brainsuite and svreg on the original image
    if not isfile('' + subbasename + '.right.pial.cortex.dfs'):
        # perform brainsuite and svreg processing
        exe_name = "/home1/ajoshi/Projects/pvcthickness/cortical_extraction_nobse.sh"
        if not os.path.isfile(exe_name):
            exe_name = "/home/ajoshi/Projects/pvcthickness/cortical_extraction_nobse_local.sh"
        
        #system(f"{exe_name} {subbasename}")
        system(f"sbatch /home1/ajoshi/Projects/pvcthickness/run_script.job \'{exe_name} {subbasename}\'")

    if not isfile('' + subbasename + '.right.pial.cortex.svreg.dfs'):
        # run svreg
        exe_name = "/home1/ajoshi/Projects/SVRegSource000/compile_scripts/svreg_99_build9900_linux/bin/svreg.sh"
        if not os.path.isfile(exe_name):
            exe_name = "/home/ajoshi/Software/BrainSuite21a/svreg/bin/svreg.sh"

        #system(f"module load matlab/2024a; export BrainSuiteMCR=/apps/generic/matlab/2024a/; {exe_name} {subbasename}")
        #system(f"sbatch /home1/ajoshi/Projects/pvcthickness/run_script.job \'{exe_name} {subbasename}\'")


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

    if not os.path.isdir(outdir):
        makedirs(outdir)

    # /*/T1w_acpc_dc_restore_brain.nii.gz

    # make output dirs for 4 different resolutions, orig, 1mm, 2mm, 3mm
    for sub in tqdm(hcpsubs):
        outdir_sub = join(outdir, sub)
        if not os.path.isdir(outdir_sub):
            makedirs(outdir_sub)
        for res in ["orig", "1mm", "2mm", "3mm"]:
            if not os.path.isdir(join(outdir_sub, res)):
                makedirs(join(outdir_sub, res))

    # copy the original image to the  orig output directory
    for sub in tqdm(hcpsubs):
        t1file = join(
            hcp_proj11183,
            "volume1/masal/big_disk/ajoshi/ajoshi/HCP100_struct",
            sub,
            "T1w",
            "T1w_acpc_dc_restore.nii.gz",
        )
        t1bsefile = join(
            hcp_proj11183,
            "volume1/masal/big_disk/ajoshi/ajoshi/HCP100_struct",
            sub,
            "T1w",
            "T1w_acpc_dc_restore_brain.nii.gz",
        )
        outdir_sub = join(outdir, sub)
        if isfile(t1file):
            copyfile(t1file, join(outdir_sub, "orig", "t1.nii.gz"))
            copyfile(t1bsefile, join(outdir_sub, "orig", "t1.bse.nii.gz"))
            # make a brain mask
            msk = compute_background_mask(t1bsefile)
            msk.to_filename(join(outdir_sub, "orig", "t1.mask.nii.gz"))

    # resample to 1mm, 2mm, 3mm in the corresponding directories
    for sub in tqdm(hcpsubs):
        outdir_sub = join(outdir, sub)
        t1file = join(outdir_sub, "orig", "t1.nii.gz")
        t1bsefile = join(outdir_sub, "orig", "t1.bse.nii.gz")

        if not isfile(t1file):
            continue
        for res in ["1mm", "2mm", "3mm"]:
            outdir_res = join(outdir_sub, res)
            if not isfile(join(outdir_res, "t1.nii.gz")):
                resample_img(
                    t1file,
                    target_affine=np.eye(3) * float(res[:-2]),
                    interpolation="nearest",
                    force_resample=True,
                    copy_header=True,
                ).to_filename(join(outdir_res, "t1.nii.gz"))

            if not isfile(join(outdir_res, "t1.bse.nii.gz")):
                resample_img(
                    t1bsefile,
                    target_affine=np.eye(3) * float(res[:-2]),
                    interpolation="nearest",
                    force_resample=True,
                    copy_header=True,
                ).to_filename(join(outdir_res, "t1.bse.nii.gz"))

                # make a brain mask
                msk = compute_background_mask(join(outdir_res, "t1.bse.nii.gz"))
                msk.to_filename(join(outdir_res, "t1.mask.nii.gz"))

    # run brainsuite and svreg on all the images
    for sub in hcpsubs:
        outdir_sub = join(outdir, sub)
        t1file = join(outdir_sub, "orig", "t1.nii.gz")
        if not isfile(t1file):
            continue
        # run brainsuite and svreg on the original image
        bstsvreg(t1file.replace(".nii.gz", ""))
        # run brainsuite and svreg on the 1mm image
        t1file = join(outdir_sub, "1mm", "t1.nii.gz")
        if not isfile(t1file):
            continue
        bstsvreg(t1file.replace(".nii.gz", ""))
        # run brainsuite and svreg on the 2mm image
        t1file = join(outdir_sub, "2mm", "t1.nii.gz")
        if not isfile(t1file):
            continue
        bstsvreg(t1file.replace(".nii.gz", ""))
        # run brainsuite and svreg on the 3mm image
        t1file = join(outdir_sub, "3mm", "t1.nii.gz")
        if not isfile(t1file):
            continue
        bstsvreg(t1file.replace(".nii.gz", ""))


if __name__ == "__main__":
    main()
